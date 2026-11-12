# Create a FAIRground folder

Initializes a FAIRground directory containing the standard folder
structure required for ETL development and database integration. The
following top-level directories are created:

- `studies/`

- `experiments/`

- `analyses/`

- `common/`

- `logs/`

- `codebooks/custom/`

## Usage

``` r
startProject(dir, dummy = FALSE)
```

## Arguments

- dir:

  Character. Path where the FAIRground should be created. The directory
  will be created if it does not already exist.

- dummy:

  Logical. If `TRUE`, the project is populated with example dummy data
  and scripts included in the package. Useful for vignettes,
  demonstrations, or learning the FAIRground. Default is `FALSE`.

## Value

Invisibly returns `NULL`. Called for its side effects on the file
system.

## Details

These directories are intended to contain ETL scripts (typically located
in `scripts/` subfolders) that extract raw data and load them into the
connected FAIRground database.

In addition, the function:

- Creates an RStudio project file (`.Rproj`)

- Generates a basic `.gitignore` file

Optionally, the project can be populated with a bundled dummy example
project to demonstrate the FAIRground.

Creates the FAIRground directory structure on disk and optionally copies
example files bundled with the package. To start drafting ETL scripts
and populating the FAIRground use
[`addStudy()`](https://koenastam.github.io/beFAIR/reference/addStudy.md),
[`addExperiment()`](https://koenastam.github.io/beFAIR/reference/addExperiment.md),
and
[`addAnalysis()`](https://koenastam.github.io/beFAIR/reference/addAnalysis.md)

The function does not initialize a database connection. After creating
the project structure, use
[`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
to connect to a database.

## See also

[`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md),
[`addStudy()`](https://koenastam.github.io/beFAIR/reference/addStudy.md),
[`addExperiment()`](https://koenastam.github.io/beFAIR/reference/addExperiment.md),
[`addAnalysis()`](https://koenastam.github.io/beFAIR/reference/addAnalysis.md)

## Examples

``` r
if (FALSE) { # \dontrun{
startProject(dir = "C:/Users/johndoe/Projects/LUCID_beFAIR")

# Setup a dummy project
dir <- paste0(tempdir(), "/dummy_beFAIR")
startProject(dir = dir, dummy=TRUE)

# Inspect the created beFAIR directory
cat(normalizePath(dir), "\n")
} # }
```
