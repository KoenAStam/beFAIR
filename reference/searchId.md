# Search for studies, experiments, or analyses by ID or name

Performs a case-insensitive partial-match search against the `study`,
`experiment`, and `analysis` tables in the FAIRground database. The
query is matched against both the ID column and the `name` column of
each table.

## Usage

``` r
searchId(query, con = NULL)
```

## Arguments

- query:

  A character string to search for. Partial matches are supported (e.g.
  `"hypo"` will match `"HypoVax"` or `"HYPOV"`).

- con:

  A DBI connection. If `NULL`, the default connection set by
  [`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
  is used.

## Value

A `data.frame` with columns:

- `pillar`: one of `"study"`, `"experiment"`, or `"analysis"`

- `id`: the ID value (`study_id`, `experiment_id`, or `analysis_id`)

- `name`: the human-readable name

Returns an empty data frame with the same columns when no matches are
found.

## See also

[`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md),
[`FAIRgroundOverview()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundOverview.md)

## Examples

``` r
if (FALSE) { # \dontrun{
FAIRgroundConnect("LUCID_FAIRPOINT")
searchId("NIH")
searchId("A")
searchId("ELISA")
} # }
```
