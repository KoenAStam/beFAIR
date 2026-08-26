#' Generate an overview of beFAIR meta.yaml files
#'
#' This function reads and combines all `meta.yaml` files located under the
#' `studies`, `experiments`, and `analyses` directories. It returns a named
#' list containing data frames for each pillar, with each data frame containing
#' the standardized columns according to the respective codebooks.
#'
#' The function prints a preview of the main overviews. By default,
#' only the first 5 rows and first 5 columns are shown. Set `print_full = TRUE`
#' to display all rows (still limited to 5 columns for readability).
#'
#' @param print Logical. If TRUE (default), prints a summary preview to the console.
#' @param print_full Logical. If TRUE, prints all rows (up to 5 columns). Default is FALSE.
#' @return A named list of data frames. The list always contains three entries
#'   corresponding to the main pillars: `studies`, `experiments`, and `analyses`.
#'   When extended codebooks exist (e.g. `experiment_cytof`), additional entries
#'   named after those codebooks are included, each filtered to the matching `type`.
#'   Data frames contain only the columns defined in the corresponding codebook;
#'   missing columns are silently dropped. An empty data frame is returned for
#'   pillars that have no `meta.yaml` files.
#' @examples
#' FAIRgroundOverview()
#' overview <- FAIRgroundOverview()
#' @export
FAIRgroundOverview <- function(print=TRUE, print_full=FALSE) {
  dataTypes <- c("studies", "experiments", "analyses")

  # Map the datatypes to the table names
  tableMapping <- list(
    studies = "study",
    experiments = "experiment",
    analyses = "analysis"
  )

  overview <- list()

  for (dataType in dataTypes) {
    dir <- file.path(dataType)
    files <- list.files(
      path = dir,
      pattern = "meta.yaml",
      recursive = TRUE,
      full.names = TRUE
    )

    # Function to read a yaml file and convert it to a dataframe
    readMetaToTable <- function(filePath) {
      data <- yaml::yaml.load_file(filePath)
      table <- as.data.frame(t(unlist(data)), stringsAsFactors = FALSE)
      return(table)
    }

    # Read and combine all meta.yaml files into one dataframe
    list <- lapply(files, readMetaToTable)

    # Combine meta files to one dataframe
    dataframe <- dplyr::bind_rows(list)

    # create the databook
    databook <- databook <- beFAIR::codebookToEntries(tableMapping[[dataType]], nrow=0)

    # select only the columns that are in the codebook
    if (ncol(dataframe) == 0) {
      databook$data <- data.frame() # in case of empty project
    } else {
      cols_to_keep <- colnames(databook$data)
      existing_cols <- intersect(cols_to_keep, colnames(dataframe))
      databook$data <- dataframe[, existing_cols, drop = FALSE]
    }

    # validate the overview
    # databook$validation <- beFAIR::validateDatabook(databook)

    # add to collection
    overview[[dataType]] <- databook$data

    # get the extended codebooks
    cbPaths <- list.files(system.file("codebooks", package="beFAIR"),
      pattern=".yaml", recursive = T, full.names= F)
    # find the extended codebooks (datatype name and underscore)
    extendedcbPaths <- grep(paste0(tableMapping[[dataType]], "_"), cbPaths, value = TRUE)
    extendedCodebooks <- tools::file_path_sans_ext(basename(extendedcbPaths))

    # for each extended codebook create a databook and add the right columns
    for(codebook in extendedCodebooks) {
      if (ncol(dataframe) == 0 || !"type" %in% colnames(dataframe)) next # skip if empty

      suffix <- sub(".*_", "", codebook)
      filtered_df <- dataframe %>% dplyr::filter(tolower(type) == suffix)

      databook <- beFAIR::codebookToEntries(codebook, nrow=0)
      if (ncol(filtered_df) == 0) {
        databook$data <- data.frame()
      } else {
        cols_to_keep <- colnames(databook$data)
        existing_cols <- intersect(cols_to_keep, colnames(filtered_df))
        databook$data <- filtered_df[, existing_cols, drop = FALSE]
      }

      overview[[codebook]] <- databook$data
    }
  }

  # Print summary for main overviews
  if (print) {
    cat("\n FAIRground Overview Summary\n")

    for (dataType in dataTypes) {
      df <- overview[[dataType]]
      n_rows <- nrow(df)
      n_cols <- ncol(df)

      cat("\n", toupper(dataType), ": ", n_rows, " rows × ", n_cols, " columns\n", sep = "")

      if (n_cols == 0 || n_rows == 0) {
        cat(" (no data available)\n")
        next
      }

      # Limit shown columns to 5 max
      col_limit <- min(5, n_cols)
      # Limit shown rows to 5 max (unless print_full is TRUE)
      row_limit <- if (print_full) n_rows else min(5, n_rows)

      # Subset safely
      preview <- df[1:row_limit, 1:col_limit, drop = FALSE]
      print(preview, row.names = FALSE)

      if (!print_full && n_rows > row_limit) {
        cat("\n ...preview only, set print_full = TRUE to see all rows\n")
      }
    }
  }


  return(invisible(overview)) # return object without printing it to the console
}

#' @rdname FAIRgroundOverview
#' @export
overviewFAIRground <- function(...) {
  .Deprecated("FAIRgroundOverview")
  FAIRgroundOverview(...)
}
