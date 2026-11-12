# Prepare ETL scripts prior to updating the database

Scans the FAIRground directories for ETL scripts (files located in a
`scripts/` subfolder under `studies/`, `experiments/`, and `analyses/`),
computes an MD5 hash for each script, and maintains `table_script` as
the authoritative status table.

## Usage

``` r
databasePrepareScripts(con = NULL)
```

## Arguments

- con:

  A DBI connection. If `NULL`, the default connection set by
  [`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
  is used.

## Value

A data frame with one row per ETL script queued for (re)running
(`queued_for_update == 1 & suspended == 0`), with all `table_script`
columns. Rows are ordered by category (`studies`, `experiments`,
`analyses`) and a predefined study dependency order.

## Details

The function identifies and tracks:

- **New scripts** not yet present in `table_script` — inserted with
  `queued_for_update = 1`.

- **Changed scripts** whose content hash differs from the database —
  `queued_for_update` set to 1.

- **Outdated scripts** whose `codebook_version` lags behind
  `table_codebook` — `queued_for_update` set to 1.

- **Suspended scripts** whose filename starts with `_` — recorded in
  `table_script` with `suspended = 1` and skipped.

**Database effects:** This function may INSERT or UPDATE rows in
`table_script`. New internal scripts are only inserted when the inferred
`codebook_name` exists in `table_codebook`; otherwise the script is
skipped and an error is logged.

**Suspended scripts:** ETL scripts with a leading underscore in the
filename are treated as suspended. Their `live_id` (path with `_`
removed) is recorded in `table_script` with `suspended = 1` and
`queued_for_update = 0`.

## See also

[`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md),
[`databaseUpdate()`](https://koenastam.github.io/beFAIR/reference/databaseUpdate.md),
[`databasePrepareCodebooks()`](https://koenastam.github.io/beFAIR/reference/databasePrepareCodebooks.md)

## Examples

``` r
if (FALSE) { # \dontrun{
FAIRgroundConnect("MY_DSN")
scriptsToUpdate <- databasePrepareScripts()
} # }
```
