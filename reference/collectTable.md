# Collect data table from database, optionally filtered by script_id

This function retrieves all records from a specified database table. If
a valid database connection is not supplied, a new connection is
created. Optionally, the result can be filtered by a given `script_id`.

## Usage

``` r
collectTable(table_name, script_id = NULL, con = NULL)
```

## Arguments

- table_name:

  Character string specifying the name of the database table.

- script_id:

  Optional. If provided, only rows where `script_id` matches this value
  are returned.

- con:

  A DBI connection. If `NULL`, the default connection set by
  [`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
  is used.

## Value

A `data.frame` with all rows from `table_name` (or the subset matching
`script_id`). The `script_id` column is always removed from the output.

## Examples

``` r
if (FALSE) { # \dontrun{
df <- collectTable(table_name = "participant")
} # }
```
