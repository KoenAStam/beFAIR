#' Filter a table list by study IDs
#'
#' This function takes an existing tableList object (as returned by getDatabase())
#' and filters all tables based on one or more study_id's. It preserves the structure of
#' the dataset while restricting its contents to only relevant studies, experiments and analyses.
#'
#' @param tableList Named list of data frames as produced by [getDatabase()].
#' @param study_ids Character vector of study identifiers to keep (e.g. `c("CHHIL", "ITCHI")`).
#'
#' @return A filtered version of `tableList`, containing only rows linked to the selected studies.
#'
#' @seealso [getDatabase()], [databaseExport()]
#'
#' @examples
#' \dontrun{
#'   data <- getDatabase(path = "data/")
#'   filtered <- filterTableList(data, study_ids = c("CHHIL", "ITCHI"))
#' }
#'
#' @export
filterTableList <- function(tableList, study_ids) {
  if (is.null(study_ids)) {
    warning("No study_ids provided. Returning original tableList.")
    return(tableList)
  }

  # Filter overview tables
  tableList$study <- dplyr::filter(tableList$study, study_id %in% study_ids)

  tableList$experiment <- tableList$experiment %>%
    dplyr::filter(sapply(study_ids, function(ids) {
      any(strsplit(ids, ", ")[[1]] %in% tableList$study$study_id)
    }))

  tableList$analysis <- tableList$analysis %>%
    dplyr::filter(sapply(study_ids, function(ids) {
      any(strsplit(ids, ", ")[[1]] %in% tableList$study$study_id)
    }))

  # Collect ids
  studyIDs <- tableList$study$study_id
  analysisIDs   <- tableList$analysis$analysis_id
  experimentIDs <- tableList$experiment$experiment_id

  # Filter all other tables based on linked IDs
  filteredTables <- lapply(names(tableList), function(name) {
    df <- tableList[[name]]

    if (name %in% c("study", "experiment", "analysis", "_meta")) return(df)

    if ("analysis_id" %in% colnames(df)) {
      df[df$analysis_id %in% analysisIDs, , drop = FALSE]
    } else if ("experiment_id" %in% colnames(df)) {
      df[df$experiment_id %in% experimentIDs, , drop = FALSE]
    } else if ("study_id" %in% colnames(df)) {
      df[df$study_id %in% studyIDs, , drop = FALSE]
    } else {
      NULL
    }
  })

  # Final cleaned tableList
  filteredList <- Filter(Negate(is.null), setNames(filteredTables, names(tableList)))

  # Print
  if (!is.null(filteredList$study)) {
    cat("\nStudies included:\n")
    filteredList$study %>%
      dplyr::select(study_id, name) %>%
      print()
  }

  if (!is.null(filteredList$experiment)) {
    cat("\nExperiments included:\n")
    filteredList$experiment %>%
      dplyr::select(experiment_id, name) %>%
      print()
  }

  if (!is.null(filteredList$analysis)) {
    cat("\nAnalyses included:\n")
    filteredList$analysis %>%
      dplyr::select(analysis_id, name) %>%
      print()
  }

  return(filteredList)
}
