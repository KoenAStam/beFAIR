# Delete rows from a table matching a single column value

Executes a parameterized `DELETE FROM <table> WHERE <col> = ?`.

## Usage

``` r
.sqlDeleteRows(con, table_name, where_col, where_val)
```

## Arguments

- con:

  A DBI connection.

- table_name:

  Character. Name of the table.

- where_col:

  Character. Column name used in the WHERE clause.

- where_val:

  The value to match.

- lg:

  An lgr logger object.

## Value

Invisibly, the number of rows deleted.
