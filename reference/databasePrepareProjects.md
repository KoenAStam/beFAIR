# Prepare the pillar project registry

Scans the FAIRground directories for pillar `meta.yaml` files
(`studies/`, `experiments/`, `analyses/`), computes folder hashes for
their `scripts/` subdirectory, and synchronises `table_project` in the
database.

## Usage

``` r
databasePrepareProjects(con = NULL)
```

## Arguments

- con:

  A DBI connection. If `NULL`, the default connection set by
  [`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
  is used.

## Value

Invisibly `NULL`. Called for its side effects.

## Details

For analyses the function also:

1.  Parses the optional `dependencies` field in `meta.yaml`.

2.  Upserts `analysis_input` rows into `table_dependency`, resolving
    each declared dependency to the corresponding `script_id` in
    `table_script`.

3.  Flags analyses as `up_to_date = 0` when any resolved dependency
    script has `queued_for_update = 1` in `table_script`.

## Dependency syntax

The `dependencies` field in an analysis `meta.yaml` is a YAML list where
each entry has the form `<codebook_name>[<id1>,<id2>,...]`. `id` values
are the short pillar IDs stored in `table_project.project_id` (e.g.
study `"CHSI1"` or experiment `"Eef536a"`). Multiple IDs for the same
codebook are comma-separated inside the brackets.

    dependencies:
      - participant[CHSI1]
      - cytofpanel[Eef536a,Eaa52ef]

## See also

[`databaseUpdate()`](https://koenastam.github.io/beFAIR/reference/databaseUpdate.md),
[`databasePrepareScripts()`](https://koenastam.github.io/beFAIR/reference/databasePrepareScripts.md)

## Examples

``` r
if (FALSE) { # \dontrun{
FAIRgroundConnect("MY_DSN")
databasePrepareProjects()
} # }
```
