.pkgenv <- new.env(parent = emptyenv())

#' Connect to a FAIRground database
#'
#' Creates (and stores) the package's *default* DBI connection in `.pkgenv$con`.
#' If a previous default connection exists and is still valid, it is disconnected
#' before opening a new one.
#'
#' @details
#'
#' The function supports two connection styles:
#'
#' * **ODBC**: Use either a DSN (`dsn`) or DSN-less connection fields
#'   (`driver`, `server`, `database`, `uid`, `pwd`, `trusted`).
#' * **SQLite**: When `drv = RSQLite::SQLite()`, `dsn` (preferred) or
#'   `database` is treated as the SQLite `dbname` (e.g. `":memory:"`
#'   or a file path).
#'
#' @param dsn Character scalar. For ODBC, the ODBC Data Source Name (DSN).
#'   For SQLite (when `drv = RSQLite::SQLite()`), this is interpreted as the
#'   SQLite `dbname`, such as `":memory:"` or a file path.
#'
#' @param drv A DBI driver object, e.g. `odbc::odbc()` or `RSQLite::SQLite()`.
#'   If `NULL`, defaults to `odbc::odbc()`.
#'
#' @param driver,server,database,uid,pwd Optional fields for DSN-less ODBC
#'   connections. Ignored when `dsn` is supplied for ODBC.
#'   For SQLite, `database` can be used as the SQLite `dbname`
#'   when `dsn` is not provided.
#'
#' @param trusted Logical. For DSN-less ODBC connections, whether to use
#'   Windows integrated authentication (`Trusted_Connection = "Yes"`).
#'   If `FALSE`, `uid` and `pwd` are used instead.
#'
#' @param ... Additional arguments passed to
#'   [DBI::dbConnect()]. Useful for driver-specific options such as
#'   `Port`, `Timeout`, etc.
#'
#' @return Invisibly returns a `DBIConnection` object and stores it
#'   as the package default connection in `.pkgenv$con`.
#'
#' @examples
#' \dontrun{
#' ## ODBC via DSN
#' FAIRgroundConnect(dsn = "LUCID_FAIRPOINT")
#'
#' ## the connection is also invisibly returned
#' con <- FAIRgroundConnect(dsn = "LUCID_FAIRPOINT")
#'
#' ## ODBC without DSN (DSN-less)
#' FAIRgroundConnect(
#'   driver   = "{ODBC Driver 18 for SQL Server}",
#'   server   = "localhost",
#'   database = "beFAIR",
#'   trusted  = TRUE
#' )
#'
#' ## SQLite
#' FAIRgroundConnect(drv = RSQLite::SQLite(), dsn = ":memory:") # in memory
#' FAIRgroundConnect(drv = RSQLite::SQLite(), dsn = "fairpoint.sqlite") # file-based
#'
#' }
#'
#' @export
FAIRgroundConnect <- function(dsn = NULL,
                             drv = NULL,
                             driver = NULL, server = NULL,
                             database = NULL, uid = NULL, pwd = NULL,
                             trusted = TRUE, ...) {

  # Close existing default connection if present/valid
  if (!is.null(.pkgenv$con) && DBI::dbIsValid(.pkgenv$con)) {
    DBI::dbDisconnect(.pkgenv$con)
  }

  # Default driver to ODBC if not supplied
  if (is.null(drv)) drv <- odbc::odbc()

  # Helper to detect SQLite driver
  is_sqlite <- function(x) inherits(x, "SQLiteDriver") || inherits(x, "SQLite")

  con <- if (is_sqlite(drv)) {
    # SQLite: interpret `dsn` as dbname, otherwise use `database` as dbname
    dbname <- if (!is.null(dsn) && nzchar(dsn)) dsn else database
    if (is.null(dbname) || !nzchar(dbname)) {
      stop("For SQLite, provide `dsn` (e.g. ':memory:' or a file path) or `database` as the SQLite dbname.")
    }
    DBI::dbConnect(drv, dbname = dbname, ...)
  } else {
    # ODBC: DSN-based if provided, otherwise DSN-less connection args
    if (!is.null(dsn) && nzchar(dsn)) {
      DBI::dbConnect(drv, dsn = dsn, ...)
    } else {
      args <- list(
        drv      = drv,
        Driver   = driver,
        Server   = server,
        Database = database
      )

      if (isTRUE(trusted)) {
        args$Trusted_Connection <- "Yes"
      } else {
        args$UID <- uid
        args$PWD <- pwd
      }

      args <- c(args, list(...))
      do.call(DBI::dbConnect, args)
    }
  }

  .pkgenv$con <- con
  invisible(con)
}

#' Get the active FAIRground database connection
#'
#' Returns the provided connection if valid, or falls back to the package
#' default connection stored by [FAIRgroundConnect()]. Used internally by most
#' beFAIR functions to resolve a `con = NULL` argument.
#'
#' @param con A DBI connection. If `NULL`, the default connection set by [FAIRgroundConnect()] is used. If supplied, it must be a valid, open
#'   `DBIConnection` object.
#'
#' @return A valid, open `DBIConnection` object. Throws an error if no valid
#'   connection is available.
#'
#' @seealso [FAIRgroundConnect()], [FAIRgroundDisconnect()]
#'
#' @examples
#' \dontrun{
#' FAIRgroundConnect("LUCID_FAIRPOINT")
#'
#' ## Resolve the default connection
#' con <- FAIRgroundConnection()
#'
#' ## Pass an explicit connection (validated and returned as-is)
#' con <- FAIRgroundConnection(con = my_con)
#' }
#' @export
FAIRgroundConnection <- function(con = NULL) {
  if (!is.null(con)) {
    if (!inherits(con, "DBIConnection")) {
      stop("`con` must be a DBIConnection.")
    }
    if (!DBI::dbIsValid(con)) stop("`con` is not a valid (open) DB connection.")
    return(con)
  }

  if (is.null(.pkgenv$con) || !DBI::dbIsValid(.pkgenv$con)) {
    stop(
      c(
        "No database connection is set.",
        i = "Call `FAIRgroundConnect(dsn = \"...\")` first, or pass `con =` to this function."
      )
    )
  }

  .pkgenv$con
}

#' Disconnect the default FAIRground database connection
#'
#' Closes the package default connection stored by [FAIRgroundConnect()] and
#' clears it from the internal package environment.
#'
#' @return Called for its side effects. Invisibly returns `TRUE`.
#'
#' @seealso [FAIRgroundConnect()], [FAIRgroundConnection()]
#'
#' @examples
#' \dontrun{
#' FAIRgroundConnect("LUCID_FAIRPOINT")
#' FAIRgroundDisconnect()
#' }
#' @export
FAIRgroundDisconnect <- function() {
  if (!is.null(.pkgenv$con) && DBI::dbIsValid(.pkgenv$con)) {
    DBI::dbDisconnect(.pkgenv$con)
  }
  .pkgenv$con <- NULL
  invisible(TRUE)
}
