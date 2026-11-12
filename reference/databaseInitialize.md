# Initialize FAIRground database

Creates the core beFAIR tables in the connected database. Specifically,
this function generates the following tables based on their registered
codebooks:

## Usage

``` r
databaseInitialize(
  overwrite_reference = TRUE,
  overwrite_core = FALSE,
  drop_all = FALSE,
  con = NULL
)
```

## Arguments

- overwrite_reference:

  Logical. If `TRUE`, existing reference tables (`HGNC`, `LUNC`) are
  dropped, recreated, and repopulated with the built-in data. Default is
  `TRUE`.

- overwrite_core:

  Logical. If `TRUE`, the core registry tables (`table_script`,
  `table_codebook`) are dropped and recreated. **All existing run
  history will be lost.** Default is `FALSE`.

- drop_all:

  Logical. If `TRUE`, all beFAIR-managed tables are dropped before
  initialization proceeds. Only tables known to beFAIR (core, reference,
  and codebook-derived data tables) are removed. Default is `FALSE`.

- con:

  A DBI connection. If `NULL`, the default connection set by
  [`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
  is used.

## Value

Invisibly returns `NULL`.

## Details

- `table_script`

- `table_codebook`

- `table_datasource`

- `table_dependency`

- `table_project`

It also creates and populates built-in reference tables:

- `HGNC` — HUGO Gene Nomenclature Committee gene symbols and CD
  annotations

- `LUNC` — LUCID internal nomenclature mapping FCS parameter
  descriptions to standard symbols

Table definitions are derived from the internal codebook registry and
created using
[`.sqlGenerateTable()`](https://koenastam.github.io/beFAIR/reference/dot-sqlGenerateTable.md).

**Reference tables** (`HGNC`, `LUNC`) are expected to be updated
regularly as nomenclature evolves. Set `overwrite_reference = TRUE` to
drop and recreate them and re-insert the built-in data.

**Core registry tables** (`table_script`, `table_codebook`,
`table_dependency`, `table_project`) track ETL history and should only
be recreated in exceptional circumstances (e.g. a major schema upgrade).
Set `overwrite_core = TRUE` to do so; this will **destroy all existing
run history**. Use with caution.

**Full reset** (`drop_all = TRUE`) drops all beFAIR-managed tables
before creating the core tables. Only tables known to beFAIR are
affected — core registry tables, reference tables, and any data table
registered in a codebook (built-in or custom). Other tables in the
database (e.g. from other applications) are left untouched. Implies
`overwrite_core = TRUE` and `overwrite_reference = TRUE`.

## Examples

``` r
if (FALSE) { # \dontrun{
library(beFAIR)
FAIRgroundConnect(drv = RSQLite::SQLite(), dsn = ":memory:")

# First-time setup
databaseInitialize()

# Refresh reference tables with updated nomenclature
databaseInitialize(overwrite_reference = TRUE)

# Schema upgrade (destroys run history)
databaseInitialize(overwrite_core = TRUE)

# Full reset: wipe everything and start from scratch
databaseInitialize(drop_all = TRUE)
} # }
```
