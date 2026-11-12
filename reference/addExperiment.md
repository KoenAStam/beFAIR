# Add an experiment to the FAIRground

Creates an experiment directory structure under `experiments/`, writes a
`meta.yaml` initialised from the base `experiment` codebook and a
type-specific codebook, copies a data template, and drafts the standard
ETL scripts for the selected experiment type.

## Usage

``` r
addExperiment(
  experiment_name,
  experiment_type = c("CyTOF", "Array", "Luminex", "ELISA", "Aurora", "Olink", "UPLC",
    "LCMS")
)
```

## Arguments

- experiment_name:

  A character string specifying the name of the experiment. Typically
  composed of the study name, experiment type, and a descriptor,
  separated by underscores (e.g. `"CoHSI1_CyTOF_surface"`).

- experiment_type:

  A character string specifying the type of the experiment. Must be one
  of `"CyTOF"`, `"Array"`, `"Luminex"`, `"ELISA"`, `"Aurora"`,
  `"Olink"`, `"UPLC"`, or `"LCMS"`.

## Value

Called for its side effects. Creates the experiment directory and
subdirectories (`scripts/`, `data/`), writes `meta.yaml`, copies a data
template, and drafts scripts. Prints a message on success. Invisibly
returns `NULL`.

## See also

[`addStudy()`](https://koenastam.github.io/beFAIR/reference/addStudy.md),
[`addAnalysis()`](https://koenastam.github.io/beFAIR/reference/addAnalysis.md),
[`draftScript()`](https://koenastam.github.io/beFAIR/reference/draftScript.md)

## Examples

``` r
if (FALSE) { # \dontrun{
addExperiment("CoHSI1_CyTOF_exvivo", "CyTOF")
addExperiment("ReCHHI1_ELISA_IgE", "ELISA")
} # }
```
