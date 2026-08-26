#' Initialize FAIRground database
#'
#' Creates the core beFAIR tables in the connected database.
#' Specifically, this function generates the following tables based on
#' their registered codebooks:
#'
#' * `table_script`
#' * `table_codebook`
#' * `table_datasource`
#' * `table_dependency`
#' * `table_project`
#'
#' It also creates and populates built-in reference tables:
#'
#' * `HGNC` — HUGO Gene Nomenclature Committee gene symbols and CD annotations
#' * `LUNC` — LUCID internal nomenclature mapping FCS parameter descriptions to standard symbols
#'
#' Table definitions are derived from the internal codebook registry and
#' created using `.sqlGenerateTable()`.
#'
#' @details
#' **Reference tables** (`HGNC`, `LUNC`) are expected to be updated regularly
#' as nomenclature evolves. Set `overwrite_reference = TRUE` to drop and
#' recreate them and re-insert the built-in data.
#'
#' **Core registry tables** (`table_script`, `table_codebook`, `table_dependency`,
#' `table_project`) track ETL history and should only be recreated in exceptional
#' circumstances (e.g. a major schema upgrade). Set `overwrite_core = TRUE` to
#' do so; this will **destroy all existing run history**. Use with caution.
#'
#' **Full reset** (`drop_all = TRUE`) drops all beFAIR-managed tables before
#' creating the core tables. Only tables known to beFAIR are affected — core
#' registry tables, reference tables, and any data table registered in a
#' codebook (built-in or custom). Other tables in the database (e.g. from other
#' applications) are left untouched. Implies `overwrite_core = TRUE` and
#' `overwrite_reference = TRUE`.
#'
#' @param overwrite_reference Logical. If `TRUE`, existing reference tables
#'   (`HGNC`, `LUNC`) are dropped, recreated, and repopulated with the
#'   built-in data. Default is `TRUE`.
#' @param overwrite_core Logical. If `TRUE`, the core registry tables
#'   (`table_script`, `table_codebook`) are dropped and recreated. **All
#'   existing run history will be lost.** Default is `FALSE`.
#' @param drop_all Logical. If `TRUE`, all beFAIR-managed tables are dropped
#'   before initialization proceeds. Only tables known to beFAIR (core, reference,
#'   and codebook-derived data tables) are removed. Default is `FALSE`.
#' @param con A DBI connection. If `NULL`, the default connection set by
#'   [FAIRgroundConnect()] is used.
#'
#' @return Invisibly returns `NULL`.
#'
#' @examples
#' \dontrun{
#' library(beFAIR)
#' FAIRgroundConnect(drv = RSQLite::SQLite(), dsn = ":memory:")
#'
#' # First-time setup
#' databaseInitialize()
#'
#' # Refresh reference tables with updated nomenclature
#' databaseInitialize(overwrite_reference = TRUE)
#'
#' # Schema upgrade (destroys run history)
#' databaseInitialize(overwrite_core = TRUE)
#'
#' # Full reset: wipe everything and start from scratch
#' databaseInitialize(drop_all = TRUE)
#' }
#'
#' @export
databaseInitialize <- function(overwrite_reference=TRUE, overwrite_core=FALSE, drop_all=FALSE, con=NULL) {
  lg <- lgr::get_logger("beFAIR")
  con <- FAIRgroundConnection(con)

  if (drop_all) {
    core_tables <- c("table_script", "table_codebook", "table_datasource",
                     "table_dependency", "table_project", "HGNC", "LUNC")
    data_tables <- tryCatch(codebookToTable()$codebook_name, error = function(e) character(0))
    known_tables  <- unique(c(core_tables, data_tables))
    tables_to_drop <- intersect(DBI::dbListTables(con), known_tables)

    lg$warn("drop_all = TRUE: dropping all beFAIR-managed tables",
            n_tables = length(tables_to_drop),
            tables   = paste(tables_to_drop, collapse = ", "))
    for (tbl in tables_to_drop) {
      .sqlDropTable(con, tbl)
    }
    overwrite_core      <- TRUE
    overwrite_reference <- TRUE
  }

  initTable("table_script",    overwrite = overwrite_core,      con = con)
  initTable("table_codebook",  overwrite = overwrite_core,      con = con)
  initTable("table_datasource", overwrite = overwrite_core,     con = con)
  initTable("table_dependency", overwrite = overwrite_core,     con = con)
  initTable("table_project",   overwrite = overwrite_core,      con = con)
  initTable("HGNC", overwrite = overwrite_reference, data = beFAIR::HGNC, con = con)
  initTable("LUNC", overwrite = overwrite_reference, data = beFAIR::LUNC, con = con)

}





