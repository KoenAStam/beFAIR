# Export all database tables to R

Fetches all tables from the beFAIR SQL database and optionally saves the
result as an .rds file. Unlike
[`getDatabase()`](https://koenastam.github.io/beFAIR/reference/getDatabase.md),
this function always queries the database directly — it never reads from
a local cache.

## Usage

``` r
databaseExport(
  path = NULL,
  overwrite = FALSE,
  stripped = FALSE,
  replace_missing = TRUE,
  study_ids = NULL,
  remove_id_mapping = TRUE
)
```

## Arguments

- path:

  Character or NULL. Directory where the .rds file should be saved. If
  `NULL`, no file is written and the list is returned directly.

- overwrite:

  Logical. If `TRUE`, an existing .rds file at `path` is overwritten. If
  `FALSE` (default) and the file exists, saving is skipped with a
  warning.

- stripped:

  Logical. If `TRUE`, only non-sensitive tables are returned (study-,
  experiment-, and analysis-level tables, panel tables, event, and
  publications). Default: `FALSE`.

- replace_missing:

  Logical. If `TRUE`, values `-999`, `"N/A"`, and `"N/M"` are replaced
  with `NA`. Default: `TRUE`.

- study_ids:

  Character vector or NULL. If provided, only rows linked to these study
  IDs are retained via
  [`filterTableList()`](https://koenastam.github.io/beFAIR/reference/filterTableList.md).

## Value

A named list of data frames containing the database tables. If `path` is
provided, the list is also saved as an .rds file in that directory. The
filename depends on the parameters used:

- `table_list.rds` — default

- `table_list_stripped.rds` — when `stripped = TRUE`

- `table_list_filtered.rds` — when `study_ids` is provided

## See also

[`getDatabase()`](https://koenastam.github.io/beFAIR/reference/getDatabase.md)
for a cache-first wrapper around this function.

## Examples

``` r
if (FALSE) { # \dontrun{
  # Fetch from DB and return without saving
  data <- databaseExport()

  # Fetch from DB and save to disk
  data <- databaseExport(path = "data/")

  # Force overwrite an existing cache file
  data <- databaseExport(path = "data/", overwrite = TRUE)

  # Fetch stripped dataset for selected studies
  data <- databaseExport(path = "data/", stripped = TRUE, study_ids = c("CHHIL", "ITCHI"))
} # }
```
