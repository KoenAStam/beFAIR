#' Extract the short pillar ID from a parsed meta.yaml list
#'
#' @param meta A named list parsed from a pillar \code{meta.yaml} file.
#' @param pillar One of \code{"studies"}, \code{"experiments"}, or
#'   \code{"analyses"}.
#'
#' @return A character scalar with the pillar ID, or \code{NA_character_} if
#'   the field is missing.
#'
#' @keywords internal
.readPillarId <- function(meta, pillar) {
  id_field <- switch(pillar,
    studies     = "study_id",
    experiments = "experiment_id",
    analyses    = "analysis_id",
    NA_character_
  )
  val <- meta[[id_field]]
  if (is.null(val)) NA_character_ else as.character(val[[1]])
}
