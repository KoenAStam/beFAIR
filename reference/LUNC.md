# LUCID Nomenclature (LUNC) data

Data frame with nomenclature used at our department. This is basically a
list of parameter descriptions that come from .fcs files that not have a
CD label or HGNC label. We use these data to convert our nomenclature to
(if able) `HCDM` nomenclature, or else to `HGNC`.

## Usage

``` r
LUNC
```

## Format

### `LUNC`

A data frame with 35 rows and 3 columns:

- fcs_parameters_desc:

  character the parameters description we get from fcs

- source:

  character some information on how we got this symbol

- symbol:

  character symbol we've chosen as standard label, this should
  preferably be from `HCDM` or `HGNC`

- symbol_database:

  character name of the database where we got the symbol from,
  department means that we kind of made up the name ourselves. Note that
  e.g. CD3 is not in HCDM but CD8A is
