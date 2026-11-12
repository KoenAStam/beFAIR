# Connect to a FAIRground database

Creates (and stores) the package's *default* DBI connection in
`.pkgenv$con`. If a previous default connection exists and is still
valid, it is disconnected before opening a new one.

## Usage

``` r
FAIRgroundConnect(
  dsn = NULL,
  drv = NULL,
  driver = NULL,
  server = NULL,
  database = NULL,
  uid = NULL,
  pwd = NULL,
  trusted = TRUE,
  ...
)
```

## Arguments

- dsn:

  Character scalar. For ODBC, the ODBC Data Source Name (DSN). For
  SQLite (when `drv = RSQLite::SQLite()`), this is interpreted as the
  SQLite `dbname`, such as `":memory:"` or a file path.

- drv:

  A DBI driver object, e.g.
  [`odbc::odbc()`](https://odbc.r-dbi.org/reference/dbConnect-OdbcDriver-method.html)
  or
  [`RSQLite::SQLite()`](https://rsqlite.r-dbi.org/reference/SQLite.html).
  If `NULL`, defaults to
  [`odbc::odbc()`](https://odbc.r-dbi.org/reference/dbConnect-OdbcDriver-method.html).

- driver, server, database, uid, pwd:

  Optional fields for DSN-less ODBC connections. Ignored when `dsn` is
  supplied for ODBC. For SQLite, `database` can be used as the SQLite
  `dbname` when `dsn` is not provided.

- trusted:

  Logical. For DSN-less ODBC connections, whether to use Windows
  integrated authentication (`Trusted_Connection = "Yes"`). If `FALSE`,
  `uid` and `pwd` are used instead.

- ...:

  Additional arguments passed to
  [`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html).
  Useful for driver-specific options such as `Port`, `Timeout`, etc.

## Value

Invisibly returns a `DBIConnection` object and stores it as the package
default connection in `.pkgenv$con`.

## Details

The function supports two connection styles:

- **ODBC**: Use either a DSN (`dsn`) or DSN-less connection fields
  (`driver`, `server`, `database`, `uid`, `pwd`, `trusted`).

- **SQLite**: When `drv = RSQLite::SQLite()`, `dsn` (preferred) or
  `database` is treated as the SQLite `dbname` (e.g. `":memory:"` or a
  file path).

## Examples

``` r
if (FALSE) { # \dontrun{
## ODBC via DSN
FAIRgroundConnect(dsn = "LUCID_FAIRPOINT")

## the connection is also invisibly returned
con <- FAIRgroundConnect(dsn = "LUCID_FAIRPOINT")

## ODBC without DSN (DSN-less)
FAIRgroundConnect(
  driver   = "{ODBC Driver 18 for SQL Server}",
  server   = "localhost",
  database = "beFAIR",
  trusted  = TRUE
)

## SQLite
FAIRgroundConnect(drv = RSQLite::SQLite(), dsn = ":memory:") # in memory
FAIRgroundConnect(drv = RSQLite::SQLite(), dsn = "fairpoint.sqlite") # file-based

} # }
```
