# Convert a date string to ISO 8601 format

Convert a date string to ISO 8601 format

## Usage

``` r
harmonizeDate(date_string, date_format = "ymd")
```

## Arguments

- date_string:

  A character string representing a date.

- date_format:

  Format of `date_string`: `"ymd"` (default) or `"dmy"`.

## Value

A character string in `"YYYY-MM-DD"` format, or `NA` when the input is
`"-99"`, `"-98"`, `NA`, or unparseable.
