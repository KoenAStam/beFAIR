# Plot the dependency graph for a table produced by an analysis

Queries `table_dependency` and draws a three-level directed graph:

1.  The analysis node (root), labelled with `table_name` and `id`.

2.  Its `analysis_input` upstream scripts (the ETL scripts in other
    pillars that produce the data the analysis declared as
    dependencies).

3.  Each upstream script's own `datasource` and `script` dependencies
    (data files and id-mapping scripts).

## Usage

``` r
plotDependencies(table_name, id, con = NULL)
```

## Arguments

- table_name:

  Character. The codebook/table name produced by the analysis (e.g.
  `"som_clusterphenotype"`). Used as the root node label.

- id:

  Character. The `project_id` of the analysis (the 6-character hex
  `analysis_id` from `meta.yaml`).

- con:

  A DBI connection. If `NULL`, the default connection set by
  [`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
  is used.

## Value

Invisibly returns the `igraph` graph object. Called primarily for its
side effect of drawing a plot.

## Details

Node colours: blue = analysis, orange = script, green = datasource, red
= unresolved dependency (registered in meta.yaml but not yet in
`table_script`).

Requires the igraph package.

## See also

[`databasePrepareProjects()`](https://koenastam.github.io/beFAIR/reference/databasePrepareProjects.md),
[`databasePrepareDependencies()`](https://koenastam.github.io/beFAIR/reference/databasePrepareDependencies.md)

## Examples

``` r
if (FALSE) { # \dontrun{
FAIRgroundConnect("MY_DSN")
plotDependencies("som_clusterphenotype", "ab12cd")
} # }
```
