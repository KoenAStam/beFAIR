#' Convert a date string to ISO 8601 format
#'
#' @param date_string A character string representing a date.
#' @param date_format Format of `date_string`: `"ymd"` (default) or `"dmy"`.
#'
#' @return A character string in `"YYYY-MM-DD"` format, or `NA` when the input
#'   is `"-99"`, `"-98"`, `NA`, or unparseable.
#'
#' @export
harmonizeDate <- function(date_string, date_format = "ymd") {
  if (date_string == "-99" || date_string == "-98" || is.na(date_string)) {
    return(NA)
  }

  dateParsed <- suppressWarnings(tryCatch({
    if (date_format == "ymd") {
      lubridate::ymd(date_string)
    } else if (date_format == "dmy") {
      lubridate::dmy(date_string)
    } else {
      stop("Unsupported date format. Supported formats are 'ymd' and 'dmy'.")
    }
  }, error = function(e) NA))

  if (!is.na(dateParsed)) {
    return(format(dateParsed, "%Y-%m-%d"))
  } else if (grepl("^\\d{4}-\\d{1,2}$", date_string)) {
    dateParsed <- tryCatch({
      lubridate::ymd(paste0(date_string, "-01"))
    }, error = function(e) NA)

    if (!is.na(dateParsed)) {
      return(format(dateParsed, "%Y-%m-%d"))
    }
  }
}
