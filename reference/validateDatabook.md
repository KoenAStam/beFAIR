# Validate a databook against its codebook rules

Applies the validation rules defined in the codebook to the
`databook$data` data frame using `pointblank`. Also checks that all
`source_id` values exist in the `id_mapping` table (unless the codebook
is `id_mapping` itself).

## Usage

``` r
validateDatabook(databook, print = TRUE, con = NULL)
```

## Arguments

- databook:

  A databook list as produced by
  [`codebookToEntries()`](https://koenastam.github.io/beFAIR/reference/codebookToEntries.md),
  containing `$data`, `$codebook`, and `$codebook_name`.

- print:

  Logical. If `TRUE` (default), prints the pointblank agent report to
  the console.

- con:

  A DBI connection. If `NULL`, the default connection set by
  [`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
  is used.

## Value

A list with two elements:

- `$status`: `1` if all validations passed, `0` if any failed.

- `$summary`: the interrogated pointblank agent object.

## See also

[`codebookToEntries()`](https://koenastam.github.io/beFAIR/reference/codebookToEntries.md)

## Examples

``` r
if (FALSE) { # \dontrun{
  databook <- codebookToEntries("participant", nrow = 0)
  result <- validateDatabook(databook, print = FALSE)
} # }
```
