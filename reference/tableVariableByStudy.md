# Summarise a codebook variable by study as a `gt` table

Reads the named codebook to determine the variable type and produces a
colour-coded `gt` table summarising the variable grouped by `study_id`.
For `character` variables, the set of unique values and completeness are
reported. For `numeric` variables, mean, SD, median, min, max and
completeness are shown.

## Usage

``` r
tableVariableByStudy(var, data, codebook_name)
```

## Arguments

- var:

  A character string specifying the variable to summarise. Must be
  defined in `codebook_name`.

- data:

  A data frame containing the data to summarise. Must include a
  `study_id` column and the variable specified by `var`.

- codebook_name:

  A character string specifying the codebook name (without `.yaml`
  extension).

## Value

A `gt` table object with rows per `study_id`. Completeness is
colour-coded on a red-yellow-green scale. Returns a placeholder `gt`
table for unsupported variable types.

## See also

[`codebookToSummary()`](https://koenastam.github.io/beFAIR/reference/codebookToSummary.md),
[`codebookRead()`](https://koenastam.github.io/beFAIR/reference/codebookRead.md),
[`tableSummary()`](https://koenastam.github.io/beFAIR/reference/tableSummary.md)

## Examples

``` r
if (FALSE) { # \dontrun{
FAIRgroundConnect("LUCID_FAIRPOINT")
data <- DBI::dbReadTable(FAIRgroundConnection(), "participant")
tableVariableByStudy("sex", data, "participant")
} # }
```
