# Adding an analysis

``` r

library(basictabler)
library(dplyr)
library(htmltools)
library(beFAIR)
library(yaml)
```

## 🚧 *Under construction* 🚧

## The Analysis Pillar

The **analysis** pillar is one of three data pillars in beFAIR. It
stores data that represents some form of interpretation applied to study
and/or experimental data — ranging from standard pre-processing
pipelines to elaborate cluster analyses. Examples include fitting an
ELISA dose-response curve, running a Self-Organizing Map (SOM)
clustering pipeline on CyTOF measurements, or applying a custom
statistical model.

Because analyses may draw on samples from multiple studies and on the
outputs of multiple experiments, they are linked to the rest of the
database via `experiment_id` and `study_id` references stored in their
`meta.yaml`.

All analyses live inside the FAIRground directory. beFAIR directly
sources each ETL script, which must produce a `databook` object and load
it into the database. Analyses can declare explicit dependencies on
upstream database tables (e.g. `cytofpanel` from a specific experiment)
via the `dependencies` field in `meta.yaml`; these are tracked in
`table_dependency` and used to flag when upstream data has changed.

    #> [1] "analyses"       "beFAIR.Rproj"   "codebooks"      "common"        
    #> [5] "experiments"    "fairground.yml" "logs"           "studies"

``` r

overviewFAIRground()
#> Warning in overviewFAIRground(): 'overviewFAIRground' is deprecated.
#> Use 'FAIRgroundOverview' instead.
#> See help("Deprecated")
#> 
#>  FAIRground Overview Summary
#> 
#> STUDIES: 0 rows × 0 columns
#>  (no data available)
#> 
#> EXPERIMENTS: 0 rows × 0 columns
#>  (no data available)
#> 
#> ANALYSES: 0 rows × 0 columns
#>  (no data available)
```

------------------------------------------------------------------------

## Internal delivery

An analysis is added with
[`addAnalysis()`](https://koenastam.github.io/beFAIR/reference/addAnalysis.md).
You must supply a unique name and a scientific type. We recommend
following the naming convention `[study]_[type]_[descriptor]`.

The supported analysis types are: `"SOM"`, `"OMIQ"`, `"ELISA"`,
`"Array"`, `"Luminex"`, and `"Glycoprofiling"`.

``` r

addAnalysis("CoHSI1_SOM_surface", "SOM")
#> Analysis added: CoHSI1_SOM_surface. Add the additional analysis information to the meta.yaml file located at: analyses/CoHSI1_SOM_surface/meta.yaml
#> 
```

### The analysis folder

A new folder is created under `analyses/` named after the analysis:

``` r

list.files("analyses/CoHSI1_SOM_surface")
#> [1] "data"      "meta.yaml" "scripts"
```

It contains three components:

- **`meta.yaml`**: metadata about the analysis, pre-filled from the base
  `analysis` codebook and the type-specific codebook (here
  `analysis_som`).
- **`data/`**: for storing data location descriptors (YAML files), same
  pattern as studies and experiments.
- **`scripts/`**: ETL R scripts drafted automatically for the chosen
  type.

### meta.yaml

The `meta.yaml` stores essential metadata about the analysis. beFAIR
pre-fills fields from the `analysis` codebook and any type-specific
extension (e.g. `analysis_som` adds `pipeline_location` and
`pipeline_description`). Fill in the missing values before running
[`databaseUpdate()`](https://koenastam.github.io/beFAIR/reference/databaseUpdate.md).

    #> analysis_id: Ac6be45
    #> name: CoHSI1_SOM_surface
    #> type: SOM
    #> study_ids: .na
    #> experiment_ids: .na
    #> analysis_ids: .na
    #> table_dependecies: .na
    #> publication_pmid: .na
    #> description: .na
    #> project_location: .na
    #> source_ready: .na
    #> git_repo: .na
    #> owner: .na
    #> version: '1.0'
    #> SOM_settings: .na

Key fields to complete:

| Field | Description |
|----|----|
| `study_ids` | Semicolon-separated IDs of studies whose samples were used |
| `experiment_ids` | Semicolon-separated IDs of source experiments |
| `description` | Free-text description of the analysis |
| `pipeline_location` | *(SOM only)* Path or URL to the SOM pipeline |

The `dependencies` field is initially empty. Fill it in to declare which
upstream database tables this analysis uses (e.g.
`- cytofpanel[Eef536a]`). beFAIR will track these in `table_dependency`
and flag the analysis as out-of-date when upstream data changes.

### ETL scripts

For a SOM analysis, two ETL scripts are drafted:

``` r

list.files("analyses/CoHSI1_SOM_surface/scripts")
#> [1] "som_clusterphenotype.R" "som_measurement.R"
```

- **`som_clusterphenotype.R`**: loads the cluster phenotype table (one
  row per SOM cluster, with marker expression profiles).
- **`som_measurement.R`**: loads per-sample SOM measurements (cluster
  frequencies or similar metrics).

Each script follows the standard beFAIR ETL pattern — it must produce a
`databook` object and end with
`rm(list = setdiff(ls(), c("databook")))`. See
[`?draftScript`](https://koenastam.github.io/beFAIR/reference/draftScript.md)
for details.
