# Starting a project

A **FAIRground** is the combination of three things: a structured
directory on disk, a SQL database, and a set of R ETL scripts that move
data from raw files into the database. This guide shows how to create
each of them from scratch.

------------------------------------------------------------------------

## 1. Create the project directory

``` r

startProject(dir = dir)
list.files(dir)
#> [1] "analyses"             "beFAIR_project.Rproj" "codebooks"           
#> [4] "common"               "experiments"          "fairground.yml"      
#> [7] "logs"                 "studies"
```

[`startProject()`](https://koenastam.github.io/beFAIR/reference/startProject.md)
creates the standard FAIRground layout:

| Folder | Purpose |
|----|----|
| `studies/` | Clinical trial metadata — participants, arms, design |
| `experiments/` | Laboratory measurements (CyTOF, ELISA, Olink, …) |
| `analyses/` | Derived results computed from study and experiment data |
| `common/` | Shared reference files |
| `codebooks/` | Custom YAML codebooks for project-specific tables |
| `logs/` | JSON run logs written by [`databaseUpdate()`](https://koenastam.github.io/beFAIR/reference/databaseUpdate.md) |

------------------------------------------------------------------------

## 2. Connect and initialise the database

``` r

con <- FAIRgroundConnect(drv = RSQLite::SQLite(), dsn = ":memory:")
databaseInitialize()
DBI::dbListTables(con)
#> [1] "HGNC"             "LUNC"             "table_codebook"   "table_datasource"
#> [5] "table_dependency" "table_project"    "table_script"
```

[`databaseInitialize()`](https://koenastam.github.io/beFAIR/reference/databaseInitialize.md)
creates the registry tables that beFAIR uses to track codebook versions
(`table_codebook`) and ETL scripts (`table_script`). You only run this
once when setting up a new database.

> **In production** you would connect via a DSN:
> `FAIRgroundConnect("MY_DSN")`. On Windows, configure DSNs in the ODBC
> Data Sources administrator.

------------------------------------------------------------------------

## 3. Register a study

``` r

addStudy(study_name = "MyStudy", study_id = "MYST1")
list.files("studies/MyStudy")
#> [1] "data"      "meta.yaml" "scripts"
```

[`addStudy()`](https://koenastam.github.io/beFAIR/reference/addStudy.md)
creates a folder under `studies/` and drafts the four mandatory ETL
scripts:

``` r

list.files("studies/MyStudy/scripts")
#> [1] "id_mapping.R"  "participant.R" "studyarm.R"    "studydesign.R"
```

| Script | What it populates |
|----|----|
| `id_mapping.R` | Maps raw source IDs to pseudonymous `participant_id` values |
| `participant.R` | One row per participant — demographics, enrolment, BMI |
| `studyarm.R` | The study arms (control, treatment groups, dosing cohorts) |
| `studydesign.R` | Scheduled timepoints and events in the trial protocol |

Each script is a template: the codebook structure and boilerplate are
pre-filled, and you complete the data-mapping logic for your specific
raw files. See [Adding a
study](https://koenastam.github.io/beFAIR/articles/adding_a_study.md)
for a full walkthrough of each script.

------------------------------------------------------------------------

## 4. Fill in the study metadata

[`addStudy()`](https://koenastam.github.io/beFAIR/reference/addStudy.md)
also creates a `meta.yaml` file with fields you should complete:

    #> study_id: MYST1
    #> name: MyStudy
    #> title: ~
    #> study_organism: ~
    #> disease: ~
    #> pathogen: ~
    #> facilities: ~
    #> cities: ~
    #> countries: ~
    #> geopoints: ~
    #> principal_investigator: ~
    #> contact_name: ~
    #> contact_email: ~
    #> primary_outcome: ~
    #> summary: ~
    #> description: ~
    #> actual_start_date: ~
    #> actual_completion_date: ~
    #> actual_enrollment: ~
    #> registration_link: ~
    #> pbmc_location_file: ~
    #> pbmc_location_vials: ~
    #> pbmc_contact: ~

If the study is registered on ClinicalTrials.gov, pass the registration
code and beFAIR will pre-fill the relevant metadata automatically:

``` r

addStudy(study_name = "MyStudy", study_id = "MYST1",
         registration_code = "NCT02237586")
```

------------------------------------------------------------------------

## 5. Run the update

Once your ETL scripts are complete,
[`databaseUpdate()`](https://koenastam.github.io/beFAIR/reference/databaseUpdate.md)
runs them all, validates the output, and loads the results:

``` r

databaseUpdate()
```

You re-run this command whenever scripts change or new data arrives.
beFAIR detects which scripts have changed (via MD5 hash), skips anything
unchanged, and only reloads what is new or updated.

------------------------------------------------------------------------

## What’s next

| Guide | What you will learn |
|----|----|
| [Database smoke test](https://koenastam.github.io/beFAIR/articles/database_smoke_test.md) | Try the full pipeline in two minutes using the built-in dummy data |
| [Adding a study](https://koenastam.github.io/beFAIR/articles/adding_a_study.md) | Complete the four study ETL scripts step by step |
| [Adding an experiment](https://koenastam.github.io/beFAIR/articles/adding_an_experiment.md) | Register an experiment and write its ETL scripts |
| [Adding an analysis](https://koenastam.github.io/beFAIR/articles/adding_an_analysis.md) | Register an analysis and link it to upstream data |
| [Developer internals](https://koenastam.github.io/beFAIR/articles/developer_internals.md) | Understand what [`databaseUpdate()`](https://koenastam.github.io/beFAIR/reference/databaseUpdate.md) does under the hood |
