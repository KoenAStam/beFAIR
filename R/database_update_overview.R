#' Update the overview tables in the database
#'
#' Rebuilds the `study`, `experiment`, and `analysis` overview tables in the
#' database from the current FAIRground directory. Each table is dropped
#' and recreated before the data is pushed, so the database always reflects the
#' current state of the `meta.yaml` files on disk.
#'
#' Called automatically at the end of [databaseUpdate()].
#'
#' @param con A DBI connection. If `NULL`, the default connection set by [FAIRgroundConnect()] is used.
#'
#' @return Called for its side effects. Invisibly returns `NULL`.
#'
#' @seealso [databaseUpdate()], [FAIRgroundOverview()]
#'
#' @examples
#' \dontrun{
#' FAIRgroundConnect("MY_DSN")
#' databaseUpdateOverview()
#' }
#' @export
databaseUpdateOverview <- function(con=NULL) {
  con <- FAIRgroundConnection(con)
  fpOverview <- FAIRgroundOverview(print = FALSE)

  # mapping from plural to singular (plural in LUCID_fairpoint folder structure)
  tableMapping <- list(
    studies     = "study",
    experiments = "experiment",
    analyses    = "analysis"
  )

  for (tableName in names(fpOverview)) {
    df <- fpOverview[[tableName]]

    sqlTableName <- if (tableName %in% names(tableMapping)) {
      tableMapping[[tableName]]
    } else {
      tableName
    }

    print(sqlTableName)

    # always recreate table
    .sqlDropTable(con, sqlTableName)
    .sqlGenerateTable(con, sqlTableName)

    tryCatch({
      .sqlPushTable(con, df, sqlTableName)
    }, error = function(e) {
      message("Error pushing table ", sqlTableName, ": ", e$message)
    })
  }
}
