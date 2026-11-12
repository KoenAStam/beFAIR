# View Codebook Relationship Map (ERD Style)

Calls
[`collectTablesById()`](https://koenastam.github.io/beFAIR/reference/collectTablesById.md)
to determine which tables are relevant for a given ID, then renders an
ERD-style diagram where each codebook appears as a SQL table node
listing its primary keys and foreign keys.

## Usage

``` r
viewCodebookMap(id, output = NULL, con = NULL)
```

## Arguments

- id:

  Character. A beFAIR ID to look up.

- output:

  Character or `NULL`. If `NULL` (default), the diagram is rendered in
  the RStudio Viewer. Supply a `.html` file path to save a
  self-contained HTML file instead.

- con:

  A DBI connection. If `NULL`, the default connection set by
  [`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
  is used.

## Value

Invisibly returns the `grViz` htmlwidget when saving; returns the widget
visibly (auto-displays in Viewer) otherwise.

## Details

The `id` can be any beFAIR identifier:

- Analysis ID (e.g. `"Ae0f301"`) — traces through experiments to studies

- Experiment ID (e.g. `"E4fe387"`) — traces through to studies

- Study ID (e.g. `"CHSI1"`) — shows study-level tables only

## See also

[`collectTablesById()`](https://koenastam.github.io/beFAIR/reference/collectTablesById.md),
[`searchId()`](https://koenastam.github.io/beFAIR/reference/searchId.md)

## Examples

``` r
if (FALSE) { # \dontrun{
  FAIRgroundConnect(dsn = "LUCID_FAIRPOINT")
  viewCodebookMap("Adf961e")
  viewCodebookMap("E133618", output = "codebook_map.html")
} # }
```
