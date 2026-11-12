# Add a study to the FAIRground

Creates a study directory structure under `studies/`, writes a
`meta.yaml`, copies a data template, and drafts the standard ETL scripts
for the `id_mapping`, `participant`, `studyarm`, and `studydesign`
codebooks. If a `registration_code` is provided, study metadata is
fetched from ClinicalTrials.gov and merged into the `meta.yaml`.

## Usage

``` r
addStudy(study_name, study_id, registration_code = NULL)
```

## Arguments

- study_name:

  A character string specifying the name of the study. Used as the
  directory name under `studies/`.

- study_id:

  A unique identifier for the study. Must be exactly 5 alphanumeric
  characters. Used as a prefix when generating `participant_id` values.

- registration_code:

  Optional. The ClinicalTrials.gov registration code (e.g.
  "NCT04269915"). If provided, additional study metadata is fetched from
  ClinicalTrials.gov and merged into `meta.yaml`.

## Value

Called for its side effects. Creates the study directory and
subdirectories (`scripts/`, `data/`), writes `meta.yaml`, copies a data
template, and drafts four ETL scripts. Prints a message on success.

## See also

[`addExperiment()`](https://koenastam.github.io/beFAIR/reference/addExperiment.md),
[`addAnalysis()`](https://koenastam.github.io/beFAIR/reference/addAnalysis.md),
[`draftScript()`](https://koenastam.github.io/beFAIR/reference/draftScript.md)

## Examples

``` r
if (FALSE) { # \dontrun{
addStudy("CoHSI1", "CHSI1", "NCT04269915")
addStudy("MyStudy", "MSTUDY")
} # }
```
