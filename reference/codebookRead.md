# Read a codebook by name

Searches `inst/codebooks/` for a YAML file whose base name matches
`codebook_name` (case-insensitive) and returns its parsed contents. If a
`codebooks/` folder exists in the current working directory, it is
searched as well. An error is raised if the same name is found in both
locations.

## Usage

``` r
codebookRead(codebook_name)
```

## Arguments

- codebook_name:

  Character. Name of the codebook without the `.yaml` extension (e.g.
  `"event"`, `"participant"`).

## Value

A named list containing the parsed codebook, or `NULL` with a warning if
no matching codebook is found.

## See also

[`codebookToSummary()`](https://koenastam.github.io/beFAIR/reference/codebookToSummary.md),
[`codebookToEntries()`](https://koenastam.github.io/beFAIR/reference/codebookToEntries.md)

## Examples

``` r
if (FALSE) { # \dontrun{
  codebookRead("event")
} # }
```
