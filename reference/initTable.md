# Create or recreate a single database table from its codebook

Create or recreate a single database table from its codebook

## Usage

``` r
initTable(cb_name, overwrite, data = NULL, con = NULL)
```

## Arguments

- cb_name:

  Character. Codebook (and table) name.

- overwrite:

  Logical. Drop and recreate when `TRUE`; skip with a warning when
  `FALSE`.

- data:

  Optional data frame inserted after creation (used for built-in
  reference tables such as `HGNC` and `LUNC`).

- con:

  A DBI connection. If `NULL`, the default connection set by
  [`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
  is used.

## Value

Invisibly `NULL`.
