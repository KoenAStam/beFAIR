# Check whether source IDs exist in the ID mapping table

Checks if each `source_id` is present in the database table `id_mapping`
for the corresponding `study_id`. Reserved control/blank IDs (`"BLANK"`,
`"STD"`, `"CTRL"`, `"NEG_CTRL"`, `"POS_CTRL"`, `"BLANK_STD"`,
`"SAMPLE_STD"`) are skipped without a database lookup.

## Usage

``` r
validateSourceId(source_id, study_id, con = NULL)
```

## Arguments

- source_id:

  A character vector of source IDs to check.

- study_id:

  A character vector of study IDs, same length as `source_id` (or length
  1 to recycle).

- con:

  A DBI connection. If `NULL`, the default connection set by
  [`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
  is used.

## Value

A named list:

- all_exist:

  Logical scalar; `TRUE` when all IDs were found.

- missing_id:

  Data frame with columns `id`, `study_id`, and `id_type` for any
  unresolved IDs.
