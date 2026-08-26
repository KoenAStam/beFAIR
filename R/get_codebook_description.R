#' Get the description of a codebook
#'
#' @param codebook_name Character. Name of the codebook (e.g. `"event"`).
#' @return A character string with the codebook description, or `""` (empty
#'   string) with a warning if the codebook is not found.
#' @seealso [codebookRead()], [codebookToSummary()]
#' @examples
#' \dontrun{
#'   getCodebookDescription("event")
#' }
#' @export
getCodebookDescription <- function(codebook_name) {
  codebook_dir <- system.file("codebooks", package = "beFAIR")

  codebook_path <- list.files(
    path = codebook_dir,
    pattern = paste0("^", codebook_name, "\\.ya?ml$"),
    recursive = TRUE,
    full.names = TRUE
  )

  if (length(codebook_path) == 0) {
    warning(sprintf("Codebook '%s' not found in beFAIR package.", codebook_name))
    return("")
  }

  codebook <- yaml::read_yaml(codebook_path[1])

  if (is.null(codebook$description) || !nzchar(trimws(codebook$description))) {
    warning(sprintf("Codebook '%s' has no description field.", codebook_name))
    return("")
  }

  codebook$description
}
