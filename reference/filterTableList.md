# Filter a table list by study IDs

This function takes an existing tableList object (as returned by
getDatabase()) and filters all tables based on one or more study_id's.
It preserves the structure of the dataset while restricting its contents
to only relevant studies, experiments and analyses.

## Usage

``` r
filterTableList(tableList, study_ids)
```

## Arguments

- tableList:

  Named list of data frames as produced by
  [`getDatabase()`](https://koenastam.github.io/beFAIR/reference/getDatabase.md).

- study_ids:

  Character vector of study identifiers to keep (e.g.
  `c("CHHIL", "ITCHI")`).

## Value

A filtered version of `tableList`, containing only rows linked to the
selected studies.

## See also

[`getDatabase()`](https://koenastam.github.io/beFAIR/reference/getDatabase.md),
[`databaseExport()`](https://koenastam.github.io/beFAIR/reference/databaseExport.md)

## Examples

``` r
if (FALSE) { # \dontrun{
  data <- getDatabase(path = "data/")
  filtered <- filterTableList(data, study_ids = c("CHHIL", "ITCHI"))
} # }
```
