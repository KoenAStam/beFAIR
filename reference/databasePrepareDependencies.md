# Prepare dependency registry for an ETL script

Scans a single ETL script for datasource references and source-id
assignments, then synchronises the results into `table_dependency`.

## Usage

``` r
databasePrepareDependencies(script_id, con = NULL)
```

## Arguments

- script_id:

  Character. Path to the ETL script relative to the FAIRground root
  (e.g. `"studies/CoHSI1/scripts/participant.R"`).

- con:

  A DBI connection. If `NULL`, the default connection set by
  [`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
  is used.

## Value

Invisibly `NULL`. Called for its side effects on `table_dependency`.

## Details

Two dependency types are recorded:

- **datasource**: the script contains the substring `data/<name>.yaml`
  anywhere in its text (bare literal or inside `sprintf`/`paste`), which
  is resolved to a `datasource_id` in `table_datasource`.

- **script**: the script contains the literal assignment
  `databook$data$source_id <-`, implying a dependency on `id_mapping.R`
  from the same study.

## See also

[`databasePrepareScripts()`](https://koenastam.github.io/beFAIR/reference/databasePrepareScripts.md),
[`databasePrepareDatasources()`](https://koenastam.github.io/beFAIR/reference/databasePrepareDatasources.md)

## Examples

``` r
if (FALSE) { # \dontrun{
FAIRgroundConnect("MY_DSN")
databasePrepareDependencies("studies/CoHSI1/scripts/participant.R")
} # }
```
