#' Create an empty databook from a codebook
#'
#' Reads the named codebook YAML, creates an empty data frame with the correct
#' R column types, and returns both bundled into a `databook` object. The
#' `databook` is the standard container that ETL scripts populate and that
#' [databasePrepareData()] consumes.
#'
#' @param codebook_name A character string specifying the codebook name (without
#'   `.yaml` extension), e.g. `"participant"` or `"cytofpanel"`.
#' @param nrow An integer specifying the number of rows to initialise in the
#'   data frame. Defaults to `0`.
#'
#' @return A named list with the following elements:
#'
#' - `codebook`: The variables map read from the codebook YAML.
#' - `codebook_name`: The codebook name as supplied in `codebook_name`.
#' - `codebook_version`: The codebook version string (e.g. `"2.1"`).
#' - `data`: A data frame with columns matching the codebook variables
#'   and R types derived from the codebook `type` field (`character`,
#'   `numeric`, `integer`, or `Date`).
#' - `validation`: A list with `status = 0` and `summary = NULL`,
#'   to be populated by [validateDatabook()].
#'
#' @seealso [codebookRead()], [validateDatabook()],
#'   [databasePrepareData()], [codebookToSummary()], [addStudy()],
#'   [addExperiment()], [addAnalysis()]
#'
#' @examples
#' \dontrun{
#' databook <- codebookToEntries("participant", nrow = 50)
#'
#' codebookToSummary("cytofpanel")
#' databook <- codebookToEntries("cytofpanel")
#' }
#' @export
codebookToEntries <- function(codebook_name, nrow=0) {
  fullCodebook <- codebookRead(codebook_name=codebook_name)
  codebook <- fullCodebook$variables
  ver <- fullCodebook$version

  # If the codebook was not found, throw an error
  if (is.null(codebook)) {
    stop("Codebook '", codebookName, "' not found. Run codebookToOverview() to get an overview of available codebooks.")
  }

  data <- data.frame(matrix(ncol=length(codebook), nrow=nrow))
  names(data) <- names(codebook)

  # Converts each column in the dataframe from the Opal type specified in the
  # codebook to the corresponding R type
  for (variable in names(codebook)) {
    if (!is.null(type <- codebook[[variable]]$type)) {
      if (type == "character") {
        data[[variable]] <- as.character(data[[variable]])
      } else if (type == "numeric") {
        data[[variable]] <- as.numeric(data[[variable]])
      } else if (type == "integer") {
        data[[variable]] <- as.integer(data[[variable]])
      } else if (type == "date") {
        data[[variable]] <- as.Date(data[[variable]], format = "%Y-%m-%d")
      } else {
        warning(paste("Unknown type:", type, "for variable:", variable, ". Add the type to codebookToEntries function."))
      }
    }  }

  result <- list(
    codebook = codebook,
    codebook_name = codebook_name,
    codebook_version = ifelse(ver == floor(ver), sprintf("%.1f", ver), as.character(ver)),
    data = data,
    validation = list(status = 0, summary = NULL)
  )

  return(result)
}
