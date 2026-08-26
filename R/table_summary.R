#' Summarise all variables in a codebook as a `gt` table
#'
#' Produces a `gt` summary table for all variables defined in the named
#' codebook. For each variable, the table reports its type, completeness,
#' percentage not applicable (`-999` / `"N/A"`), percentage not measured
#' (`"N/M"`), mean, SD, and median, min, max (numeric variables), or the
#' set of unique values (character variables).
#'
#' @param data A data frame containing the data to summarise, structured
#'   according to `codebook_name`.
#' @param codebook_name A character string specifying the codebook name
#'   (without `.yaml` extension).
#'
#' @return A `gt` table object with one row per codebook variable. The table
#'   header shows the codebook name and total row count. Completeness is
#'   colour-coded on a red-yellow-green scale.
#'
#' @seealso [tableVariableByStudy()], [codebookRead()],
#'  [codebookToSummary()]
#'
#' @examples
#' \dontrun{
#' FAIRgroundConnect("LUCID_FAIRPOINT")
#' data <- DBI::dbReadTable(FAIRgroundConnection(), "participant")
#' tableSummary(data, "participant")
#' }
#' @import gt
#' @import dplyr
#'
#' @export
tableSummary <- function(data, codebook_name) {
  codebook <- codebookRead(codebook_name=codebook_name)$variables

  # always remove script_id from data and codebook
  codebook <- codebook[names(codebook) != "script_id"]
  data <- data %>% select(-any_of("script_id"))

  variables <- names(codebook)


  # create dataset without missing values
  missingValues <- c(-999, "N/A", "N/M")
  dataComplete <- data %>%
    mutate(across(everything(), ~ ifelse(. %in% missingValues, NA, .)))

  # Function to calculate the percentage of 'NA' values (actual missing data)
  getCompletePercentage <- function(column) {
    round(1 - sum(is.na(column)) / length(column), 1)
  }

  # Function to calculate the percentage of specific missing values (-999, N/A, N/M)
  getMissingPercentage <- function(column, missing_value) {
    if (is.list(column)) return(NA_real_) # safely return NA for list-columns
    sum(column == missing_value, na.rm = TRUE) / length(column)
  }

  getMean <- function(column) {
    if (is.numeric(column)) {
      round(mean(column, na.rm = TRUE), 1)
    } else {
      NA
    }
  }

  getSD <- function(column) {
    if (is.numeric(column)) {
      sd(column, na.rm = TRUE)
    } else {
      NA
    }
  }

  getMedian <- function(column) {
    if (is.numeric(column)) {
      do.call(sprintf, c("%.1f [%.1f, %.1f]", as.list(quantile(column, c(0.5, 0, 1), na.rm = TRUE))))
    } else {
      NA
    }
  }

  getSet <- function(column) {
    if (is.character(column)) {
      maxChars <- 20
      setValues <- paste0("[", paste(unique(column), collapse = "|"), "]")
      if (nchar(setValues) > maxChars) {
        return(paste0(substr(setValues, 1, maxChars), "..."))
      }
      return(setValues)
    } else {
      return(NA)
    }
  }

  # Create the report table
  summaryTable <- tibble(varName = variables) %>%
    mutate(
      type = purrr::map_chr(varName, ~ codebook[[.x]]$type),
      color = "",
      complete = purrr::map_dbl(varName, ~ getCompletePercentage(data[[.x]])),

      # Compute missing percentages
      missing_NA_999 = purrr::map_dbl(varName, ~ getMissingPercentage(data[[.x]], -999)),
      missing_NA_chr = purrr::map_dbl(varName, ~ getMissingPercentage(data[[.x]], "N/A")),
      missing_NA = ifelse(type == "numeric", missing_NA_999, missing_NA_chr), # combine not applicable
      missing_NM = purrr::map_dbl(varName, ~ getMissingPercentage(data[[.x]], "N/M")),

      # Replace missing percentages that are 0 with an empty string
      missing_NA_display = ifelse(missing_NA == 0, "", paste0(round(missing_NA * 100, 0), "%")),
      missing_NM_display = ifelse(missing_NM == 0, "", paste0(round(missing_NM * 100, 0), "%")),

      # Calculate summary stats
      mean = purrr::map_dbl(varName, ~ getMean(dataComplete[[.x]])),
      sd = purrr::map_dbl(varName, ~ getSD(dataComplete[[.x]])),
      median = purrr::map_chr(varName, ~ getMedian(dataComplete[[.x]])),
      set = purrr::map_chr(varName, ~ getSet(dataComplete[[.x]])),
      notes = ""
    ) %>%

    select(-missing_NA_999, -missing_NA_chr, -missing_NA, -missing_NM) %>%

    # Format table
    gt::gt() %>%
    gt::tab_options(
      table.font.size = gt::px(14),
    ) %>%
    gt::tab_header(
      title = gt::html(paste0("<b>", codebook_name, "</b>")),
      subtitle = paste0("Number of rows: ", nrow(data))
    ) %>%
    gt::fmt_percent(columns = c(complete), decimals = 0) %>%
    gt::fmt_scientific(
      columns = c(mean, sd),
      decimals = 2
    ) %>%
    gt::cols_label(
      varName = "Variable",
      color = "",
      complete = "% Complete",
      missing_NA_display = "% Not applicable",
      missing_NM_display = "% Not measured",
      type = "Type",
      mean = gt::html("<i>&mu;</i>"),
      sd = gt::html("<i>&sigma;</i>"),
      median = "Med (min,max)",
      notes = "Notes"
    ) %>%
    gt::sub_missing(
      columns = everything(),
      missing_text = "-"  # Replace NA with an empty string
    ) %>%
    gt::cols_width(
      varName ~ gt::px(120),
    ) %>%
    gt::data_color(
      columns = complete,
      target_columns = color,
      fn = scales::col_numeric(
        palette = scales::brewer_pal(palette = "RdYlGn")(9),
        domain = c(0, 1)
      )
    ) %>%
    gt::tab_style(
      style = gt::cell_text(align="center"),
      locations = gt::cells_column_labels(2:3)
    )

  return(summaryTable)
}
