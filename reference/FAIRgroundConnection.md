# Get the active FAIRground database connection

Returns the provided connection if valid, or falls back to the package
default connection stored by
[`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md).
Used internally by most beFAIR functions to resolve a `con = NULL`
argument.

## Usage

``` r
FAIRgroundConnection(con = NULL)
```

## Arguments

- con:

  A DBI connection. If `NULL`, the default connection set by
  [`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
  is used. If supplied, it must be a valid, open `DBIConnection` object.

## Value

A valid, open `DBIConnection` object. Throws an error if no valid
connection is available.

## See also

[`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md),
[`FAIRgroundDisconnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundDisconnect.md)

## Examples

``` r
if (FALSE) { # \dontrun{
FAIRgroundConnect("LUCID_FAIRPOINT")

## Resolve the default connection
con <- FAIRgroundConnection()

## Pass an explicit connection (validated and returned as-is)
con <- FAIRgroundConnection(con = my_con)
} # }
```
