# Source an ETL script and return its databook

Executes an ETL script in an isolated environment, captures warnings and
counts `#TODO` flags, and returns the `databook` object produced by the
script. Returns `NULL` if the script errors.

## Usage

``` r
sourceScript(script_id, echo = FALSE, con = NULL)
```

## Arguments

- script_id:

  Character. Relative path to the ETL script (used as the script
  identifier).

- echo:

  Logical. Passed to
  [`base::source()`](https://rdrr.io/r/base/source.html); whether each
  expression is printed as it is evaluated. Default: `FALSE`.

- con:

  A DBI connection. If `NULL`, the default connection set by
  [`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
  is used.

## Value

A `databook` list containing `$data`, `$codebook`, `$codebook_name`,
`$codebook_version`, `$validation`, `$run_time`, `$flag_TODO`, and
`$flag_WARN`. Returns `NULL` if the script fails.

## See also

[`databaseUpdate()`](https://koenastam.github.io/beFAIR/reference/databaseUpdate.md),
[`databasePrepareScripts()`](https://koenastam.github.io/beFAIR/reference/databasePrepareScripts.md)

## Examples

``` r
if (FALSE) { # \dontrun{
  databook <- sourceScript("studies/CHHIL/scripts/participant.R")
} # }
```
