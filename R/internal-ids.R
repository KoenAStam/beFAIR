#' Generate a unique analysis ID
#'
#' Generates a random analysis ID in the format `A` followed by 6 lowercase
#' hexadecimal characters (e.g. `"Aa3f9c1d"`). Uniqueness is guaranteed by
#' comparing against all existing analysis IDs read from the project's
#' `meta.yaml` files via [FAIRgroundOverview()]; a new ID is resampled if a
#' collision is detected.
#'
#' @return A character string: `"A"` followed by 6 random lowercase
#'   hexadecimal characters (e.g. `"Aa3f9c1d"`), guaranteed to be unique
#'   within the current FAIRground.
#'
#' @seealso [.setExperimentId()], [addAnalysis()]
#'
#' @examples
#' .setAnalysisId()
#' @keywords internal
.setAnalysisId <- function() {
  # get all existing analyses
  analyses <- FAIRgroundOverview(print=FALSE)$analyses

  # Generate ID: A + 6 random hex characters
  randomID <- paste0("A", paste0(sample(c(0:9, letters[1:6]), 6, replace = TRUE), collapse = ""))

  # Resample if collision
  if (nrow(analyses) > 0) {
    while (randomID %in% analyses$analysis_id) {
      randomID <- paste0("A", paste0(sample(c(0:9, letters[1:6]), 6, replace = TRUE), collapse = ""))
    }
  }

  return(randomID)
}

#' Generate a unique experiment ID
#'
#' Generates a random experiment ID in the format `E` followed by 6 lowercase
#' hexadecimal characters (e.g. `"Ea3f9c1d"`). Uniqueness is guaranteed by
#' comparing against all existing experiment IDs read from the project's
#' `meta.yaml` files via [FAIRgroundOverview()]; a new ID is resampled if a
#' collision is detected.
#'
#' @return A character string: `"E"` followed by 6 random lowercase
#'   hexadecimal characters (e.g. `"Ea3f9c1d"`), guaranteed to be unique
#'   within the current FAIRground.
#'
#' @seealso [.setAnalysisId()], [addExperiment()]
#'
#' @examples
#' .setExperimentId()
#' @keywords internal
.setExperimentId <- function() {
  # get all existing experiments
  experiments <- FAIRgroundOverview(print=FALSE)$experiments

  # Generate ID: E + 6 random hex characters
  randomID <- paste0("E", paste0(sample(c(0:9, letters[1:6]), 6, replace = TRUE), collapse = ""))

  # Resample if collision
  if (nrow(experiments) > 0) {
    while (randomID %in% experiments$experiment_id) {
      randomID <- paste0("E", paste0(sample(c(0:9, letters[1:6]), 6, replace = TRUE), collapse = ""))
    }
  }

  return(randomID)
}

#' Add a stable `participant_id` to an ID mapping table
#'
#' Creates a deterministic participant identifier derived from `study_id` and
#' `participant_nr`.
#'
#' @details
#' The identifier is constructed by concatenating `study_id` and a zero-padded
#' (4-digit) `participant_nr`, hashing the key with SHA-256, and taking the
#' first six hexadecimal characters. Final form: `"<study_id>_<hash6>"`.
#'
#' Multiple `source_id` values may map to the same participant when they share
#' the same `study_id` and `participant_nr`. Hash truncation means collisions
#' are theoretically possible but very unlikely.
#'
#' @param id_mapping A data frame with columns `source_id`, `study_id`, and
#'   `participant_nr` (integer).
#'
#' @return A data.frame with columns `source_id`, `study_id`, `participant_nr`,
#'   and `participant_id`.
#'
#' @keywords internal
.addParticipantIds <- function(id_mapping) {
  out <- id_mapping %>%
    mutate(
      key   = paste0(study_id, "_", sprintf("%04d", participant_nr)),
      hash  = vapply(key, .hash, character(1), type = "string", algo = "sha256", serialize = FALSE),
      hash6 = substr(hash, 1, 6),
      participant_id = paste0(study_id, "_", hash6)
    ) %>%
    select(source_id, study_id, participant_nr, participant_id)

  out
}
