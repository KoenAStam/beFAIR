#' Prepare dependency registry for an ETL script
#'
#' Scans a single ETL script for datasource references and source-id
#' assignments, then synchronises the results into `table_dependency`.
#'
#' Two dependency types are recorded:
#' - **datasource**: the script contains the substring `data/<name>.yaml`
#'   anywhere in its text (bare literal or inside `sprintf`/`paste`), which is
#'   resolved to a `datasource_id` in `table_datasource`.
#' - **script**: the script contains the literal assignment
#'   `databook$data$source_id <-`, implying a dependency on `id_mapping.R`
#'   from the same study.
#'
#' @param script_id Character. Path to the ETL script relative to the
#'   FAIRground root (e.g. `"studies/CoHSI1/scripts/participant.R"`).
#' @param con A DBI connection. If `NULL`, the default connection set by
#'   [FAIRgroundConnect()] is used.
#'
#' @return Invisibly `NULL`. Called for its side effects on `table_dependency`.
#'
#' @seealso [databasePrepareScripts()], [databasePrepareDatasources()]
#'
#' @examples
#' \dontrun{
#' FAIRgroundConnect("MY_DSN")
#' databasePrepareDependencies("studies/CoHSI1/scripts/participant.R")
#' }
#'
#' @keywords internal
databasePrepareDependencies <- function(script_id, con = NULL) {
  lg  <- lgr::get_logger("beFAIR")
  con <- FAIRgroundConnection(con)
  today <- format(Sys.Date(), "%Y-%m-%d")
  meta <- yaml::read_yaml(sub("/scripts/[^/]*\\.R$", "/meta.yaml", script_id)) # meta.yaml for info on project
  pillar <- sub("/.*", "", script_id)

  deps <- list()  # each element: list(dependency_type, datasource_id, external_hash, depends_on_script_id)

  # --- Step 1: Datasource dependencies ("data/<name>.yaml" string literals) ---
  lines <- readLines(script_id, warn = FALSE)
  text  <- paste(lines, collapse = "\n")

  # Match "data/<name>.yaml" as a substring anywhere (handles both bare literals
  # and sprintf/paste strings like "studies/%s/data/participant.yaml")
  pat_yaml      <- 'data/([^"\'\\n%/\\s]+\\.yaml)'
  hits          <- gregexpr(pat_yaml, text, perl = TRUE)[[1]]
  pillar_study <- sub("/scripts/[^/]+\\.R$", "", script_id)

  if (hits[1] != -1) {
    ml        <- attr(hits, "match.length")
    cap_start <- attr(hits, "capture.start")
    cap_len   <- attr(hits, "capture.length")
    for (i in seq_along(hits)) {
      yaml_name <- substr(text, cap_start[i], cap_start[i] + cap_len[i] - 1L)  # e.g. "participant.yaml"
      dsrc_id   <- paste0(pillar_study, "/data/", yaml_name)                  # e.g. "studies/CoHSI1/data/participant.yaml"

      row <- tryCatch(
        DBI::dbGetQuery(
          con,
          "SELECT datasource_id, file_hash FROM table_datasource WHERE datasource_id = ?",
          params = list(dsrc_id)
        ),
        error = function(e) NULL
      )

      if (is.null(row) || nrow(row) == 0L) {
        lg$warn("YAML datasource not registered in table_datasource; skipping",
                script_id     = script_id,
                datasource_id = dsrc_id)
        next
      }

      deps[[length(deps) + 1L]] <- list(
        dependency_type = "datasource",
        external_id     = row$datasource_id[[1]],
        external_hash   = row$file_hash[[1]]
      )
    }
  }

  # --- Step 2: ID-mapping dependencies (databook$data$source_id <- assignment) ---
  if (grepl("databook\\$data\\$source_id\\s*<-", text, perl = TRUE) & !grepl("id_mapping.R", script_id)) { # prevent circular dependency for id_mapping.R

    if (pillar == "studies") {
      # for none id_mapping.R scripts depend on study
      id_mapping_path <- paste0("studies/", meta$name, "/scripts/id_mapping.R")
    } else {
      if (is.null(meta$study_ids) || is.na(meta$study_ids)) {
        id_mapping_path <- "unresolved id_mapping.R"
      } else {
        study_ids <- unlist(strsplit(meta$study_ids, ", "))
        studyTable <- DBI::dbReadTable(con, "study") |>
          dplyr::filter(study_id %in% study_ids)
        id_mapping_path <- paste0("studies/", studyTable$name, "/scripts/id_mapping.R")
      }
    }



    for(i in seq_along(id_mapping_path)){
      id_row <- tryCatch(
        DBI::dbGetQuery(
          con,
          "SELECT script_id, script_hash FROM table_script WHERE script_id = ?",
          params = list(id_mapping_path[i])
        ),
        error = function(e) NULL
      )

      deps[[length(deps) + 1L]] <- list(
        dependency_type = "script",
        external_id     = id_mapping_path[i],
        external_hash   = if (!is.null(id_row) && nrow(id_row) > 0L) id_row$script_hash[[1L]] else NA_character_
      )
    }
  }

  # --- Step 3: explicit dependecies in meta.yaml --- !!Work in progress!!
  if(pillar == "analyses"){
    if(!is.null(meta$table_dependecies) && !is.na(meta$table_dependecies)){
      table_dependecies <- meta$table_dependecies
      tables <- unlist(strsplit(table_dependecies, ";"))
    }
  }

  # --- Step 4: Upsert ---
  existing <- tryCatch(
    DBI::dbGetQuery(
      con,
      "SELECT dependency_id, external_hash FROM table_dependency WHERE script_id = ?",
      params = list(script_id)
    ),
    error = function(e) {
      lg$fatal("'table_dependency' does not exist or cannot be accessed",
               error_message = conditionMessage(e))
      stop(e)
    }
  )

  n_inserted <- 0L
  n_updated  <- 0L
  current_ids <- character(0)

  for (dep in deps) {
    dep_id <- .hash( # TODO, better to remove dependence ID as hash, make it sensible
      paste(script_id, dep$dependency_type, dep$external_id, sep = "||"),
      type = "string",
      algo = "md5",
      serialize = FALSE
    )
    current_ids <- c(current_ids, dep_id)

    if (!dep_id %in% existing$dependency_id) {
      DBI::dbExecute(con,
        paste("INSERT INTO table_dependency",
              "(dependency_id, script_id, project_id, dependency_type, external_id,",
              " external_hash, codebook_name, resolved_script_id, created_at, updated_at)",
              "VALUES (?, ?, NULL, ?, ?, ?, NULL, NULL, ?, ?)"),
        params = list(dep_id, script_id, dep$dependency_type, dep$external_id,
             dep$external_hash, today, today))
      n_inserted <- n_inserted + 1L
    } else if (dep$dependency_type == "datasource") {
      old_hash <- existing$external_hash[existing$dependency_id == dep_id]
      if (!isTRUE(dep$external_hash == old_hash)) {
        DBI::dbExecute(con,
          "UPDATE table_dependency SET external_hash = ?, updated_at = ? WHERE dependency_id = ?",
          params = list(dep$external_hash, today, dep_id))
        n_updated <- n_updated + 1L
      }
    }
  }

  # Delete stale rows
  stale_ids <- existing$dependency_id[!existing$dependency_id %in% current_ids]
  n_removed <- 0L
  for (sid in stale_ids) {
    .sqlDeleteRows(con, "table_dependency", "dependency_id", sid)
    n_removed <- n_removed + 1L
  }

  # --- Step 4: Log ---
  n_datasource <- sum(vapply(deps, function(d) d$dependency_type == "datasource", logical(1)))
  n_script     <- sum(vapply(deps, function(d) d$dependency_type == "script",     logical(1)))

  lg$info("databasePrepareDependencies complete",
          script_id    = script_id,
          n_datasource = n_datasource,
          n_script     = n_script,
          n_inserted   = n_inserted,
          n_updated    = n_updated,
          n_removed    = n_removed)

  invisible(NULL)
}
