.onLoad <- function(libname, pkgname) {
  reg.finalizer(
    .pkgenv,
    function(e) {
      if (!is.null(e$con) && DBI::dbIsValid(e$con)) {
        try(DBI::dbDisconnect(e$con), silent = TRUE)
      }
    },
    onexit = TRUE
  )
}

.onAttach <- function(libname, pkgname) {
  wd <- tryCatch(getwd(), error = function(e) NULL)
  if (is.null(wd)) return(invisible(NULL))
  ver <- utils::packageVersion("beFAIR")
  packageStartupMessage(sprintf("-- beFAIR %s --", ver))
  if (!.isFAIRground(wd)) {
    packageStartupMessage("  No FAIRground detected in the current working directory.")
    packageStartupMessage("  To connect to a database use FAIRgroundConnect().")
    packageStartupMessage("  See ?FAIRgroundConnect or ?startProject for more information.")
    return(invisible(NULL))
  }
  packageStartupMessage(sprintf("  FAIRground detected: %s", wd))

  cfg_path <- file.path(wd, "fairground.yml")
  if (file.exists(cfg_path)) {
    cfg <- tryCatch(yaml::read_yaml(cfg_path), error = function(e) NULL)
    conn <- if (!is.null(cfg)) cfg$connection else NULL

    if (!is.null(conn)) {
      backend <- tolower(if (!is.null(conn$backend)) conn$backend else "odbc")
      if (backend == "sqlite") {
        db_path <- if (!is.null(conn$path)) conn$path else conn$dsn
        packageStartupMessage(sprintf("  Database (SQLite): %s", db_path))
        packageStartupMessage(sprintf(
          "  Connect: FAIRgroundConnect(drv = RSQLite::SQLite(), dsn = \"%s\")", db_path
        ))
      } else {
        dsn <- if (!is.null(conn$dsn)) conn$dsn else ""
        packageStartupMessage(sprintf("  Database (ODBC/DSN): %s", dsn))
        packageStartupMessage(sprintf(
          "  Connect: FAIRgroundConnect(dsn = \"%s\")", dsn
        ))
      }
      return(invisible(NULL))
    }
  }

  # Fallback: scan for SQLite files in the project root
  sqlite_files <- list.files(
    wd, pattern = "\\.(sqlite|sqlite3|db)$",
    full.names = FALSE, recursive = FALSE
  )
  if (length(sqlite_files) > 0L) {
    packageStartupMessage(sprintf(
      "  SQLite file(s) found: %s", paste(sqlite_files, collapse = ", ")
    ))
    packageStartupMessage(sprintf(
      "  Connect: FAIRgroundConnect(drv = RSQLite::SQLite(), dsn = \"%s\")",
      sqlite_files[[1L]]
    ))
    packageStartupMessage(
      "  Tip: add fairground.yml to store and share connection settings."
    )
  } else {
    packageStartupMessage(
      "  No database configured. Use FAIRgroundConnect() to connect."
    )
    packageStartupMessage(
      "  Tip: add fairground.yml to configure and share connection settings."
    )
  }
}

# Returns TRUE when `path` contains the three structural FAIRground pillars.
.isFAIRground <- function(path) {
  all(dir.exists(file.path(path, c("studies", "experiments", "analyses"))))
}
