# Load database tables into R (cache-first)

Cache-first wrapper around
[`databaseExport()`](https://koenastam.github.io/beFAIR/reference/databaseExport.md).
If an .rds cache file already exists at `path` and `overwrite = FALSE`,
the data is loaded from disk. Otherwise, the database is queried via
[`databaseExport()`](https://koenastam.github.io/beFAIR/reference/databaseExport.md)
and the result is saved to `path`.

## Usage

``` r
getDatabase(
  path,
  overwrite = FALSE,
  stripped = FALSE,
  replace_missing = TRUE,
  study_ids = NULL,
  remove_id_mapping = TRUE
)
```

## Arguments

- path:

  Character. Directory where the cached data (RDS file) should be stored
  or loaded from. Must be a directory, not an .rds file path.

- overwrite:

  Logical. If `TRUE`, forces a fresh read from the database and
  overwrites the cache. Default: `FALSE`.

- stripped:

  Logical. If `TRUE`, only non-sensitive tables are returned (e.g.,
  excluding participants). Default: `FALSE`.

- replace_missing:

  Logical. If `TRUE`, missing values will be replaced with `NA`.
  Default: `TRUE`.

- study_ids:

  Character vector or NULL. Study IDs to filter on.

## Value

A named list of data frames containing the database tables.

## See also

[`databaseExport()`](https://koenastam.github.io/beFAIR/reference/databaseExport.md)
to always fetch from the database.

## Examples

``` r
if (FALSE) { # \dontrun{
  # Load cached data or fetch from DB
  data <- getDatabase(path = "data/")

  # Force overwrite cache
  data <- getDatabase(path = "data/", overwrite = TRUE)

  # Load stripped dataset without sensitive info
  data <- getDatabase(path = "data/", stripped = TRUE)

  # Load data filtered to specific studies
  data <- getDatabase(path = "data/", study_ids = c("CHHIL", "ITCHI"))
} # }
```
