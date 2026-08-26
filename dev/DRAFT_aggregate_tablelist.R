#' Summarise participant and adverse_event by study arm
#'
#' Numeric and categorical summary statistics for the harmonized
#' participant and adverse_event tables.
#'
#' @param study_id Optional study to filter to. Default `NULL` (all studies).
#' @param con A [DBI] connection. If `NULL`, the default connection set by [FAIRgroundConnect()] is used.
#'
#' @return A list with `participant` and `adverse_event` summary tibbles.
#'
#' @noRd
aggregate_to_studyarm <- function(study_id = NULL, con = NULL) {

  con <- beFAIR::FAIRgroundConnection(con)
  participant <- DBI::dbReadTable(con, "participant")
  adverse_event <- DBI::dbReadTable(con, "adverse_event")


  # Filter to study_id, if needed
  if (!is.null(study_id)) {
    target_study <- study_id
    participant <- participant |> dplyr::filter(study_id %in% target_study)
    adverse_event <- adverse_event |> dplyr::filter(study_id %in% target_study)
  }

  # If there is no studyarm_id skip
  # (i.e. the study only has 1 arm, currently only the case for BMG2b)
  participant <- participant |>
    dplyr::filter(!is.na(studyarm_id))

  # Build a participant_id -> studyarm_id, study_id lookup
  arm_lookup <- participant |>
    dplyr::distinct(participant_id, studyarm_id, study_id)

  # study_id is the only column adverse_event and arm_lookup have in common, drop it before joining.
  adverse_event <- adverse_event |>
    dplyr::select(-study_id) |>
    dplyr::left_join(arm_lookup, by = "participant_id")

  # The variables to be used, add new ones if necessary
  participant_vars <- c("age", "height", "weight", "bmi", "sex", "site", "ethnicity", "residence")
  # TODO probably not all these are needed?
  adverse_event_vars <- c("start_timepoint", "end_timepoint", "registration_timepoint",
                          "severity", "relation", "serious", "clinical_condition_code")

  # Computes n, nmiss, mean, sd, cv, se, min, max, median, q25, q75, iqr for every numeric column
  summarise_numeric <- function(df, vars) {

    # x can be entirely missing for a group (e.g. BMG2b), which would otherwise produce -Inf/Inf
    finite_or_na <- \(v) if (is.infinite(v)) NA else v

    stat_fns <- list(
      n      = \(x) sum(!is.na(x)),
      nmiss  = \(x) sum(is.na(x)),
      mean   = \(x) mean(x, na.rm = TRUE),
      sd     = \(x) sd(x, na.rm = TRUE),
      cv     = \(x) { m <- mean(x, na.rm = TRUE); if (is.na(m)) NA else 100 * sd(x, na.rm = TRUE) / abs(m) },
      se     = \(x) sd(x, na.rm = TRUE) / sqrt(sum(!is.na(x))),
      min    = \(x) finite_or_na(suppressWarnings(min(x, na.rm = TRUE))),
      max    = \(x) finite_or_na(suppressWarnings(max(x, na.rm = TRUE))),
      median = \(x) median(x, na.rm = TRUE),
      q25    = \(x) quantile(x, 0.25, na.rm = TRUE, names = FALSE),
      q75    = \(x) quantile(x, 0.75, na.rm = TRUE, names = FALSE),
      iqr    = \(x) IQR(x, na.rm = TRUE)
    )

    df |>
      dplyr::group_by(studyarm_id, study_id) |>
      dplyr::summarise(
        dplyr::across(dplyr::all_of(vars), stat_fns, .names = "{.col}__{.fn}"),
        .groups = "drop"
      ) |>
      tidyr::pivot_longer(-c(studyarm_id, study_id), names_to = c("variable", "stat"), names_sep = "__") |>
      tidyr::pivot_wider(names_from = stat, values_from = value) |>
      dplyr::mutate(type = "numeric")
  }

  # Computes n, %, and nmiss for each level of every categorical column
  categorical_summary <- function(df, vars) {
    lapply(vars, \(var) {
      nmiss_tbl <- df |>
        dplyr::group_by(studyarm_id, study_id) |>
        dplyr::summarise(nmiss = sum(is.na(!!rlang::sym(var))), .groups = "drop")

      df |>
        dplyr::filter(!is.na(!!rlang::sym(var))) |>
        dplyr::count(studyarm_id, study_id, level = !!rlang::sym(var)) |>
        dplyr::group_by(studyarm_id, study_id) |>
        dplyr::mutate(pct = n / sum(n) * 100, variable = var, type = "categorical") |>
        dplyr::ungroup() |>
        dplyr::left_join(nmiss_tbl, by = c("studyarm_id", "study_id"))
    }) |>
      dplyr::bind_rows()
  }

  # Splits variables by column type and then runs the matching summary
  summarise_vars <- function(df, vars) {
    is_num <- sapply(df[vars], is.numeric)
    dplyr::bind_rows(
      summarise_numeric(df, vars[is_num]),
      categorical_summary(df, vars[!is_num])
    )
  }

  list(
    participant = summarise_vars(participant, participant_vars)
    # adverse_event = summarise_vars(adverse_event, adverse_event_vars)
  )
}
