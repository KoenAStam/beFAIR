# Prepare data source registry

Scans the FAIRground directories for data-source YAML files (files
located in a `data/` subfolder under `studies/`, `experiments/`, and
`analyses/`), reads their metadata, computes MD5 hashes for the actual
data files they reference, and synchronises `table_datasource` in the
database.

## Usage

``` r
databasePrepareDatasources(con = NULL)
```

## Arguments

- con:

  A DBI connection. If `NULL`, the default connection set by
  [`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
  is used.

## Value

Invisibly `NULL`. Called for its side effects.

## Details

The function identifies and tracks:

- **New YAML files** not yet present in `table_datasource` — inserted
  with `present_in_project = 1`.

- **Existing YAML files** — all metadata fields and `file_hash` are
  refreshed.

- **Gone YAML files** whose path is no longer found on disk — marked
  with `present_in_project = 0`; never deleted from the registry.

## See also

[`databaseUpdate()`](https://koenastam.github.io/beFAIR/reference/databaseUpdate.md),
[`databasePrepareScripts()`](https://koenastam.github.io/beFAIR/reference/databasePrepareScripts.md)

## Examples

``` r
if (FALSE) { # \dontrun{
FAIRgroundConnect("MY_DSN")
databasePrepareDatasources()
} # }
```
