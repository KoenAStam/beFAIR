# Update the FAIRground database

The main orchestrator for a full database update cycle. Sequentially:

1.  Synchronizes codebook definitions with the database via
    [`databasePrepareCodebooks()`](https://koenastam.github.io/beFAIR/reference/databasePrepareCodebooks.md).

2.  Discovers new, changed, or outdated ETL scripts via
    [`databasePrepareScripts()`](https://koenastam.github.io/beFAIR/reference/databasePrepareScripts.md).

3.  For each script that requires (re)running: clears its existing
    database entries, sources the script, validates the resulting
    `databook`, and uploads the data via
    [`databasePrepareData()`](https://koenastam.github.io/beFAIR/reference/databasePrepareData.md).

4.  Rebuilds the overview tables (`study`, `experiment`, `analysis`) and
    the `publications` table unconditionally.

## Usage

``` r
databaseUpdate(enable_logging = FALSE, con = NULL)
```

## Arguments

- enable_logging:

  Logical. If `TRUE`, JSON logs are written to
  `logs/files/<timestamp>.json` using the `lgr` package. Defaults to
  `FALSE`.

- con:

  A DBI connection. If `NULL`, the default connection set by
  [`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
  is used.

## Value

Called for its side effects. Invisibly returns `NULL`.

## Details

The connection is also closed on exit.

## See also

[`databaseInitialize()`](https://koenastam.github.io/beFAIR/reference/databaseInitialize.md),
[`databasePrepareCodebooks()`](https://koenastam.github.io/beFAIR/reference/databasePrepareCodebooks.md),
[`databasePrepareScripts()`](https://koenastam.github.io/beFAIR/reference/databasePrepareScripts.md),
[`databasePrepareData()`](https://koenastam.github.io/beFAIR/reference/databasePrepareData.md),
[`databaseUpdateOverview()`](https://koenastam.github.io/beFAIR/reference/databaseUpdateOverview.md),
[`databaseUpdatePublications()`](https://koenastam.github.io/beFAIR/reference/databaseUpdatePublications.md)

## Examples

``` r
if (FALSE) { # \dontrun{
FAIRgroundConnect("MY_DSN")
databaseUpdate()
databaseUpdate(enable_logging = TRUE)
} # }
```
