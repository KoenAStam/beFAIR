# Takes a vector of gate strings, splits them into components, harmonizes the marker names, and reconstructs the gate strings with standardized marker names using `harmonizeMarkers`.

Takes a vector of gate strings, splits them into components, harmonizes
the marker names, and reconstructs the gate strings with standardized
marker names using `harmonizeMarkers`.

## Usage

``` r
harmonizeGates(gates)
```

## Arguments

- gates:

  A character vector where each element is a gate string (e.g.,
  "HLA-DR\_+*OR_CD7*-").

## Value

A character vector of harmonized gate strings. Each output corresponds
to one input gate.

## Examples

``` r
harmonizeGates(c("HLA-DR_+_OR_CD7_-", "CD3_+", "CD16_-_AND_CD56_++"))
#> Matching HLA-DR
#> -> HGNC (symbol) 
#> -> Department 
#> -> HLA-DR
#> Matching CD3
#> -> HGNC (symbol) 
#> -> Department 
#> -> CD3
#> Matching CD16
#> -> HGNC (symbol) 
#> -> Department 
#> -> CD16
#> Matching CD7
#> -> CD7
#> Matching NA
#> -> HGNC (symbol) 
#> -> Department 
#> -> !No match!
#> Matching CD56
#> -> CD56
#> [1] "HLA-DR_+_OR_CD7_-"  "CD3_+"              "CD16_-_AND_CD56_++"
```
