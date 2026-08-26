#' Load database tables into R (cache-first)
#'
#' Cache-first wrapper around [databaseExport()]. If an .rds cache
#' file already exists at `path` and `overwrite = FALSE`, the data
#' is loaded from disk. Otherwise, the database is queried via
#' [databaseExport()] and the result is saved to `path`.
#'
#' @param path Character. Directory where the cached data (RDS file) should be
#'   stored or loaded from. Must be a directory, not an .rds file path.
#' @param overwrite Logical. If `TRUE`, forces a fresh read from the database and
#'   overwrites the cache. Default: `FALSE`.
#' @param stripped Logical. If `TRUE`, only non-sensitive tables are returned
#'   (e.g., excluding participants). Default: `FALSE`.
#' @param replace_missing Logical. If `TRUE`, missing values will be replaced
#'   with `NA`. Default: `TRUE`.
#' @param study_ids Character vector or NULL. Study IDs to filter on.
#'
#' @return A named list of data frames containing the database tables.
#' @seealso [databaseExport()] to always fetch from the database.
#' @examples
#' \dontrun{
#'   # Load cached data or fetch from DB
#'   data <- getDatabase(path = "data/")
#'
#'   # Force overwrite cache
#'   data <- getDatabase(path = "data/", overwrite = TRUE)
#'
#'   # Load stripped dataset without sensitive info
#'   data <- getDatabase(path = "data/", stripped = TRUE)
#'
#'   # Load data filtered to specific studies
#'   data <- getDatabase(path = "data/", study_ids = c("CHHIL", "ITCHI"))
#' }
#' @export
getDatabase <- function(
  path,
  overwrite = FALSE,
  stripped = FALSE,
  replace_missing = TRUE,
  study_ids = NULL,
  remove_id_mapping = TRUE
  ) {

  if (grepl("\\.rds$", path, ignore.case = TRUE)) {
    stop("Argument 'path' must be a directory, not an .rds file.
         Please provide a folder where the cache file can be stored.")
  }

  rds_file <- if (stripped) {
    file.path(path, "table_list_stripped.rds")
  } else if (!is.null(study_ids)) {
    file.path(path, "table_list_filtered.rds")
  } else {
    file.path(path, "table_list.rds")
  }

  if (file.exists(rds_file) && !overwrite) {
    message("Loading tables from cache...")
    tableList <- readRDS(rds_file)
    message(sprintf(
      "Data successfully loaded (%d tables). Cached at: %s",
      length(tableList),
      rds_file
    ))
    return(tableList)
  }

  databaseExport(
    path = path,
    overwrite = overwrite,
    stripped = stripped,
    replace_missing = replace_missing,
    study_ids = study_ids,
    remove_id_mapping = remove_id_mapping
  )
}
