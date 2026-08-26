#' Collect all database tables linked to a study, experiment, or analysis ID
#'
#' Queries the database for all tables that contain a column matching the type
#' of the supplied ID (`study_id`, `experiment_id`, or `analysis_id`). The ID
#' type is inferred automatically from the ID format. When `recursive = TRUE`,
#' the function chains upward through the data hierarchy: an `analysis_id`
#' triggers a follow-up lookup of its linked experiments, which in turn trigger
#' a lookup of their linked studies.
#'
#' @details
#' The ID type is determined by pattern matching:
#' - IDs matching `^A[0-9a-f]{6}$` are treated as `analysis_id`
#' - IDs matching `^E[0-9a-f]{6}$` are treated as `experiment_id`
#' - All other IDs are treated as `study_id`
#'
#' Table discovery uses `INFORMATION_SCHEMA.COLUMNS`, so this function
#' requires a SQL Server (ODBC) connection and is not compatible with SQLite.
#'
#' @param id A character string specifying the ID to search for. The type
#'   (`study_id`, `experiment_id`, or `analysis_id`) is inferred from the
#'   format of the value.
#' @param recursive Logical. If `TRUE` (default), the function follows
#'   relational links upward: analysis → linked experiments → linked studies.
#'   If `FALSE`, only tables directly containing the supplied ID column are
#'   queried.
#' @param namesOnly Logical. If `TRUE`, returns only a character vector of
#'   table names that contain at least one row matching the ID, without
#'   fetching the actual data. Default is `FALSE`.
#' @param con A DBI connection. If `NULL`, the default connection set by
#'   [FAIRgroundConnect()] is used.
#'
#' @return When `namesOnly = FALSE` (default): a named list of data frames,
#'   one per matching table, with each data frame filtered to rows where the
#'   ID column equals `id`. Empty tables are excluded. When `namesOnly = TRUE`:
#'   a character vector of table names that contain matching rows.
#'
#' @seealso [getDatabase()], [FAIRgroundConnect()], [searchId()]
#'
#' @examples
#' \dontrun{
#' FAIRgroundConnect("LUCID_FAIRPOINT")
#'
#' # Retrieve all data linked to a study
#' collectTablesById(id = "HYPOV")
#'
#' # Only return table names (no data fetched)
#' collectTablesById(id = "Ec0a1f3", namesOnly = TRUE)
#'
#' # Retrieve analysis data without chaining to experiments/studies
#' collectTablesById(id = "A1b6b7f", recursive = FALSE)
#' }
#' @export
collectTablesById <- function(id, recursive = TRUE, namesOnly = FALSE, con = NULL) {

  # check connection
  con <- FAIRgroundConnection(con)

  column <- dplyr::case_when(
    grepl("^A[0-9a-f]{6}$", id) ~ "analysis_id",
    grepl("^E[0-9a-f]{6}$", id) ~ "experiment_id",
    .default = "study_id"
  )

  # Get matching tables/columns from metadata
  queryTables <- paste0(
    "SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME
     FROM INFORMATION_SCHEMA.COLUMNS
     WHERE COLUMN_NAME = '", column, "'"
  )
  tables <- DBI::dbGetQuery(con, queryTables)

  if (namesOnly) {

    # Only check existence with SELECT TOP 1, no data retrieval
    tableNames <- Filter(Negate(is.null),
                         setNames(
                           lapply(seq_len(nrow(tables)), function(i) {
                             table_name <- tables$TABLE_NAME[i]
                             tryCatch({
                               exists <- DBI::dbGetQuery(
                                 con,
                                 paste0("SELECT TOP 1 1 FROM ", table_name, " WHERE ", column, " = '", id, "'")
                               )
                               if (nrow(exists) > 0) table_name else NULL
                             }, error = function(e) NULL)
                           }),
                           tables$TABLE_NAME
                         )
    )

    # Recursive chaining
    if (recursive) {
      if (column == "analysis_id") {
        ids <- DBI::dbGetQuery(con, paste0("SELECT experiment_ids FROM analysis WHERE analysis_id = '", id, "'"))
        experiment_ids <- unlist(strsplit(as.character(ids), ", "))
        for (exp_id in experiment_ids) {
          tableNames <- c(tableNames, collectTablesById(exp_id, recursive = TRUE, namesOnly = TRUE, con = con))
        }
      }

      if (column == "experiment_id") {
        ids <- DBI::dbGetQuery(con, paste0("SELECT study_ids FROM experiment WHERE experiment_id = '", id, "'"))
        study_ids <- unlist(strsplit(as.character(ids), ", "))
        for (study_id in study_ids) {
          tableNames <- c(tableNames, collectTablesById(study_id, recursive = TRUE, namesOnly = TRUE, con = con))
        }
      }
    }

    return(unique(unlist(tableNames)))
  }

  # Query each matching table (full data)
  results <- setNames(
    lapply(seq_len(nrow(tables)), function(i) {
      table_name <- tables$TABLE_NAME[i]
      tryCatch({
        DBI::dbGetQuery(
          con,
          paste0("SELECT * FROM ", table_name, " WHERE ", column, " = '", id, "'")
        )
      }, error = function(e) NULL)
    }),
    tables$TABLE_NAME
  )

  # Remove NULLs and empty data frames
  results <- Filter(Negate(is.null), results)
  results <- Filter(function(x) nrow(x) > 0, results)

  # Recursive chaining
  if (recursive) {

    # analysis_id -> get experiment_id from 'analysis' table and recurse
    if (column == "analysis_id" && "analysis" %in% names(results)) {
      experiment_ids <- unlist(strsplit(results[["analysis"]]$experiment_ids, ", "))

      for (exp_id in experiment_ids) {
        deeper <- collectTablesById(exp_id, recursive = TRUE, con = con)
        results <- c(results, deeper)
      }
    }

    # experiment_id -> get study_id from 'experiment' table and recurse
    if (column == "experiment_id" && "experiment" %in% names(results)) {
      study_ids <- unlist(strsplit(results[["experiment"]]$study_ids, ", "))

      for (study_id in study_ids) {
        deeper <- collectTablesById(study_id, recursive = TRUE, con = con)
        results <- c(results, deeper)
      }
    }
  }

  results <- lapply(split(results, names(results)), dplyr::bind_rows)
}

