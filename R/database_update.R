#' Update the FAIRground database
#'
#' The main orchestrator for a full database update cycle. Sequentially:
#' 1. Synchronizes codebook definitions with the database via
#'    [databasePrepareCodebooks()].
#' 2. Discovers new, changed, or outdated ETL scripts via
#'    [databasePrepareScripts()].
#' 3. For each script that requires (re)running: clears its existing database
#'    entries, sources the script, validates the resulting `databook`, and
#'    uploads the data via [databasePrepareData()].
#' 4. Rebuilds the overview tables (`study`, `experiment`, `analysis`) and the
#'    `publications` table unconditionally.
#'
#' The connection is also closed on exit.
#'
#' @param enable_logging Logical. If `TRUE`, JSON logs are written to
#'   `logs/files/<timestamp>.json` using the `lgr` package. Defaults to `FALSE`.
#' @param con A DBI connection. If `NULL`, the default connection set by [FAIRgroundConnect()] is used.
#'
#' @return Called for its side effects. Invisibly returns `NULL`.
#'
#' @seealso [databaseInitialize()], [databasePrepareCodebooks()],
#'   [databasePrepareScripts()], [databasePrepareData()],
#'   [databaseUpdateOverview()], [databaseUpdatePublications()]
#'
#' @examples
#' \dontrun{
#' FAIRgroundConnect("MY_DSN")
#' databaseUpdate()
#' databaseUpdate(enable_logging = TRUE)
#' }
#' @export
databaseUpdate <- function(enable_logging=FALSE, con=NULL) {

  # Initialize logger
  if (enable_logging) {
    .initLogger()
  } else {
    .disableLogger()
  }
  lg <- lgr::get_logger("beFAIR")

  # Connection
  con <- tryCatch(
    FAIRgroundConnection(con),
    error = function(e) {
      lg$fatal("Error: Could not connect to SQL server:",
               error_message = conditionMessage(e),
               caller = "FAIRgroundConnection")
      stop(e)
    }
  )
  lg$info("SQL connection established")

  # Start database update
  lg$info("Starting database update",
          sql_server = con@info$servername,
          sql_database = con@info$dbname,
          r_version = paste(R.version$major, R.version$minor, sep = "."),
          fairpoint_version = as.character(utils::packageVersion("beFAIR")),
          user = con@info$username,
          hostname = Sys.info()[["nodename"]])

  # Ensure database disconnec
  on.exit({
    if (!is.null(con) && DBI::dbIsValid(con)) {

      FAIRgroundDisconnect()
      lg$info("SQL connection closed",
              sql_server = con@info$servername,
              user = con@info$username,
              hostname = Sys.info()[["nodename"]])
    }

    if (enable_logging) {
      lg$info("Database update finished")
      .disableLogger()
    }
  }, add = TRUE)

  # prepare codebooks
  lg$info("Start databasePrepareCodebooks")
  databasePrepareCodebooks(con=con)
  lg$info("Finished databasePrepareCodebooks")

  # prepare pillar project registry and analysis dependencies
  lg$info("Start databasePrepareProjects")
  databasePrepareProjects(con = con)
  lg$info("Finished databasePrepareProjects")

  # prepare data sources
  lg$info("Start databasePrepareDatasources")
  databasePrepareDatasources(con = con)
  lg$info("Finished databasePrepareDatasources")

  # prepare ETL scripts
  lg$info("Start databasePrepareScripts")
  scriptsToUpdate <- databasePrepareScripts(con=con)
  lg$info("Finished databasePrepareScripts. ETL Scripts to be updated:",
          N = nrow(scriptsToUpdate))

  #TODO what if a script depends on another script (and codebook)
  #TODO maybe always start with id_mapping

  lg$info("Start ETL script processing")
  for (i in seq_len(nrow(scriptsToUpdate))) {
    script_id_i <- scriptsToUpdate[i, "script_id"]
    codebook_i  <- scriptsToUpdate[i, "codebook_name"]

    lg$info("Start processing script", script_id = script_id_i)

    # --- Internal delivery: standard ETL flow ---
    .sqlRemoveEntries(con = con,
                     table_name = codebook_i,
                     script_id = script_id_i)

    databook <- sourceScript(script_id_i, con = con)

    if (is.null(databook)) {
      lg$info("Execution of ETL script failed",
              script_id = script_id_i)
      next()
    }

    if (databook$validation$status == 1) {
      databasePrepareData(databook, script_id = script_id_i, con)
    } else {
      warn_count <- 0

      if (!is.null(databook$validation$summary)) {
        warn_count <- sum(databook$validation$summary$validation_set$warn)
      }

      lg$info("Validation of ETL script failed",
        script_id = script_id_i,
        pointblank_warnings = warn_count)

      next()
    }
  }


  lg$info("Finished ETL script processing")

  # always update the overview (study, experiment) and extended overview tables
  # (experiment_luminex, analysis_cytof, etc)
  lg$info("Start general table processing")
  databaseUpdateOverview(con=con)

  # always update publications
  databaseUpdatePublications(con=con)
  lg$info("Finished general table processing")

}

