#' Prepare ETL scripts prior to updating the database
#'
#' Scans the FAIRground directories for ETL scripts (files located in a
#' `scripts/` subfolder under `studies/`, `experiments/`, and `analyses/`),
#' computes an MD5 hash for each script, and maintains `table_script` as the
#' authoritative status table.
#'
#' The function identifies and tracks:
#' - **New scripts** not yet present in `table_script` — inserted with `queued_for_update = 1`.
#' - **Changed scripts** whose content hash differs from the database — `queued_for_update` set to 1.
#' - **Outdated scripts** whose `codebook_version` lags behind `table_codebook` — `queued_for_update` set to 1.
#' - **Suspended scripts** whose filename starts with `_` — recorded in `table_script` with `suspended = 1` and skipped.
#'
#' @param con A DBI connection. If `NULL`, the default connection set by [FAIRgroundConnect()] is used.
#'
#' @return A data frame with one row per ETL script queued for (re)running
#'   (`queued_for_update == 1 & suspended == 0`), with all `table_script` columns.
#'   Rows are ordered by category (`studies`, `experiments`, `analyses`) and a
#'   predefined study dependency order.
#'
#' @details
#' **Database effects:** This function may INSERT or UPDATE rows in `table_script`.
#' New internal scripts are only inserted when the inferred `codebook_name` exists
#' in `table_codebook`; otherwise the script is skipped and an error is logged.
#'
#' **Suspended scripts:** ETL scripts with a leading underscore in the filename are
#' treated as suspended. Their `live_id` (path with `_` removed) is recorded in
#' `table_script` with `suspended = 1` and `queued_for_update = 0`.
#'
#' @seealso [FAIRgroundConnect()], [databaseUpdate()], [databasePrepareCodebooks()]
#'
#' @examples
#' \dontrun{
#' FAIRgroundConnect("MY_DSN")
#' scriptsToUpdate <- databasePrepareScripts()
#' }
#'
#' @export
databasePrepareScripts <- function(con=NULL){
  lg <- lgr::get_logger("beFAIR")
  con <- FAIRgroundConnection(con)

  # Read tables from DB
  tableFromDB <- tryCatch({
    DBI::dbReadTable(con, "table_script")
  }, error = function(e) {
    lg$fatal("'table_script' does not exist or cannot be accessed",
             error_message = conditionMessage(e),
             table_name = "table_script",
             caller = "dbReadTable")
    stop(e)
  })

  tableCodebook <- DBI::dbReadTable(con, "table_codebook")

  # Scan directories for ETL scripts
  rawScripts <- c(paste0("studies/",     list.files("studies",     recursive = TRUE)),
                  paste0("experiments/", list.files("experiments", recursive = TRUE)),
                  paste0("analyses/",    list.files("analyses",    recursive = TRUE)))

  allScripts <- grep("/scripts/", rawScripts, value = TRUE)

  # Partition into suspended (basename starts with _) and active
  isSuspended   <- grepl("/scripts/_", allScripts)
  suspendedPaths <- allScripts[isSuspended]
  activeScripts  <- allScripts[!isSuspended]

  # --- Step 1: Suspended scripts ---
  for (path in suspendedPaths) {
    live_id <- sub("/scripts/_", "/scripts/", path)

    lg$info("Identified suspended ETL script",
            script_id = live_id,
            suspended_file = path)

    if (live_id %in% tableFromDB$script_id) {
      DBI::dbExecute(con,
        "UPDATE table_script SET suspended = 1 WHERE script_id = ?",
        list(live_id))
      lg$info("Marked existing table_script entry as suspended", script_id = live_id)
    } else {
      script_hash <- .hash(
        paste(readLines(path, warn = FALSE), collapse = "\n"),
        type = "string",
        algo = "md5"
      )


      cb_name <- gsub(".*/|\\.R$", "", live_id)

      DBI::dbExecute(con,
        paste("INSERT INTO table_script",
              "(script_id, script_hash, codebook_name, codebook_version, created_at,",
              " updated_at, run_time, flag_TODO, flag_WARN,",
              " suspended, entries_in_database, queued_for_update)",
              "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"),
        list(live_id, script_hash, cb_name, "0.0",
             format(Sys.Date(), "%Y-%m-%d"), NA_character_, NA_real_,
             NA_integer_, NA_integer_,
             1L, 0L, 0L))
      lg$info("Inserted suspended script into table_script", script_id = live_id)
    }
  }

  lg$info("Matching current 'table_script' with beFAIR directory",
          table_name = "table_script",
          active_scripts = length(activeScripts),
          entries_database = nrow(tableFromDB))

  # --- Step 2: Active scripts ---
  # Re-read after step 1 may have modified table_script
  tableFromDB <- DBI::dbReadTable(con, "table_script")

  for (scriptPath in activeScripts) {
    cb_name <- gsub(".*/|\\.R$", "", scriptPath)

    script_hash <- .hash(
      paste(readLines(scriptPath, warn = FALSE), collapse = "\n"),
      type = "string",
      algo = "md5"
    )


    entries_in_db <- entriesInDatabase(cb_name, scriptPath, con = con)

    if (!scriptPath %in% tableFromDB$script_id) {
      # NEW SCRIPT
      lg$info("New script detected", script_id = scriptPath)

      if (!is.na(cb_name) && !cb_name %in% tableCodebook$codebook_name) {
        lg$error("ETL script does not have matching entry in 'table_codebook'",
                 script_id = scriptPath,
                 codebook_name = cb_name)
        next
      }

      DBI::dbExecute(con,
        paste("INSERT INTO table_script",
              "(script_id, script_hash, codebook_name, codebook_version, created_at,",
              " updated_at, run_time, flag_TODO, flag_WARN,",
              " suspended, entries_in_database, queued_for_update)",
              "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"),
        list(scriptPath, script_hash, cb_name, "0.0",
             format(Sys.Date(), "%Y-%m-%d"), NA_character_, NA_real_,
             NA_integer_, NA_integer_,
             0L, entries_in_db, 1L))

      lg$info("Inserted new script into table_script with queued_for_update = 1",
              script_id = scriptPath)

      databasePrepareDependencies(scriptPath, con)

    } else {
      # EXISTING SCRIPT
      entryNr <- match(scriptPath, tableFromDB$script_id)
      queued  <- 0L

      if (isTRUE(as.integer(tableFromDB[entryNr, "suspended"]) == 1L)) {
        lg$info("Script was previously suspended, now active again", script_id = scriptPath)
      }

      # Check 1: hash changed?
      if (script_hash != tableFromDB[entryNr, "script_hash"]) {
        queued <- 1L
        lg$info("Script content changed (hash mismatch)",
                script_id = scriptPath,
                hash_database  = tableFromDB[entryNr, "script_hash"],
                hash_beFAIR = script_hash)
      }

      # Check 2: codebook version behind?
      if (!is.na(cb_name) && cb_name %in% tableCodebook$codebook_name) {
        cur_vers <- tableCodebook[tableCodebook$codebook_name == cb_name, "codebook_version"]
        db_vers  <- tableFromDB[entryNr, "codebook_version"]
        if (!is.na(db_vers) && cur_vers != db_vers) {
          queued <- 1L
          lg$info("Database entry of ETL script behind codebook version",
                  script_id        = scriptPath,
                  codebook_name    = cb_name,
                  version_database = db_vers,
                  version_codebook = cur_vers)
        }
      }

      if (queued == 0L) {
        lg$info("Script up-to-date with database", script_id = scriptPath)
      }

      DBI::dbExecute(con,
        paste("UPDATE table_script",
              "SET suspended = 0, entries_in_database = ?, queued_for_update = ?",
              "WHERE script_id = ?"),
        list(entries_in_db, queued, scriptPath))

      if (queued == 1L) {
        databasePrepareDependencies(scriptPath, con)
      }

    }
  }

  # --- Step 3: Return queued scripts ---
  tableFromDB <- DBI::dbReadTable(con, "table_script")

  # TODO get a clean-fix for when queued_for_update is somehow NA
  toRun <- tableFromDB[tableFromDB$queued_for_update %in% 1L &
                       tableFromDB$suspended %in% 0L, , drop = FALSE]

  # Add project_location from pillar meta.yaml
  # toRun$project_location <- vapply(toRun$script_id, function(sid) {
  #   .pillarMeta(sid)$project_location
  # }, character(1))

  # Order by category and study dependency hierarchy
  studies_order <- c("id_mapping", "studyarm", "studydesign", "participant", "event")

  toRun <- toRun %>%
    mutate(
      category = factor(
        sub("/.*", "", script_id),
        levels = c("studies", "experiments", "analyses")
      ),
      codebook_order = factor(codebook_name, levels = studies_order)
    ) %>%
    arrange(category, codebook_order)

  return(toRun)
}
