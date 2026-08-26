#' Check whether source IDs exist in the ID mapping table
#'
#' Checks if each `source_id` is present in the database table `id_mapping`
#' for the corresponding `study_id`. Reserved control/blank IDs (`"BLANK"`,
#' `"STD"`, `"CTRL"`, `"NEG_CTRL"`, `"POS_CTRL"`, `"BLANK_STD"`,
#' `"SAMPLE_STD"`) are skipped without a database lookup.
#'
#' @param source_id A character vector of source IDs to check.
#' @param study_id A character vector of study IDs, same length as
#'   `source_id` (or length 1 to recycle).
#' @param con A DBI connection. If `NULL`, the default connection set by
#'   [FAIRgroundConnect()] is used.
#'
#' @return A named list:
#' \describe{
#'   \item{all_exist}{Logical scalar; `TRUE` when all IDs were found.}
#'   \item{missing_id}{Data frame with columns `id`, `study_id`,
#'     and `id_type` for any unresolved IDs.}
#' }
#'
#' @export
validateSourceId <- function(source_id, study_id, con = NULL) {
  lg <- lgr::get_logger("beFAIR")
  con <- FAIRgroundConnection(con)

  if (any(is.na(source_id) | is.na(study_id))) {
    .logWarning("source_id or study_id contains NA's")
  }

  skip_ids <- c("BLANK", "STD", "CTRL", "NEG_CTRL", "POS_CTRL", "BLANK_STD", "SAMPLE_STD")

  skipped <- source_id %in% skip_ids
  if (any(skipped)) {
    lg$info("Skipping reserved source IDs (control/blank samples)",
            skipped_ids = unique(source_id[skipped]))
    source_id <- source_id[!skipped]
    study_id  <- study_id[!skipped]
  }

  # Early return if nothing left to validate
  if (length(source_id) == 0) {
    return(list(all_exist = TRUE,
                missing_id = data.frame(source_id = character(0),
                                        study_id  = character(0))))
  }

  # Detect participant IDs (example: CTanV_A1B2c3)
  participant_pattern <- paste0("^", study_id, "_[A-Za-z0-9]{6}$")

  is_participant_id <- mapply(
    function(id, pattern) grepl(pattern, id),
    source_id,
    participant_pattern
  )

  if (any(is_participant_id)) {
    lg$info("Detected participant IDs in source_id column. Using participant_id for validation.")
  }

  id_mapping <- DBI::dbReadTable(con, "id_mapping")

  # Check participant_ids
  participant_missing <- tibble::tibble(
    participant_id = source_id[is_participant_id],
    study_id  = study_id[is_participant_id]
  ) %>%
    dplyr::anti_join(id_mapping, by = c("participant_id", "study_id")) %>%
    dplyr::mutate(id_type = "participant_id")

  # Check normal source_id
  source_missing <- tibble::tibble(
    source_id = source_id[!is_participant_id],
    study_id  = study_id[!is_participant_id]
  ) %>%
    dplyr::anti_join(id_mapping, by = c("source_id", "study_id")) %>%
    dplyr::mutate(id_type = "source_id")

  missing_ids <- dplyr::bind_rows(
    source_missing %>% dplyr::rename(id = source_id),
    participant_missing %>% dplyr::rename(id = participant_id)
  )

  if (nrow(missing_ids) == 0) {
    lg$info("All provided source IDs exist in 'id_mapping' table",
            table_name = "id_mapping",
            study_id = unique(study_id))
    all_exist <- TRUE
  } else {
    .logWarning("Some provided source IDs do not exist in 'id_mapping'",
                 table_name = "id_mapping",
                 study_id = unique(missing_ids$study_id))
    all_exist <- FALSE
  }

  list(
    all_exist  = all_exist,
    missing_id = missing_ids
  )
}
