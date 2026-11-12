# Retrieve all registry information for a project

Queries every registry table (`table_project`, `table_script`,
`table_dependency`, `table_datasource`, `table_codebook`) and returns
the rows that belong to the given `project_id` as a named list of data
frames.

## Usage

``` r
getProjectInfo(project_id, con = NULL)
```

## Arguments

- project_id:

  Character scalar. The unique project identifier (`study_id`,
  `experiment_id`, or `analysis_id`) as stored in `table_project`.

- con:

  A `DBIConnection`. If `NULL` (default) the package-level connection
  set by
  [`FAIRgroundConnect`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
  is used.

## Value

A named list with elements:

- project:

  1-row data frame from `table_project`.

- scripts:

  data frame from `table_script` for scripts belonging to this project
  (matched by path prefix).

- dependencies:

  data frame from `table_dependency` — all rows where `script_id` is one
  of this project's scripts, plus any rows where `project_id` matches
  (analysis-input dependencies).

- datasources:

  data frame from `table_datasource` for datasource files residing in
  this project's directory.

- codebooks:

  data frame from `table_codebook` for every codebook targeted by this
  project's scripts.

Returns `NULL` invisibly (with a warning) if `project_id` is not found
in `table_project`.
