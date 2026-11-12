# Get the description of a codebook

Get the description of a codebook

## Usage

``` r
getCodebookDescription(codebook_name)
```

## Arguments

- codebook_name:

  Character. Name of the codebook (e.g. `"event"`).

## Value

A character string with the codebook description, or `""` (empty string)
with a warning if the codebook is not found.

## See also

[`codebookRead()`](https://koenastam.github.io/beFAIR/reference/codebookRead.md),
[`codebookToSummary()`](https://koenastam.github.io/beFAIR/reference/codebookToSummary.md)

## Examples

``` r
if (FALSE) { # \dontrun{
  getCodebookDescription("event")
} # }
```
