# Append a data frame to a SQL table

Appends all rows of `data` to an existing table in the database using
[`DBI::dbWriteTable`](https://dbi.r-dbi.org/reference/dbWriteTable.html)
with `append = TRUE`.

## Usage

``` r
.sqlPushTable(con = NULL, data, table_name, script_id = NA)
```

## Arguments

- con:

  A DBI connection. If `NULL`, the default connection set by
  [`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
  is used.

- data:

  Data frame to append.

- table_name:

  Character. Name of the target database table.

- script_id:

  Character. The script identifier associated with these rows; used for
  logging only. Default: `NA`.

## Value

Invisibly returns `TRUE` on success, `FALSE` on error.

## See also

[`databasePrepareData()`](https://koenastam.github.io/beFAIR/reference/databasePrepareData.md)
