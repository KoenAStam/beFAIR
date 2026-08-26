#' Export all database tables to R
#'
#' Fetches all tables from the beFAIR SQL database and optionally saves the
#' result as an .rds file. Unlike `getDatabase()`, this function always
#' queries the database directly — it never reads from a local cache.
#'
#' @param path Character or NULL. Directory where the .rds file should be saved.
#'   If `NULL`, no file is written and the list is returned directly.
#' @param overwrite Logical. If `TRUE`, an existing .rds file at `path` is
#'   overwritten. If `FALSE` (default) and the file exists, saving is skipped with
#'   a warning.
#' @param stripped Logical. If `TRUE`, only non-sensitive tables are returned
#'   (study-, experiment-, and analysis-level tables, panel tables, event, and
#'   publications). Default: `FALSE`.
#' @param replace_missing Logical. If `TRUE`, values `-999`, `"N/A"`,
#'   and `"N/M"` are replaced with `NA`. Default: `TRUE`.
#' @param study_ids Character vector or NULL. If provided, only rows linked to
#'   these study IDs are retained via [filterTableList()].
#'
#' @return A named list of data frames containing the database tables. If `path`
#'   is provided, the list is also saved as an .rds file in that directory. The
#'   filename depends on the parameters used:
#'   - `table_list.rds` — default
#'   - `table_list_stripped.rds` — when `stripped = TRUE`
#'   - `table_list_filtered.rds` — when `study_ids` is provided
#' @seealso [getDatabase()] for a cache-first wrapper around this function.
#' @examples
#' \dontrun{
#'   # Fetch from DB and return without saving
#'   data <- databaseExport()
#'
#'   # Fetch from DB and save to disk
#'   data <- databaseExport(path = "data/")
#'
#'   # Force overwrite an existing cache file
#'   data <- databaseExport(path = "data/", overwrite = TRUE)
#'
#'   # Fetch stripped dataset for selected studies
#'   data <- databaseExport(path = "data/", stripped = TRUE, study_ids = c("CHHIL", "ITCHI"))
#' }
#' @export
databaseExport <- function(
  path = NULL,
  overwrite = FALSE,
  stripped = FALSE,
  replace_missing = TRUE,
  study_ids = NULL,
  remove_id_mapping = TRUE
  ) {

  con <- FAIRgroundConnection(NULL)
  message("Connection to SQL successful, exporting tables...")

  tableNames <- DBI::dbGetQuery(
    con,
    "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES"
  )

  if (remove_id_mapping) {
    tableNames <- tableNames[tableNames$TABLE_NAME != "id_mapping", , drop = FALSE]
  }

  # Read tables into a named list
  tableList <- list()
  tableList$`_meta` <- data.frame(
    export_time = as.character(Sys.time()),
    fairpoint_version = as.character(utils::packageVersion("beFAIR")),
    r_version = R.version.string,
    stripped = stripped,
    replace_missing = replace_missing,
    study_ids = if (is.null(study_ids)) NA else paste(study_ids, collapse = ","),
    stringsAsFactors = FALSE
  )

  for (table in tableNames$TABLE_NAME) {
    tableList[[table]] <- DBI::dbReadTable(con, table)
  }

  # Remove source_id and script_id column if present
  tableList <- lapply(tableList, function(df) {
    if ("script_id" %in% names(df)) df$script_id <- NULL
    if ("source_id" %in% names(df)) df$source_id <- NULL
    df
  })

  # Warn if core tables are missing
  required_tables <- c("study", "experiment", "analysis")
  for (tbl in required_tables) {
    if (!tbl %in% names(tableList)) {
      warning(sprintf("Table '%s' not found in the database", tbl))
    }
  }

  if (replace_missing) {
    missingValues <- c(-999, "N/A", "N/M")
    tableList <- lapply(tableList, function(df) {
      dplyr::mutate(df, dplyr::across(dplyr::everything(), ~ ifelse(. %in% missingValues, NA, .)))
    })
  }

  # Optionally strip sensitive tables
  if (stripped) {
    keep_tables <- names(tableList)[
      grepl("^(study|experiment|analysis)", names(tableList)) |
        grepl("panel", names(tableList), ignore.case = TRUE)
    ]
    keep_tables <- c("_meta", keep_tables, "participant", "publications")
    tableList <- tableList[keep_tables]
    if ("participant" %in% names(tableList)) {
      tableList$participant <- tableList$participant %>%
        dplyr::select(participant_id, study_id, studyarm_id)
    }
  }

  if (!is.null(study_ids)) {
    tableList <- filterTableList(tableList, study_ids)
  }

  # add meta on total tables
  tableList <- Filter(Negate(is.null), tableList) # Remove NULLs, keep empty data frames
  tableList$`_meta`$n_tables <- length(tableList)

  DBI::dbDisconnect(con)

  if (!is.null(path)) {
    if (grepl("\\.rds$", path, ignore.case = TRUE)) {
      stop("Argument 'path' must be a directory, not an .rds file.")
    }

    if (!dir.exists(path)) {
      dir.create(path, recursive = TRUE)
    }

    rds_file <- if (stripped) {
      file.path(path, "table_list_stripped.rds")
    } else if (!is.null(study_ids)) {
      file.path(path, "table_list_filtered.rds")
    } else {
      file.path(path, "table_list.rds")
    }

    if (file.exists(rds_file) && !overwrite) {
      warning(sprintf("Cache file already exists and overwrite = FALSE. Skipping save: %s", rds_file))
    } else {
      saveRDS(tableList, file = rds_file)
      message(sprintf("Data cached at: %s", rds_file))
    }
  }

  message(sprintf("Data successfully loaded (%d tables).", length(tableList)))

  return(tableList)
}
