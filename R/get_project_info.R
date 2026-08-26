#' Retrieve all registry information for a project
#'
#' Queries every registry table (\code{table_project}, \code{table_script},
#' \code{table_dependency}, \code{table_datasource}, \code{table_codebook})
#' and returns the rows that belong to the given \code{project_id} as a named
#' list of data frames.
#'
#' @param project_id Character scalar. The unique project identifier
#'   (\code{study_id}, \code{experiment_id}, or \code{analysis_id}) as stored
#'   in \code{table_project}.
#' @param con A \code{DBIConnection}. If \code{NULL} (default) the package-level
#'   connection set by \code{\link{FAIRgroundConnect}} is used.
#'
#' @return A named list with elements:
#' \describe{
#'   \item{project}{1-row data frame from \code{table_project}.}
#'   \item{scripts}{data frame from \code{table_script} for scripts
#'     belonging to this project (matched by path prefix).}
#'   \item{dependencies}{data frame from \code{table_dependency} — all rows
#'     where \code{script_id} is one of this project's scripts, plus any rows
#'     where \code{project_id} matches (analysis-input dependencies).}
#'   \item{datasources}{data frame from \code{table_datasource} for datasource
#'     files residing in this project's directory.}
#'   \item{codebooks}{data frame from \code{table_codebook} for every codebook
#'     targeted by this project's scripts.}
#' }
#' Returns \code{NULL} invisibly (with a warning) if \code{project_id} is not
#' found in \code{table_project}.
#'
#' @export
getProjectInfo <- function(project_id, con = NULL) {
  con <- FAIRgroundConnection(con)
  lg  <- lgr::get_logger("beFAIR")

  # 1. Look up the project row -------------------------------------------
  project_row <- DBI::dbGetQuery(
    con,
    "SELECT * FROM table_project WHERE project_id = ?",
    params = list(project_id)
  )

  if (nrow(project_row) == 0L) {
    warning("project_id '", project_id, "' not found in table_project.")
    return(invisible(NULL))
  }

  pillar       <- project_row$pillar
  project_name <- project_row$project_name
  path_prefix  <- paste0(pillar, "/", project_name, "/")

  lg$info("Retrieving project info", project_id = project_id, pillar = pillar)

  # 2. Scripts (by path prefix) -----------------------------------------
  scripts <- DBI::dbGetQuery(
    con,
    "SELECT * FROM table_script WHERE script_id LIKE ?",
    params = list(paste0(path_prefix, "scripts/%"))
  )

  # 3. Dependencies (via script_id or project_id) -----------------------
  script_ids <- scripts$script_id

  if (length(script_ids) > 0L) {
    placeholders <- paste(rep("?", length(script_ids)), collapse = ", ")
    dep_by_script <- DBI::dbGetQuery(
      con,
      paste0("SELECT * FROM table_dependency WHERE script_id IN (", placeholders, ")"),
      params = as.list(script_ids)
    )
  } else {
    dep_by_script <- DBI::dbGetQuery(
      con,
      "SELECT * FROM table_dependency WHERE 1 = 0"
    )
  }

  dep_by_project <- DBI::dbGetQuery(
    con,
    "SELECT * FROM table_dependency WHERE project_id = ?",
    params = list(project_id)
  )

  dependencies <- unique(rbind(dep_by_script, dep_by_project))

  # 4. Datasources (by path prefix) -------------------------------------
  datasources <- DBI::dbGetQuery(
    con,
    "SELECT * FROM table_datasource WHERE datasource_id LIKE ?",
    params = list(paste0(path_prefix, "%"))
  )

  # 5. Codebooks (by codebook_name in scripts) --------------------------
  cb_names <- unique(scripts$codebook_name)
  cb_names <- cb_names[!is.na(cb_names)]

  if (length(cb_names) > 0L) {
    placeholders <- paste(rep("?", length(cb_names)), collapse = ", ")
    codebooks <- DBI::dbGetQuery(
      con,
      paste0("SELECT * FROM table_codebook WHERE codebook_name IN (", placeholders, ")"),
      params = as.list(cb_names)
    )
  } else {
    codebooks <- DBI::dbGetQuery(
      con,
      "SELECT * FROM table_codebook WHERE 1 = 0"
    )
  }

  list(
    project      = project_row,
    scripts      = scripts,
    dependencies = dependencies,
    datasources  = datasources,
    codebooks    = codebooks
  )
}
