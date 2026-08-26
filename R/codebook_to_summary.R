#' Summarise a codebook or one of its variables
#'
#' Prints a summary of a codebook to the console. If no codebook name is given,
#' all available codebooks are listed. If a variable name is supplied, detailed
#' information for that variable (description, type, categories, labels) is
#' printed instead.
#'
#' @param codebook_name Optional character string specifying the name of the
#'   codebook. If `NULL`, all available codebooks are listed.
#' @param var Optional character string specifying a variable within the
#'   codebook. If provided, detailed information for that variable is printed.
#' @return Invisibly returns `NULL`. Output is written to the console.
#' @seealso [codebookRead()], [codebookToDraft()]
#' @examples
#' \dontrun{
#'   codebookToSummary()
#'   codebookToSummary("event")
#'   codebookToSummary("event", var = "event_id")
#' }
#' @export
codebookToSummary <- function(codebook_name=NULL, var=NULL){
  # If no codebook name is provided, list all available codebooks
  if (is.null(codebook_name)) {
    codebooks <- list()
    for (type in c("study", "experiment", "analyses")) {
      codebookDir <- system.file("codebooks", type, package = "beFAIR")
      availableCodebooks <- list.files(codebookDir, pattern = "\\.ya?ml$", full.names = FALSE)
      codebooks[[type]] <- sub("\\.ya?ml$", "", availableCodebooks)
    }

    # Print built-in codebooks
    cat("Available codebooks:\n\n")
    for (type in names(codebooks)) {
      cat(paste0("- ", type, ":\n"))
      cat(paste("  *", codebooks[[type]], "[beFAIR]", collapse = "\n"), "\n\n")
    }

    # Print custom codebooks (if any)
    custom_root <- file.path(getwd(), "codebooks")
    if (dir.exists(custom_root)) {
      origin <- basename(getwd())
      custom_codebooks <- list()
      for (type in c("study", "experiment", "analyses")) {
        custom_dir <- file.path(custom_root, type)
        if (dir.exists(custom_dir)) {
          available <- list.files(custom_dir, pattern = "\\.ya?ml$", full.names = FALSE)
          names_only <- sub("\\.ya?ml$", "", available)
          if (length(names_only) > 0) {
            custom_codebooks[[type]] <- names_only
          }
        }
      }

      if (length(custom_codebooks) > 0) {
        cat(paste0("Custom codebooks [", origin, "]:\n\n"))
        for (type in names(custom_codebooks)) {
          cat(paste0("- ", type, ":\n"))
          cat(paste("  *", custom_codebooks[[type]], paste0("[", origin, "]"), collapse = "\n"), "\n\n")
        }
      }
    }

    cat("To get a summary of a specific codebook, call codebookToSummary() with the codebook's name, e.g., codebookToSummary('event').\n")
    return(invisible(NULL))
  }

  codebook <- codebookRead(codebook_name=codebook_name)$variables

    # If the codebook was not found, throw an error
  if (is.null(codebook)) {
    stop("Codebook '", codebook_name, "' not found. Run codebookToOverview() to get an overview of available codebooks.")
  }

  # If a specific variable (`var`) is provided, print detailed information about that variable
  if (!is.null(var)) {
    if (var %in% names(codebook)) {
      variable <- codebook[[var]]
      cat(paste0(
        "\n", var, "\n",
        "description: ", variable$description, "\n",
        "type: ", variable$type, "\n",
        "categories: ", variable$categories, "\n",
        "labels: ", variable$labels, "\n"
      ), "\n")
    } else {
      stop(paste("The variable", var, "is not found in the", codebook_name, "codebook. Please provide a valid variable name."))
    }
  } else {
  # Else print a summary of all variables
  cat("Summary of", codebook_name, "codebook:\n\n")
  for (var_name in names(codebook)) {
    variable <- codebook[[var_name]]
    cat(paste0(
      "- ",
      var_name,
      "; ",
      variable$type,
      "; ",
      ifelse(is.null(variable$labels), "", paste0(variable$labels, "; ")),
      ifelse(is.null(variable$units), "", paste0(variable$units, ";"))
    ), "\n")
  }
  cat("To view details about a specific variable, provide the variable name as the 'var' parameter in this function.\n")
  }
}

