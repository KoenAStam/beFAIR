#' Sets up the lgr logger hierarchy with JSON file output.
#'
#' @param log_dir directory for log files
#'
#' @keywords internal
.initLogger <- function(log_dir = "logs/files") {
  lg <- lgr::get_logger("beFAIR")

  # Clear any existing appenders to prevent double logs if called twice
  lg$config(NULL)

  lg$set_threshold("info")
  lg$set_propagate(TRUE)

  # Create filename
  log_file <- paste0(log_dir, "/", format(Sys.time(), "%Y-%m-%d_%H-%M-%S"), ".json")

  # Add JSON appender to the main logger
  lg$add_appender(
    lgr::AppenderFile$new(
      file = log_file,
      layout = lgr::LayoutJson$new()
    ),
    name = "json"
  )

  lg$info("Logger initialized")

  invisible(lg)
}

#' Disable beFAIR Logger (Internal Use)
#'
#' @keywords internal
.disableLogger <- function() {
  lg <- lgr::get_logger("beFAIR")

  # Remove appenders (this triggers a flush to disk)
  if (length(lg$appenders) > 0) {
    for (app_name in names(lg$appenders)) {
      lg$remove_appender(app_name)
    }
  }

  # TODO Maybe just never disable logger? not really sure
  lg$set_threshold("info")
  invisible(NULL)
}

#' Log warning both in lgr and base R warning
#'
#' @param msg message to be printed
#' @param ... further arguments for lgr
#'
#' @keywords internal
.logWarning <- function(msg, ...) {
  lg <- lgr::get_logger("beFAIR")
  lg$warn(msg, ...)
  signalCondition(simpleWarning(msg))
}
