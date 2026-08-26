#' Read a codebook by name
#'
#' Searches `inst/codebooks/` for a YAML file whose base name matches
#' `codebook_name` (case-insensitive) and returns its parsed contents.
#' If a `codebooks/` folder exists in the current working directory, it is
#' searched as well. An error is raised if the same name is found in both
#' locations.
#'
#' @param codebook_name Character. Name of the codebook without the `.yaml`
#'   extension (e.g. `"event"`, `"participant"`).
#' @return A named list containing the parsed codebook, or `NULL` with a
#'   warning if no matching codebook is found.
#' @seealso [codebookToSummary()], [codebookToEntries()]
#' @examples
#' \dontrun{
#'   codebookRead("event")
#' }
#' @export
codebookRead <- function(codebook_name){
  # Search package (built-in) codebooks
  pkgPaths <- list.files(system.file("codebooks", package = "beFAIR"),
                         pattern = "\\.ya?ml$", recursive = TRUE, full.names = TRUE)
  pkgPath  <- pkgPaths[grepl(paste0("^", codebook_name, "$"),
                             sub("\\.ya?ml$", "", basename(pkgPaths)),
                             ignore.case = TRUE)]

  # Search custom codebooks in the project's codebooks/ directory
  customPath <- character(0)
  custom_root <- file.path(getwd(), "codebooks")
  if (dir.exists(custom_root)) {
    customPaths <- list.files(custom_root, pattern = "\\.ya?ml$",
                              recursive = TRUE, full.names = TRUE)
    customPath  <- customPaths[grepl(paste0("^", codebook_name, "$"),
                                     sub("\\.ya?ml$", "", basename(customPaths)),
                                     ignore.case = TRUE)]
  }

  # Conflict: same name found in both locations
  if (length(pkgPath) > 0 && length(customPath) > 0) {
    stop(
      "Codebook '", codebook_name, "' exists in both the beFAIR package and ",
      "the project's custom codebooks directory. Rename or remove the conflicting ",
      "custom codebook to resolve the conflict."
    )
  }

  matchedPath <- c(pkgPath, customPath)

  if (length(matchedPath) == 1) {
    codebook <- yaml::read_yaml(matchedPath)
    return(codebook)
  } else {
    warning("Codebook ", codebook_name, " does not exist")
    return(NULL)
  }
}
