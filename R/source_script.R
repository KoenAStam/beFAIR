#' Source an ETL script and return its databook
#'
#' Executes an ETL script in an isolated environment, captures warnings and
#' counts `#TODO` flags, and returns the `databook` object produced by the
#' script. Returns `NULL` if the script errors.
#'
#' @param script_id Character. Relative path to the ETL script (used as the
#'   script identifier).
#' @param echo Logical. Passed to [base::source()]; whether each expression is
#'   printed as it is evaluated. Default: `FALSE`.
#' @param con A DBI connection. If `NULL`, the default connection set by [FAIRgroundConnect()] is used.
#'
#' @return A `databook` list containing `$data`, `$codebook`,
#'   `$codebook_name`, `$codebook_version`, `$validation`, `$run_time`,
#'   `$flag_TODO`, and `$flag_WARN`. Returns `NULL` if the script fails.
#' @seealso [databaseUpdate()], [databasePrepareScripts()]
#' @examples
#' \dontrun{
#'   databook <- sourceScript("studies/CHHIL/scripts/participant.R")
#' }
#'
#' @export
sourceScript <- function(script_id, echo=FALSE, con=NULL) {
  lg <- lgr::get_logger("beFAIR")

  lg$info("Executing ETL script", script_id = script_id)

  localEnv <- new.env(parent = asNamespace("utils")) # TODO fix namespace and scope
  localEnv$con <- FAIRgroundConnection(con)

  # Get flag_TODO
  #TODO add more flags?
  flag_TODO <- vapply(readLines(script_id, warn = FALSE), function(x)
    grepl("#\\s*TODO", x), logical(1)) %>% sum()
  flag_WARN <- 0

  databook <- tryCatch(
    withCallingHandlers(
      {
        sTime <- Sys.time()
        source(script_id, local = localEnv, echo = echo)
        databook <- localEnv$databook
        databook$run_time <- round(as.numeric(Sys.time() - sTime), 3)
        databook$flag_TODO <- flag_TODO
        databook$flag_WARN <- flag_WARN
        databook
      },
      warning = function(w) {
        lg$warn(
          "Warning in ETL script",
          script_id = script_id,
          warning = conditionMessage(w)
        )
        flag_WARN <<- flag_WARN + 1
        tryInvokeRestart("muffleWarning")
      },
      message = function(m) {
        #TODO decide what to do with messages (now we get the pointblank validation spam)
        # lg$info(
        #   "Message from ETL script",
        #   script_id = script_id,
        #   message = conditionMessage(m)
        # )
        tryInvokeRestart("muffleMessage")
      }
    ),
    error = function(e) {
      lg$error(
        "Error sourcing ETL script",
        script_id = script_id,
        error = conditionMessage(e),
        caller = "sourceScript" #TODO Add proper traceback
      )
      return(NULL)
    }
  )

  databook
}

