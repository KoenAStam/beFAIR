# Disconnect the default FAIRground database connection

Closes the package default connection stored by
[`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
and clears it from the internal package environment.

## Usage

``` r
FAIRgroundDisconnect()
```

## Value

Called for its side effects. Invisibly returns `TRUE`.

## See also

[`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md),
[`FAIRgroundConnection()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnection.md)

## Examples

``` r
if (FALSE) { # \dontrun{
FAIRgroundConnect("LUCID_FAIRPOINT")
FAIRgroundDisconnect()
} # }
```
