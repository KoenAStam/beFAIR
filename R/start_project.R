#' Create a FAIRground folder
#'
#' Initializes a FAIRground directory containing the standard folder
#' structure required for ETL development and database integration. The
#' following top-level directories are created:
#' - `studies/`
#' - `experiments/`
#' - `analyses/`
#' - `common/`
#' - `logs/`
#' - `codebooks/custom/`
#'
#' These directories are intended to contain ETL scripts (typically located
#' in `scripts/` subfolders) that extract raw data and load them into the
#' connected FAIRground database.
#'
#' In addition, the function:
#'
#' - Creates an RStudio project file (`.Rproj`)
#' - Generates a basic `.gitignore` file
#'
#' Optionally, the project can be populated with a bundled dummy example
#' project to demonstrate the FAIRground.
#'
#' @param dir Character. Path where the FAIRground should be
#'   created. The directory will be created if it does not already exist.
#' @param dummy Logical. If `TRUE`, the project is populated with example
#'   dummy data and scripts included in the package. Useful for vignettes,
#'   demonstrations, or learning the FAIRground. Default is `FALSE`.
#'
#' @return Invisibly returns `NULL`. Called for its side effects on the file system.
#'
#' @details
#' Creates the  FAIRground directory structure on disk and optionally
#' copies example files bundled with the package. To start drafting ETL scripts
#' and populating the FAIRground use [addStudy()], [addExperiment()],
#' and [addAnalysis()]
#'
#' The function does not initialize a database connection. After creating the
#' project structure, use [FAIRgroundConnect()] to connect to a database.
#'
#' @examples
#' \dontrun{
#' startProject(dir = "C:/Users/johndoe/Projects/LUCID_beFAIR")
#'
#' # Setup a dummy project
#' dir <- paste0(tempdir(), "/dummy_beFAIR")
#' startProject(dir = dir, dummy=TRUE)
#'
#' # Inspect the created beFAIR directory
#' cat(normalizePath(dir), "\n")
#' }
#'
#' @seealso [FAIRgroundConnect()], [addStudy()], [addExperiment()],
#' [addAnalysis()]
#'
#' @export
startProject <- function(dir, dummy=FALSE){
  srcDir <- system.file("dummy/project", package = "beFAIR")

  if(missing(dir)){
    stop('argument "dir" is missing, with no default')
  }

  # folder structure
  dir.create(file.path(dir, "/studies"), recursive=TRUE)
  dir.create(file.path(dir, "/experiments"))
  dir.create(file.path(dir, "/analyses"))
  dir.create(file.path(dir, "/common"))
  dir.create(file.path(dir, "/logs/files"), recursive=TRUE)

  # custom codebook directory
  dir.create(file.path(dir, "codebooks"), recursive = TRUE)

  # create R project
  projectName <- basename(normalizePath(dir))
  writeLines(c(
    "Version: 1.0",
    "",
    "RestoreWorkspace: No",
    "SaveWorkspace: No",
    "AlwaysSaveHistory: Default",
    "",
    "EnableCodeIndexing: Yes",
    "UseSpacesForTab: Yes",
    "NumSpacesForTab: 2",
    "Encoding: UTF-8",
    "",
    "RnwWeave: Sweave",
    "LaTeX: pdfLaTeX"
  ), file.path(dir, paste0(projectName, ".Rproj")))

  # Gitignore
  writeLines(c(
    ".Rhistory",
    ".RData",
    ".Ruserdata",
    ".Rproj.user/",
    ".DS_Store"
  ), file.path(dir, ".gitignore"))

  # dummy data
  if(dummy){
    dummyProject <- list.files(srcDir, recursive=TRUE, full.names=TRUE)

    relPaths <- sub(paste0("^", normalizePath(srcDir, winslash = "/"), "/?"),
                    "",
                    normalizePath(dummyProject, winslash = "/"))
    finalPaths <- file.path(dir, relPaths)

    uniqueDirs <- unique(dirname(finalPaths))
    for (d in uniqueDirs) {
      dir.create(d, recursive = TRUE, showWarnings = FALSE)
    }
    invisible(file.copy(from = dummyProject, to = finalPaths))
  }

}
