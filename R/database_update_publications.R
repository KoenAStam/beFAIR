#' Update the publications table in the database
#'
#' Drops and recreates the `publications` table, then sources
#' `common/publications.R` (if it exists), validates the resulting `databook`,
#' and uploads the data to the database. If the file is absent or validation
#' fails, no data is written.
#'
#' Called automatically at the end of [databaseUpdate()].
#'
#' @param con A DBI connection. If `NULL`, the default connection set by [FAIRgroundConnect()] is used.
#'
#' @return Called for its side effects. Invisibly returns `NULL`.
#'
#' @seealso [databaseUpdate()]
#'
#' @examples
#' \dontrun{
#' FAIRgroundConnect("MY_DSN")
#' databaseUpdatePublications()
#' }
#' @export
databaseUpdatePublications <- function(con=NULL) {
  con <- FAIRgroundConnection(con)

  # always recreate table
  sqlTableName <- "publications"
  .sqlDropTable(con, sqlTableName)
  .sqlGenerateTable(con, sqlTableName)

  filePath <- "common/publications.R"

  if (file.exists(filePath)) {
    tryCatch({
      localEnv <- new.env()
      print(filePath)
      source(filePath, local = localEnv)

      databook <- get("databook", envir = localEnv)

      if (databook$validation$status == 1) {
        data <- databook$data

        tryCatch({
          .sqlPushTable(con, data, "publications")
        }, error = function(e) {
          message("Failed to push data to SQL for publications: ", e$message)
        })

      }

    }, error = function(e) {
      message("Error sourcing ", filePath, ": ", e$message)
    })
  }

}
