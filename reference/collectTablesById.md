# Collect all database tables linked to a study, experiment, or analysis ID

Queries the database for all tables that contain a column matching the
type of the supplied ID (`study_id`, `experiment_id`, or `analysis_id`).
The ID type is inferred automatically from the ID format. When
`recursive = TRUE`, the function chains upward through the data
hierarchy: an `analysis_id` triggers a follow-up lookup of its linked
experiments, which in turn trigger a lookup of their linked studies.

## Usage

``` r
collectTablesById(id, recursive = TRUE, namesOnly = FALSE, con = NULL)
```

## Arguments

- id:

  A character string specifying the ID to search for. The type
  (`study_id`, `experiment_id`, or `analysis_id`) is inferred from the
  format of the value.

- recursive:

  Logical. If `TRUE` (default), the function follows relational links
  upward: analysis → linked experiments → linked studies. If `FALSE`,
  only tables directly containing the supplied ID column are queried.

- namesOnly:

  Logical. If `TRUE`, returns only a character vector of table names
  that contain at least one row matching the ID, without fetching the
  actual data. Default is `FALSE`.

- con:

  A DBI connection. If `NULL`, the default connection set by
  [`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
  is used.

## Value

When `namesOnly = FALSE` (default): a named list of data frames, one per
matching table, with each data frame filtered to rows where the ID
column equals `id`. Empty tables are excluded. When `namesOnly = TRUE`:
a character vector of table names that contain matching rows.

## Details

The ID type is determined by pattern matching:

- IDs matching `^A[0-9a-f]{6}$` are treated as `analysis_id`

- IDs matching `^E[0-9a-f]{6}$` are treated as `experiment_id`

- All other IDs are treated as `study_id`

Table discovery uses `INFORMATION_SCHEMA.COLUMNS`, so this function
requires a SQL Server (ODBC) connection and is not compatible with
SQLite.

## See also

[`getDatabase()`](https://koenastam.github.io/beFAIR/reference/getDatabase.md),
[`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md),
[`searchId()`](https://koenastam.github.io/beFAIR/reference/searchId.md)

## Examples

``` r
if (FALSE) { # \dontrun{
FAIRgroundConnect("LUCID_FAIRPOINT")

# Retrieve all data linked to a study
collectTablesById(id = "HYPOV")

# Only return table names (no data fetched)
collectTablesById(id = "Ec0a1f3", namesOnly = TRUE)

# Retrieve analysis data without chaining to experiments/studies
collectTablesById(id = "A1b6b7f", recursive = FALSE)
} # }
```
