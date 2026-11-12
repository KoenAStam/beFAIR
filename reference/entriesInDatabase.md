# Check whether at least one row for a script_id exists in a data table

Check whether at least one row for a script_id exists in a data table

## Usage

``` r
entriesInDatabase(cb_name, script_id, con = NULL)
```

## Arguments

- cb_name:

  Character. Table name to query, or `NA` when not applicable.

- script_id:

  Character. The `script_id` value to look up.

- con:

  A DBI connection. If `NULL`, the default connection set by
  [`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
  is used.

## Value

`1L` if at least one matching row exists, `0L` otherwise.
