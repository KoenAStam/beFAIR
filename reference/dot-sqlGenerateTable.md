# Generate a SQL table from a codebook schema

Creates a new table in the database whose columns and SQL types are
derived from the specified codebook. `DECIMAL` fields are created as
`DECIMAL(38, 18)`.

## Usage

``` r
.sqlGenerateTable(con = NULL, table_name)
```

## Arguments

- con:

  A DBI connection. If `NULL`, the default connection set by
  [`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
  is used.

- table_name:

  Character. Name of the codebook (and resulting table).

## Value

Invisibly returns `NULL`. Logs success or failure via the beFAIR logger.

## See also

[`databasePrepareCodebooks()`](https://koenastam.github.io/beFAIR/reference/databasePrepareCodebooks.md)
