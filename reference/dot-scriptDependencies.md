# Detect database table dependencies in an ETL script

Reads an ETL script with `readLines` and statically scans for database
read calls. Returns one row per detected dependency.

## Usage

``` r
.scriptDependencies(script_id)
```

## Arguments

- script_id:

  Character. Path to the ETL script file.

## Value

A data frame with columns `table_name`, `ids`, `call_type`, and `line`.
Returns zero rows when no reads are detected. Only string-literal table
names can be resolved; names constructed via variables or
[`paste()`](https://rdrr.io/r/base/paste.html) appear as `"(dynamic)"`.

## Details

Detected patterns: `dbReadTable`, `dbGetQuery` (inline string and
`sprintf` variants), `collectTable`, and `validateSourceId` (always
resolves to `id_mapping`).

## See also

[`databasePrepareScripts()`](https://koenastam.github.io/beFAIR/reference/databasePrepareScripts.md),
[`collectTable()`](https://koenastam.github.io/beFAIR/reference/collectTable.md)
