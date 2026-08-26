#' Prepare the pillar project registry
#'
#' Scans the FAIRground directories for pillar `meta.yaml` files
#' (`studies/`, `experiments/`, `analyses/`), computes folder hashes for
#' their `scripts/` subdirectory, and synchronises `table_project` in the
#' database.
#'
#' For analyses the function also:
#' \enumerate{
#'   \item Parses the optional `dependencies` field in `meta.yaml`.
#'   \item Upserts `analysis_input` rows into `table_dependency`, resolving each
#'         declared dependency to the corresponding `script_id` in
#'         `table_script`.
#'   \item Flags analyses as `up_to_date = 0` when any resolved dependency
#'         script has `queued_for_update = 1` in `table_script`.
#' }
#'
#' @section Dependency syntax:
#' The `dependencies` field in an analysis `meta.yaml` is a YAML list where
#' each entry has the form `<codebook_name>[<id1>,<id2>,...]`.  `id` values
#' are the short pillar IDs stored in `table_project.project_id` (e.g. study
#' `"CHSI1"` or experiment `"Eef536a"`).  Multiple IDs for the same codebook
#' are comma-separated inside the brackets.
#'
#' ```yaml
#' dependencies:
#'   - participant[CHSI1]
#'   - cytofpanel[Eef536a,Eaa52ef]
#' ```
#'
#' @param con A DBI connection. If `NULL`, the default connection set by
#'   [FAIRgroundConnect()] is used.
#'
#' @return Invisibly `NULL`. Called for its side effects.
#'
#' @seealso [databaseUpdate()], [databasePrepareScripts()]
#'
#' @examples
#' \dontrun{
#' FAIRgroundConnect("MY_DSN")
#' databasePrepareProjects()
#' }
#'
#' @export
databasePrepareProjects <- function(con = NULL) {
  lg  <- lgr::get_logger("beFAIR")
  con <- FAIRgroundConnection(con)
  today <- format(Sys.Date(), "%Y-%m-%d")

  # --- Read existing registry tables -----------------------------------------
  existing_projects <- tryCatch(
    DBI::dbReadTable(con, "table_project"),
    error = function(e) {
      lg$fatal("'table_project' does not exist or cannot be accessed",
               error_message = conditionMessage(e),
               caller = "databasePrepareProjects")
      stop(e)
    }
  )

  tbl_script <- tryCatch(
    DBI::dbReadTable(con, "table_script"),
    error = function(e) {
      lg$fatal("'table_script' does not exist or cannot be accessed",
               error_message = conditionMessage(e),
               caller = "databasePrepareProjects")
      stop(e)
    }
  )

  # --- Scan meta.yaml files and upsert table_project -------------------------
  pillar_dirs <- c("studies", "experiments", "analyses")
  n_inserted  <- 0L
  n_updated   <- 0L
  analyses_seen <- character(0)

  for (pillar_dir in pillar_dirs) {
    project_names <- list.dirs(pillar_dir, recursive = FALSE, full.names = FALSE)

    for (project_name in project_names) {
      meta_path <- file.path(pillar_dir, project_name, "meta.yaml")
      if (!file.exists(meta_path)) next

      meta <- tryCatch(
        yaml::read_yaml(meta_path),
        error = function(e) {
          lg$warn("Could not read meta.yaml; skipping",
                  path = meta_path, error_message = conditionMessage(e))
          NULL
        }
      )
      if (is.null(meta)) next

      project_id <- .readPillarId(meta, pillar_dir)
      scripts_dir <- file.path(pillar_dir, project_name, "scripts")
      folder_hash <- .hash(scripts_dir, type = "content")

      if (!project_id %in% existing_projects$project_id) {
        DBI::dbExecute(con,
          paste("INSERT INTO table_project",
                "(project_id, project_name, pillar, folder_hash, up_to_date,",
                " created_at, updated_at)",
                "VALUES (?, ?, ?, ?, ?, ?, ?)"),
          list(project_id, project_name, pillar_dir, folder_hash, 1L, today, today))
        n_inserted <- n_inserted + 1L
        lg$info("Inserted new project",
                project_id = project_id, pillar = pillar_dir)
      } else {
        old_hash <- existing_projects$folder_hash[existing_projects$project_id == project_id]
        if (!isTRUE(folder_hash == old_hash)) {
          DBI::dbExecute(con,
            paste("UPDATE table_project",
                  "SET folder_hash = ?, up_to_date = 0, updated_at = ?",
                  "WHERE project_id = ?"),
            list(folder_hash, today, project_id))
          n_updated <- n_updated + 1L
          lg$info("Updated project (folder hash changed)",
                  project_id = project_id,
                  hash_old = old_hash, hash_new = folder_hash)
        } else {
          DBI::dbExecute(con,
            "UPDATE table_project SET updated_at = ? WHERE project_id = ?",
            list(today, project_id))
        }
      }

      if (pillar_dir == "analyses") {
        analyses_seen <- c(analyses_seen, project_id)
      }
    }
  }

  # Refresh after inserts so dependency resolution can see new rows
  existing_projects <- DBI::dbReadTable(con, "table_project")

  # --- Process analysis dependencies -----------------------------------------
  existing_proj_deps <- tryCatch(
    DBI::dbGetQuery(con,
      "SELECT * FROM table_dependency WHERE dependency_type = 'analysis_input'"),
    error = function(e) {
      lg$fatal("'table_dependency' does not exist or cannot be accessed",
               error_message = conditionMessage(e),
               caller = "databasePrepareProjects")
      stop(e)
    }
  )

  n_deps_inserted <- 0L
  n_deps_updated  <- 0L

  for (project_id in analyses_seen) {
    proj_row     <- existing_projects[existing_projects$project_id == project_id, ]
    project_name <- proj_row$project_name

    meta_path <- file.path("analyses", project_name, "meta.yaml")
    meta <- tryCatch(yaml::read_yaml(meta_path), error = function(e) NULL)
    if (is.null(meta)) next

    raw_deps <- meta$dependencies

    # Remove stale rows when no dependencies declared
    if (is.null(raw_deps) || (is.character(raw_deps) && all(nchar(trimws(raw_deps)) == 0L))) {
      stale_ids <- existing_proj_deps$dependency_id[existing_proj_deps$project_id == project_id]
      if (length(stale_ids) > 0L) {
        for (sid in stale_ids) {
          .sqlDeleteRows(con, "table_dependency", "dependency_id", sid)
        }
        lg$info("Removed dependency rows (dependencies field cleared)",
                project_id = project_id, n_deleted = length(stale_ids))
      }
      next
    }

    # Normalise: accept either a YAML list or a semicolon-delimited string
    if (is.character(raw_deps) && length(raw_deps) == 1L && grepl(";", raw_deps)) {
      raw_deps <- trimws(strsplit(raw_deps, ";")[[1]])
    }

    current_dep_ids <- character(0)

    for (dep_str in raw_deps) {
      dep_str <- trimws(dep_str)
      if (nchar(dep_str) == 0L) next

      # Parse "codebook_name[id1,id2,...]"
      parts <- regmatches(
        dep_str,
        regexec("^([A-Za-z_][A-Za-z0-9_]*)\\[([^\\]]+)\\]$", dep_str, perl = TRUE)
      )[[1]]

      if (length(parts) < 3L) {
        lg$warn("Could not parse dependency entry; skipping",
                project_id = project_id, entry = dep_str)
        next
      }

      cb_name  <- parts[2]
      id_list  <- trimws(strsplit(parts[3], ",")[[1]])

      for (ext_pid in id_list) {
        ext_pid <- trimws(ext_pid)
        if (nchar(ext_pid) == 0L) next

        dep_id <- .hash(
          paste(project_id, cb_name, ext_pid, sep = "||"), type = "string"
        )

        current_dep_ids <- c(current_dep_ids, dep_id)

        # Resolve to script_id
        ext_row <- existing_projects[existing_projects$project_id == ext_pid, ]
        resolved_script_id <- NA_character_

        if (nrow(ext_row) == 0L) {
          lg$warn("Dependency project_id not found in table_project",
                  analysis = project_id, cb_name = cb_name,
                  external_project_id = ext_pid)
        } else {
          candidate <- gsub("\\\\", "/",
            file.path(ext_row$pillar, ext_row$project_name, "scripts",
                      paste0(cb_name, ".R")))
          norm_script_ids <- gsub("\\\\", "/", tbl_script$script_id)
          match_idx <- which(norm_script_ids == candidate)
          if (length(match_idx) > 0L) {
            resolved_script_id <- tbl_script$script_id[match_idx[1]]
          } else {
            lg$warn("Could not resolve dependency to a script_id in table_script",
                    analysis = project_id, cb_name = cb_name,
                    external_project_id = ext_pid, candidate_path = candidate)
          }
        }

        if (!dep_id %in% existing_proj_deps$dependency_id) {
          DBI::dbExecute(con,
            paste("INSERT INTO table_dependency",
                  "(dependency_id, script_id, project_id, dependency_type, external_id,",
                  " external_hash, codebook_name, resolved_script_id, created_at, updated_at)",
                  "VALUES (?, NULL, ?, 'analysis_input', ?, NULL, ?, ?, ?, ?)"),
            list(dep_id, project_id, ext_pid, cb_name,
                 resolved_script_id, today, today))
          n_deps_inserted <- n_deps_inserted + 1L
        } else {
          DBI::dbExecute(con,
            paste("UPDATE table_dependency",
                  "SET resolved_script_id = ?, updated_at = ?",
                  "WHERE dependency_id = ?"),
            list(resolved_script_id, today, dep_id))
          n_deps_updated <- n_deps_updated + 1L
        }
      }
    }

    # Delete stale dependency rows no longer in meta.yaml
    all_deps_for_project <- existing_proj_deps$dependency_id[
      existing_proj_deps$project_id == project_id]
    stale_ids <- all_deps_for_project[!all_deps_for_project %in% current_dep_ids]
    if (length(stale_ids) > 0L) {
      for (sid in stale_ids) {
        .sqlDeleteRows(con, "table_dependency", "dependency_id", sid)
      }
      lg$info("Deleted stale dependency rows",
              project_id = project_id, n_deleted = length(stale_ids))
    }
  }

  # Refresh analysis_input rows after inserts
  existing_proj_deps <- DBI::dbGetQuery(con,
    "SELECT * FROM table_dependency WHERE dependency_type = 'analysis_input'")

  # --- Flag analyses as up_to_date = 0 if any dependency is queued -----------

  analyses_up <- existing_projects$project_id[
    existing_projects$pillar == "analyses" & existing_projects$up_to_date == 1L]

  n_flagged <- 0L
  for (analysis_pid in analyses_up) {
    dep_rows <- existing_proj_deps[
      existing_proj_deps$project_id == analysis_pid &
        !is.na(existing_proj_deps$resolved_script_id), ]

    if (nrow(dep_rows) == 0L) next

    queued <- tbl_script[
      tbl_script$script_id %in% dep_rows$resolved_script_id &
        tbl_script$queued_for_update == 1L, ]

    if (nrow(queued) > 0L) {
      DBI::dbExecute(con,
        "UPDATE table_project SET up_to_date = 0, updated_at = ? WHERE project_id = ?",
        list(today, analysis_pid))
      n_flagged <- n_flagged + 1L
      lg$info("Flagged analysis as not up-to-date (dependency queued for update)",
              analysis = analysis_pid,
              queued_scripts = paste(queued$script_id, collapse = ", "))
    }
  }

  lg$info("databasePrepareProjects complete",
          n_inserted      = n_inserted,
          n_updated       = n_updated,
          n_deps_inserted = n_deps_inserted,
          n_deps_updated  = n_deps_updated,
          n_flagged       = n_flagged)

  invisible(NULL)
}
