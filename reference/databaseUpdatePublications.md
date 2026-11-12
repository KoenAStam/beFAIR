# Update the publications table in the database

Drops and recreates the `publications` table, then sources
`common/publications.R` (if it exists), validates the resulting
`databook`, and uploads the data to the database. If the file is absent
or validation fails, no data is written.

## Usage

``` r
databaseUpdatePublications(con = NULL)
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

[`databaseUpdate()`](https://koenastam.github.io/beFAIR/reference/databaseUpdate.md)

## Examples

``` r
if (FALSE) { # \dontrun{
FAIRgroundConnect("MY_DSN")
databaseUpdatePublications()
} # }
```
