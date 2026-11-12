# Safely extract a character field from a parsed YAML list

Returns `NA_character_` when the field is absent or `NULL`.

## Usage

``` r
.yamlField(data, field)
```

## Arguments

- data:

  A named list (typically from
  [`yaml::read_yaml()`](https://yaml.r-lib.org/reference/read_yaml.html)).

- field:

  Field name to extract.

## Value

A length-1 character vector.
