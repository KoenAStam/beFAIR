#' Check whether at least one row for a script_id exists in a data table
#'
#' @param cb_name Character. Table name to query, or `NA` when not applicable.
#' @param script_id Character. The `script_id` value to look up.
#' @param con A DBI connection. If `NULL`, the default connection set by [FAIRgroundConnect()] is used.
#'
#' @return `1L` if at least one matching row exists, `0L` otherwise.
#'
#' @export
entriesInDatabase <- function(cb_name, script_id, con = NULL) {
  con <- FAIRgroundConnection(con)
  if (is.na(cb_name) || !DBI::dbExistsTable(con, cb_name)) return(0L)
  count <- tryCatch(
    DBI::dbGetQuery(
      con,
      sprintf("SELECT COUNT(*) FROM %s WHERE script_id = ?",
              DBI::dbQuoteIdentifier(con, cb_name)),
      list(script_id)
    )[[1]],
    error = function(e) 0L
  )
  as.integer(count > 0L)
}
