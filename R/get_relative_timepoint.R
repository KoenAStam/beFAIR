#' Convert timepoint descriptions to relative timepoints in days
#'
#' Resolves textual timepoint descriptions (e.g. `"C1"`, `"I2+14"`) to numeric
#' timepoints in days relative to the anchor day, by joining against the
#' `id_mapping`, `participant`, and `studydesign` database tables.
#' Timepoint descriptions must follow the pattern `<C|I><number>[+/-offset]`,
#' for example `"C1"`, `"C-7"`, `"I_LAST+14"`, or `"I3+14"`. Invalid descriptions produce a
#' warning and result in `NA` for the corresponding rows.
#'
#' @param study_id A character vector of study identifiers, one per row of input.
#' @param source_id A character vector of original participant identifiers
#'   (source IDs), one per row of input.
#' @param timepoint_description A character vector of timepoint descriptions
#'   as used in the study design (e.g. `"C1"`, `"I2+14"`, `"I_LAST+14"`, `"C-7"`).
#' @param verbose Logical. If `TRUE`, messages the study design timeline with
#'   the resolved time points. Defaults to `FALSE`.
#' @param con A DBI connection. If `NULL`, the default connection set by [FAIRgroundConnect()] is used.
#'
#' @return A data frame with columns `study_id`, `source_id`,
#'   `timepoint_description`, and `timepoint` (integer, days relative to the
#'   anchor day). Rows where the description could not be resolved have `NA`
#'   in `timepoint`.
#'
#' @seealso [codebookToSummary()]
#'
#' @examples
#' \dontrun{
#' FAIRgroundConnect("LUCID_FAIRPOINT")
#' getRelativeTimepoint(
#'   study_id             = c("CoHSI1", "PfGA1"),
#'   source_id            = c("CS1-229", "BMV_021"),
#'   timepoint_description = c("C-1", "I1+14")
#' )
#' }
#' @export
getRelativeTimepoint <- function(study_id, source_id, timepoint_description, verbose=FALSE, con=NULL){
  # TODO Also add the option to use participant_ids instead of source ids

  lg <- lgr::get_logger("beFAIR")

  con <- FAIRgroundConnection(con)

  # remove spaces
  timepointDescription <- gsub("\\s+", "", timepoint_description)
  sourceId <- source_id
  studyId <- study_id

  # ----------------------------
  # Parse C1, I2+14, C-7, I_LAST+14
  # ----------------------------
  timepointParts <- regmatches(
    timepointDescription,
    regexec("^([CI](?:_?LAST|\\d+))([+-]\\d+)?$", timepointDescription)
  )

  invalidTimepoint <- lengths(timepointParts) < 2

  if (any(invalidTimepoint)) {
    lg$warn(
      paste0(
        "Invalid timepoint_description detected.\n",
        "Supported examples: C1, I2+14, I_LAST, I_LAST+14\n\n",
        "Invalid values:\n  - ",
        paste(unique(timepointDescription[invalidTimepoint]), collapse = "\n  - ")
      ),
      call. = FALSE
    )
  }

  timepointParts <- lapply(timepointParts, function(x){
    if (length(x) < 2) {
      return(list(full = NA_character_,
        eventType = NA_character_,
        offset = NA_character_))
    }

    if (length(x) == 2) {
      return(list(full = x[1],
        eventType = x[2],
        offset = NA_character_))
    }

    list(full = x[1],
      eventType = x[2],
      offset = x[3])
  })

  code <- vapply(timepointParts, `[[`, NA_character_, "eventType")

  # If only C or I make it C1/I1
  code <- ifelse(code %in% c("C", "I"), paste0(code, "1"), code)

  valid_code <- !is.na(code) & (
    grepl("^[CI][1-9]$", code) |
      code == "I_LAST"
  )

  if(any(!valid_code & !is.na(code))){
    warning(    "First part of timepoint_description must be C1, C2, C3 or I1, I2, I3, etc, or I_LAST")
  }

  code[!valid_code] <- NA_character_

  offset <- vapply(timepointParts, function(part){
    if (is.na(part$eventType)) return(NA_integer_)
    if (!is.na(part$offset) && nzchar(part$offset)) return(as.integer(part$offset))
    0L
  }, NA_integer_)

  is_last <- grepl("_?LAST", code)
  code_clean <- gsub("_?LAST", "", code)

  df <- data.frame(
    study_id = studyId,
    source_id = sourceId,
    timepoint_description = timepointDescription,
    event_name = code_clean,
    offset = offset,
    is_last = is_last
  )

  # ----------------------------
  # Mapping tables
  # ----------------------------
  idMapping <- DBI::dbReadTable(con, "id_mapping") %>%
    dplyr::filter(
      source_id %in% sourceId,
      study_id %in% studyId
    ) %>%
    dplyr::select(source_id, participant_id, study_id)

  missingSourceIds <- setdiff(sourceId, idMapping$source_id)

  if(length(missingSourceIds) > 0){
    msg <- paste(
      "The following source_ids were not found in id_mapping:",
      paste0("  - ", missingSourceIds),
      collapse = "\n"
    )
    lg$warn(msg)
  }

  participant <- DBI::dbReadTable(con, "participant") %>%
    dplyr::filter(participant_id %in% idMapping$participant_id) %>%
    dplyr::select(participant_id, studyarm_id)

  studydesign <- DBI::dbReadTable(con, "studydesign") %>%
    dplyr::filter(studyarm_id %in% unique(participant$studyarm_id)) %>%
    dplyr::select(studyarm_id, timepoint, event_type, event_name)

  last_I_lookup <- studydesign %>%
    dplyr::filter(grepl("^I", event_name)) %>%
    dplyr::mutate(I_index = as.integer(sub("^I", "", event_name))) %>%
    dplyr::group_by(studyarm_id) %>%
    dplyr::summarise(
      last_I_timepoint = if (all(is.na(timepoint))) NA_real_ else max(timepoint, na.rm = TRUE),
      .groups = "drop"
    )

  participantsJoined <- idMapping %>%
    dplyr::left_join(participant, by = "participant_id")

  dfParticipantsjoined <- df %>%
    dplyr::left_join(participantsJoined, by = c("study_id", "source_id"))

  # ----------------------------
  # FINAL JOIN + LAST TIMEPOINT LOGIC
  # ----------------------------
  out <- dfParticipantsjoined %>%
    dplyr::left_join(
      studydesign,
      by = c("studyarm_id", "event_name")
    ) %>%
    dplyr::left_join(last_I_lookup, by = "studyarm_id") %>%
    mutate(
      timepoint = dplyr::case_when(
        is_last ~ last_I_timepoint + offset,
        TRUE ~ timepoint + offset
      )
    ) %>%
    dplyr::select(study_id, source_id, timepoint_description, timepoint)

  return(out)

  #TODO write some checks, like what if mapping did not succeed etc..
  return(out)

  #TODO create graphical representation of study_design timeline
}
