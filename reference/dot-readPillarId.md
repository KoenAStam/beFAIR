# Extract the short pillar ID from a parsed meta.yaml list

Extract the short pillar ID from a parsed meta.yaml list

## Usage

``` r
.readPillarId(meta, pillar)
```

## Arguments

- meta:

  A named list parsed from a pillar `meta.yaml` file.

- pillar:

  One of `"studies"`, `"experiments"`, or `"analyses"`.

## Value

A character scalar with the pillar ID, or `NA_character_` if the field
is missing.
