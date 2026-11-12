# Create an empty databook from a codebook

Reads the named codebook YAML, creates an empty data frame with the
correct R column types, and returns both bundled into a `databook`
object. The `databook` is the standard container that ETL scripts
populate and that
[`databasePrepareData()`](https://koenastam.github.io/beFAIR/reference/databasePrepareData.md)
consumes.

## Usage

``` r
codebookToEntries(codebook_name, nrow = 0)
```

## Arguments

- codebook_name:

  A character string specifying the codebook name (without `.yaml`
  extension), e.g. `"participant"` or `"cytofpanel"`.

- nrow:

  An integer specifying the number of rows to initialise in the data
  frame. Defaults to `0`.

## Value

A named list with the following elements:

- `codebook`: The variables map read from the codebook YAML.

- `codebook_name`: The codebook name as supplied in `codebook_name`.

- `codebook_version`: The codebook version string (e.g. `"2.1"`).

- `data`: A data frame with columns matching the codebook variables and
  R types derived from the codebook `type` field (`character`,
  `numeric`, `integer`, or `Date`).

- `validation`: A list with `status = 0` and `summary = NULL`, to be
  populated by
  [`validateDatabook()`](https://koenastam.github.io/beFAIR/reference/validateDatabook.md).

## See also

[`codebookRead()`](https://koenastam.github.io/beFAIR/reference/codebookRead.md),
[`validateDatabook()`](https://koenastam.github.io/beFAIR/reference/validateDatabook.md),
[`databasePrepareData()`](https://koenastam.github.io/beFAIR/reference/databasePrepareData.md),
[`codebookToSummary()`](https://koenastam.github.io/beFAIR/reference/codebookToSummary.md),
[`addStudy()`](https://koenastam.github.io/beFAIR/reference/addStudy.md),
[`addExperiment()`](https://koenastam.github.io/beFAIR/reference/addExperiment.md),
[`addAnalysis()`](https://koenastam.github.io/beFAIR/reference/addAnalysis.md)

## Examples

``` r
if (FALSE) { # \dontrun{
databook <- codebookToEntries("participant", nrow = 50)

codebookToSummary("cytofpanel")
databook <- codebookToEntries("cytofpanel")
} # }
```
