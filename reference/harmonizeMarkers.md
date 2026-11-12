# Harmonize cellular marker labels

Maps raw marker labels (e.g. from FCS files) to standardised symbols
using a three-step lookup cascade:

## Usage

``` r
harmonizeMarkers(markers)
```

## Arguments

- markers:

  A character vector of marker labels to harmonize (e.g.
  `c("CD3-FITC", "IL-5", "HLA-DR")`).

## Value

A character vector of the same length as `markers`. Each element is the
standardised symbol, or `""` when no match was found in any lookup.

## Details

1.  **HGNC CD column**
    ([HGNC](https://koenastam.github.io/beFAIR/reference/HGNC.md)):
    exact match against CD annotations from the Human Cell
    Differentiation Molecule (HCDM) database. When no exact match is
    found, a CD pattern (e.g. `"CD8"` from `"CD8-APC"`) is extracted and
    looked up instead. Markers containing `";"` are skipped in this step
    as they likely represent double-stained channels.

2.  **HGNC gene symbol**
    ([HGNC](https://koenastam.github.io/beFAIR/reference/HGNC.md)):
    case-insensitive match against approved HGNC gene symbols. If the
    initial match fails, special characters are stripped and the lookup
    is retried (e.g. `"IL-5"` → `"IL5"`). `"B2M"` is handled as a
    special case (common barcoding marker). When a match is found, the
    CD annotation is returned if one exists; otherwise the HGNC symbol
    is returned.

3.  **LUNC department lookup**
    ([LUNC](https://koenastam.github.io/beFAIR/reference/LUNC.md)):
    case-insensitive match against the internal FCS parameter
    description table used at LUMC.

If no match is found in any step, an empty string (`""`) is returned for
that element and a message is printed to the console.

## See also

[HGNC](https://koenastam.github.io/beFAIR/reference/HGNC.md),
[LUNC](https://koenastam.github.io/beFAIR/reference/LUNC.md),
[`harmonizeGates()`](https://koenastam.github.io/beFAIR/reference/harmonizeGates.md)

## Examples

``` r
if (FALSE) { # \dontrun{
harmonizeMarkers(c("CD3-FITC", "IL-5", "HLA-DR", "FSC-A"))
} # }
```
