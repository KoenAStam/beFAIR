#' Prepare data source registry
#'
#' Scans the FAIRground directories for data-source YAML files (files
#' located in a `data/` subfolder under `studies/`, `experiments/`, and
#' `analyses/`), reads their metadata, computes MD5 hashes for the actual data
#' files they reference, and synchronises `table_datasource` in the database.
#'
#' The function identifies and tracks:
#' - **New YAML files** not yet present in `table_datasource` — inserted with
#'   `present_in_project = 1`.
#' - **Existing YAML files** — all metadata fields and `file_hash` are refreshed.
#' - **Gone YAML files** whose path is no longer found on disk — marked with
#'   `present_in_project = 0`; never deleted from the registry.
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
#' databasePrepareDatasources()
#' }
#'
#' @export
databasePrepareDatasources <- function(con = NULL) {
  lg  <- lgr::get_logger("beFAIR")
  con <- FAIRgroundConnection(con)
  today <- format(Sys.Date(), "%Y-%m-%d")

  # --- Scan directories for *.yaml files in data/ subfolders ---
  rawYamls <- c(
    paste0("studies/",     list.files("studies",     pattern = "\\.yaml$", recursive = TRUE)),
    paste0("experiments/", list.files("experiments", pattern = "\\.yaml$", recursive = TRUE)),
    paste0("analyses/",    list.files("analyses",    pattern = "\\.yaml$", recursive = TRUE))
  )
  allYamls <- grep("/data/", rawYamls, value = TRUE)

  lg$info("Scanning data/ folders for YAML files", n_found = length(allYamls))

  # --- Read current table_datasource ---
  existing <- tryCatch(
    DBI::dbReadTable(con, "table_datasource"),
    error = function(e) {
      lg$fatal("'table_datasource' does not exist or cannot be accessed",
               error_message = conditionMessage(e),
               table_name    = "table_datasource",
               caller        = "databasePrepareDatasources")
      stop(e)
    }
  )

  n_inserted <- 0L
  n_updated  <- 0L

  # --- Step 1: Upsert each scanned YAML ---
  for (path in allYamls) {
    yaml_data <- tryCatch(
      yaml::read_yaml(path, eval.expr=TRUE),
      error = function(e) {
        lg$warn("Could not read YAML file; skipping",
                path = path, error_message = conditionMessage(e))
        NULL
      }
    )
    if (is.null(yaml_data)) next

    contact_name  <- .yamlField(yaml_data, "contact_name")
    contact_email <- .yamlField(yaml_data, "contact_email")
    data_path     <- .yamlField(yaml_data, "path")
    file_type     <- .yamlField(yaml_data, "filetype")
    sheet         <- .yamlField(yaml_data, "sheet")

    if (length(data_path) > 1L) {
      lg$warn("YAML path field has more than one value; data_path and file_hash set to NA",
              datasource_id = path, n_values = length(data_path))
      data_path <- NA_character_
    }

    file_hash     <- .hash(data_path, type = "content")

    if (!path %in% existing$datasource_id) {
      DBI::dbExecute(con,
                     paste("INSERT INTO table_datasource",
                           "(datasource_id, contact_name, contact_email, data_path, file_type,",
                           " sheet, file_hash, present_in_project, created_at, updated_at)",
                           "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"),
                     list(path, contact_name, contact_email, data_path, file_type,
                          sheet, file_hash, 1L, today, today))
      n_inserted <- n_inserted + 1L
      lg$info("Inserted new datasource", datasource_id = path)
    } else {
      existing_hash <- existing$file_hash[existing$datasource_id == path]
      if (!isTRUE(file_hash == existing_hash)) {
        DBI::dbExecute(con,
                       paste("UPDATE table_datasource",
                             "SET contact_name = ?, contact_email = ?, data_path = ?, file_type = ?,",
                             "    sheet = ?, file_hash = ?, present_in_project = 1, updated_at = ?",
                             "WHERE datasource_id = ?"),
                       list(contact_name, contact_email, data_path, file_type,
                            sheet, file_hash, today, path))
        n_updated <- n_updated + 1L
        lg$info("Updated datasource (hash changed)",
                datasource_id = path,
                hash_old = existing_hash,
                hash_new = file_hash)
      }
    }
  }

  # --- Step 2: Mark gone YAMLs (present_in_project = 0) ---
  n_absent <- 0L
  if (nrow(existing) > 0L) {
    gone_ids <- existing$datasource_id[!existing$datasource_id %in% allYamls]
    if (length(gone_ids) > 0L) {
      for (gid in gone_ids) {
        DBI::dbExecute(con,
                       "UPDATE table_datasource SET present_in_project = 0 WHERE datasource_id = ?",
                       list(gid))
      }
      n_absent <- length(gone_ids)
      lg$info("Marked absent datasources", n_absent = n_absent)
    }
  }

  lg$info("databasePrepareDatasources complete",
          n_found    = length(allYamls),
          n_inserted = n_inserted,
          n_updated  = n_updated,
          n_absent   = n_absent)

  invisible(NULL)
}
