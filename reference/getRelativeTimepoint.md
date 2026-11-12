# Convert timepoint descriptions to relative timepoints in days

Resolves textual timepoint descriptions (e.g. `"C1"`, `"I2+14"`) to
numeric timepoints in days relative to the anchor day, by joining
against the `id_mapping`, `participant`, and `studydesign` database
tables. Timepoint descriptions must follow the pattern
`<C|I><number>[+/-offset]`, for example `"C1"`, `"C-7"`, `"I_LAST+14"`,
or `"I3+14"`. Invalid descriptions produce a warning and result in `NA`
for the corresponding rows.

## Usage

``` r
getRelativeTimepoint(
  study_id,
  source_id,
  timepoint_description,
  verbose = FALSE,
  con = NULL
)
```

## Arguments

- study_id:

  A character vector of study identifiers, one per row of input.

- source_id:

  A character vector of original participant identifiers (source IDs),
  one per row of input.

- timepoint_description:

  A character vector of timepoint descriptions as used in the study
  design (e.g. `"C1"`, `"I2+14"`, `"I_LAST+14"`, `"C-7"`).

- verbose:

  Logical. If `TRUE`, messages the study design timeline with the
  resolved time points. Defaults to `FALSE`.

- con:

  A DBI connection. If `NULL`, the default connection set by
  [`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
  is used.

## Value

A data frame with columns `study_id`, `source_id`,
`timepoint_description`, and `timepoint` (integer, days relative to the
anchor day). Rows where the description could not be resolved have `NA`
in `timepoint`.

## See also

[`codebookToSummary()`](https://koenastam.github.io/beFAIR/reference/codebookToSummary.md)

## Examples

``` r
if (FALSE) { # \dontrun{
FAIRgroundConnect("LUCID_FAIRPOINT")
getRelativeTimepoint(
  study_id             = c("CoHSI1", "PfGA1"),
  source_id            = c("CS1-229", "BMV_021"),
  timepoint_description = c("C-1", "I1+14")
)
} # }
```
