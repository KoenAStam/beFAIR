#' Prepare and synchronize beFAIR codebooks with the database
#'
#' Builds a codebook metadata overview from the beFAIR package and
#' synchronizes it with the database table `table_codebook`. New codebooks are
#' inserted and their corresponding SQL tables are created. For existing
#' codebooks, version changes are detected and handled as follows:
#'
#' * **Major version increase**: drops and recreates the corresponding data
#'     table, and replaces the metadata row in `table_codebook`.
#' * **Minor version increase**: updates metadata in `table_codebook`
#'     (e.g., version, authors, update date, and parameter count).
#'
#'
#' @param con A DBI connection. If `NULL`, the default connection set by [FAIRgroundConnect()] is used.
#'
#' @return Invisibly returns `NULL`. Called for its side effects on the database.
#'
#' @details
#' **Database requirements:** This function expects the metadata table
#' `table_codebook` to exist and be readable.
#'
#' **Database effects:**
#'
#' * Inserts rows into `table_codebook` for newly detected codebooks.
#' * Creates SQL data tables for new codebooks via `.sqlGenerateTable()`.
#' * On major updates, executes `DROP TABLE IF EXISTS <codebook_name>` and
#'     recreates the table, then replaces the corresponding `table_codebook` row.
#' * On minor updates, updates `table_codebook` fields in-place.
#'
#'
#' **Version semantics:** Codebook versions are interpreted as `major.minor`
#' numeric pairs. Only increases trigger database actions; equal versions result
#' in no changes.
#'
#' @seealso [codebookToTable()], [FAIRgroundConnect()], [FAIRgroundConnection()]
#'
#' @examples
#' \dontrun{
#' FAIRgroundConnect("MY_DSN")
#' databasePrepareCodebooks()
#' }
#'
#' @export
databasePrepareCodebooks <- function(con=NULL) {
  lg <- lgr::get_logger("beFAIR")

  # check connection
  con <- FAIRgroundConnection(con)

  # Retrieve table_codebook from Database
  tableFromDB <- tryCatch({
    DBI::dbReadTable(con, "table_codebook")
  }, error = function(e) {
    lg$fatal("'table_codebook' does not exist or cannot be accessed",
             table_name = "table_codebook",
             error_message = conditionMessage(e),
             caller = "dbReadTable")
    stop(call. = FALSE)
  })
  lg$info("'table_codebook' retrieved from database with 'N' entries",
            table_name = "table_codebook",
            N = nrow(tableFromDB))

  # Build table_codebook from beFAIR package (and any custom codebooks)
  tableFromFP <- codebookToTable()

  # Loop & Sync
  lg$info("Matching current 'table_codebook' with the one build by beFAIR",
          table_name = 'table_codebook',
          entries_beFAIR = nrow(tableFromFP),
          entries_database = nrow(tableFromDB))
  for (i in seq_len(nrow(tableFromFP))) {
    cb <- tableFromFP[i, , drop = FALSE]
    cb_id <- cb$codebook_id
    cb_name <- sub(".*/", "", cb$codebook_id)

    # New codebook
    if (!cb_id %in% tableFromDB[, "codebook_id"]) {
      lg$info("New codebook detected",
              codebook_id = cb_id,
              codebook_name = cb_name)

      if (DBI::dbExistsTable(con, cb_name)) {
        lg$warn("Table already exists for new codebook - dropping before rebuild",
                codebook_id   = cb_id,
                codebook_name = cb_name)
        .sqlDropTable(con, cb_name)
      }
      .sqlGenerateTable(con, cb_name)
      .sqlPushTable(con, cb, "table_codebook")
    } else {
      # Existing codebook
      entryNr <- match(cb_id, tableFromDB[, "codebook_id"])

      ver_new_str <- as.character(cb$codebook_version)
      ver_old_str <- as.character(tableFromDB[entryNr, "codebook_version"])

      v_new <- as.numeric(unlist(strsplit(ver_new_str, "\\.")))
      v_old <- as.numeric(unlist(strsplit(ver_old_str, "\\.")))

      diff_major <- v_new[1] - v_old[1]
      diff_minor <- v_new[2] - v_old[2]

      if (diff_major > 0) {
        # MAJOR version change
        lg$warn("Major version change - recreating table",
                codebook_id = cb_id,
                codebook_name = cb_name,
                database_version = ver_old_str,
                codebook_version = ver_new_str)

        .sqlDropTable(con, cb_name)
        .sqlGenerateTable(con, cb_name)

        .sqlDeleteRows(con, "table_codebook", "codebook_id", cb_id)
        .sqlPushTable(con, cb, "table_codebook")

      } else if (diff_major == 0 & diff_minor > 0) {
        # MINOR version update
        lg$info("Minor version update",
                codebook_id = cb_id,
                codebook_name = cb_name,
                database_version = ver_old_str,
                codebook_version = ver_new_str)

        DBI::dbExecute(con,
                       "UPDATE table_codebook SET codebook_version=?, authors=?, updated_at=?, n_parameters=? WHERE codebook_id=?",
                       list(cb$codebook_version, cb$authors, cb$updated_at, cb$n_parameters, cb_id))
      }
    }
  }
}
