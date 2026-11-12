# Add an analysis to the FAIRground

Creates an analysis directory structure under `analyses/`, writes a
`meta.yaml` initialised from the base `analysis` codebook and a
type-specific codebook, copies a data template, and drafts the standard
ETL scripts for the selected analysis type.

## Usage

``` r
addAnalysis(analysis_name, analysis_type)
```

## Arguments

- analysis_name:

  A character string specifying the name of the analysis. Typically
  composed of the study name, analysis type, and a descriptor, separated
  by underscores (e.g. `"CoHSI1_SOM_surface"`).

- analysis_type:

  A character string specifying the scientific type of the analysis.
  Must be one of `"SOM"`, `"OMIQ"`, `"ELISA"`, `"Array"`, `"Luminex"`,
  `"Glycoprofiling"`, or `"Custom"` if only custom codebooks are used.

## Value

Called for its side effects. Creates the analysis directory and
subdirectories (`scripts/`, `data/`), writes `meta.yaml`, copies a data
template, and drafts scripts.

## See also

[`addStudy()`](https://koenastam.github.io/beFAIR/reference/addStudy.md),
[`addExperiment()`](https://koenastam.github.io/beFAIR/reference/addExperiment.md),
[`draftScript()`](https://koenastam.github.io/beFAIR/reference/draftScript.md)

## Examples

``` r
if (FALSE) { # \dontrun{
addAnalysis("CHHIL_CyTOF_SOM_exvivo", "SOM")
addAnalysis("ReCHHI1_ELISA_IgE", "ELISA")
} # }
```
