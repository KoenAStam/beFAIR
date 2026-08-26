#' Collect data table from database, optionally filtered by script_id
#'
#' This function retrieves all records from a specified database table.
#' If a valid database connection is not supplied, a new connection is created.
#' Optionally, the result can be filtered by a given `script_id`.
#'
#' @param table_name Character string specifying the name of the database table.
#' @param script_id Optional. If provided, only rows where `script_id` matches
#'   this value are returned.
#' @param con A DBI connection. If `NULL`, the default connection set by [FAIRgroundConnect()] is used.
#'
#' @return A `data.frame` with all rows from `table_name` (or the subset
#'   matching `script_id`). The `script_id` column is always removed from the
#'   output.
#' @examples
#' df <- collectTable(table_name = "participant")
#' @export
#'
collectTable <- function(table_name, script_id = NULL, con = NULL) {
  con <- FAIRgroundConnection(con)

  # get data from database
  query <- paste0("SELECT * FROM ", DBI::dbQuoteIdentifier(con, table_name))
  data <- DBI::dbGetQuery(con, query)

  # filter on script_id if script_id is given
  if (!is.null(script_id)) {
    scriptID <- script_id
    data <- data %>%
      filter(script_id == scriptID)
  }

  # remove script_id column
  if ("script_id" %in% colnames(data)) {
    data <- data %>% select(-script_id)
  }

  return(data)
}
