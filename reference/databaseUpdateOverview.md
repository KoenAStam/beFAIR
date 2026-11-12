# Update the overview tables in the database

Rebuilds the `study`, `experiment`, and `analysis` overview tables in
the database from the current FAIRground directory. Each table is
dropped and recreated before the data is pushed, so the database always
reflects the current state of the `meta.yaml` files on disk.

## Usage

``` r
databaseUpdateOverview(con = NULL)
```

## Arguments

- con:

  A DBI connection. If `NULL`, the default connection set by
  [`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
  is used.

## Value

Called for its side effects. Invisibly returns `NULL`.

## Details

Called automatically at the end of
[`databaseUpdate()`](https://koenastam.github.io/beFAIR/reference/databaseUpdate.md).

## See also

[`databaseUpdate()`](https://koenastam.github.io/beFAIR/reference/databaseUpdate.md),
[`FAIRgroundOverview()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundOverview.md)

## Examples

``` r
if (FALSE) { # \dontrun{
FAIRgroundConnect("MY_DSN")
databaseUpdateOverview()
} # }
```
