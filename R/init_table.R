#' Create or recreate a single database table from its codebook
#'
#' @param cb_name Character. Codebook (and table) name.
#' @param overwrite Logical. Drop and recreate when `TRUE`; skip with a
#'   warning when `FALSE`.
#' @param data Optional data frame inserted after creation (used for built-in
#'   reference tables such as `HGNC` and `LUNC`).
#' @param con A DBI connection. If `NULL`, the default connection set by [FAIRgroundConnect()] is used.
#'
#' @return Invisibly `NULL`.
#'
#' @export
initTable <- function(cb_name, overwrite, data = NULL, con = NULL) {
  lg <- lgr::get_logger("beFAIR")
  con <- FAIRgroundConnection(con)
  cb <- codebookRead(cb_name)
  exists <- DBI::dbExistsTable(con, cb_name)

  if (exists && !overwrite) {
    lg$warn("Table already exists, skipping",
            table_name = cb_name,
            hint = if (is.null(data)) "use overwrite_core = TRUE to recreate"
                   else "use overwrite_reference = TRUE to recreate")
    return(invisible(NULL))
  }

  if (exists && overwrite) {
    .sqlDropTable(con, cb_name)
  }

  lg$info("Generating table",
          table_name = cb_name,
          codebook_name = cb_name,
          codebook_version = cb$version)
  .sqlGenerateTable(con, cb_name)

  if (!is.null(data)) {
    .sqlPushTable(con, data = data, table_name = cb_name, script_id = "built-in")
  }

  invisible(NULL)
}
