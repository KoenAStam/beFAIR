# Remove rows from a table matching a script ID

Deletes all rows in the specified table where `script_id` matches the
given value. Used before re-sourcing an ETL script to clear its previous
output.

## Usage

``` r
.sqlRemoveEntries(con = NULL, table_name, script_id)
```

## Arguments

- con:

  A DBI connection. If `NULL`, the default connection set by
  [`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
  is used.

- table_name:

  Character. Name of the database table to remove rows from.

- script_id:

  Character. The script identifier whose rows should be deleted.

## Value

Invisibly returns `TRUE` on success (including when no rows matched),
`FALSE` on error.

## See also

[`databaseUpdate()`](https://koenastam.github.io/beFAIR/reference/databaseUpdate.md)
