#' Search for studies, experiments, or analyses by ID or name
#'
#' Performs a case-insensitive partial-match search against the `study`,
#' `experiment`, and `analysis` tables in the FAIRground database. The query
#' is matched against both the ID column and the `name` column of each table.
#'
#' @param query A character string to search for. Partial matches are supported
#'   (e.g. `"hypo"` will match `"HypoVax"` or `"HYPOV"`).
#' @param con A DBI connection. If `NULL`, the default connection set by
#'   [FAIRgroundConnect()] is used.
#'
#' @return A `data.frame` with columns:
#'   - `pillar`: one of `"study"`, `"experiment"`, or `"analysis"`
#'   - `id`: the ID value (`study_id`, `experiment_id`, or `analysis_id`)
#'   - `name`: the human-readable name
#'
#' Returns an empty data frame with the same columns when no matches are found.
#'
#' @seealso [FAIRgroundConnect()], [FAIRgroundOverview()]
#'
#' @examples
#' \dontrun{
#' FAIRgroundConnect("LUCID_FAIRPOINT")
#' searchId("NIH")
#' searchId("A")
#' searchId("ELISA")
#' }
#' @export
searchId <- function(query, con = NULL) {
  con <- FAIRgroundConnection(con)

  if (!is.character(query) || length(query) != 1 || nchar(trimws(query)) == 0) {
    stop("`query` must be a non-empty character string.")
  }

  pattern <- paste0("%", query, "%")

  tables <- list(
    list(pillar = "study",      table = "study",      id_col = "study_id"),
    list(pillar = "experiment", table = "experiment", id_col = "experiment_id"),
    list(pillar = "analysis",   table = "analysis",   id_col = "analysis_id")
  )

  results <- lapply(tables, function(t) {
    if (!DBI::dbExistsTable(con, t$table)) return(NULL)

    sql <- sprintf(
      "SELECT %s AS id, name FROM %s WHERE LOWER(%s) LIKE LOWER(?) OR LOWER(name) LIKE LOWER(?)",
      t$id_col, t$table, t$id_col
    )

    rows <- tryCatch(
      DBI::dbGetQuery(con, sql, params = list(pattern, pattern)),
      error = function(e) NULL
    )

    if (is.null(rows) || nrow(rows) == 0) return(NULL)

    rows$pillar <- t$pillar
    rows[, c("pillar", "id", "name")]
  })

  out <- do.call(rbind, Filter(Negate(is.null), results))

  if (is.null(out)) {
    out <- data.frame(pillar = character(0), id = character(0), name = character(0),
                      stringsAsFactors = FALSE)
  }

  rownames(out) <- NULL
  out
}
