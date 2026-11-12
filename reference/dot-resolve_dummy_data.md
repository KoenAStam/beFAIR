# Resolve a dummy data path for TESTground or the installed package

Walks up from the working directory looking for a folder whose path ends
in `marker`. If found, returns `p` relative to that folder's parent
(equivalent to the old `here::here("..", p)`). Otherwise falls back to
the dummy data shipped with beFAIR.

## Usage

``` r
.resolve_dummy_data(p, marker = "TESTground/project")
```

## Arguments

- p:

  Relative data path, e.g. `"data/CoHSI1/cytof barcodes"`.

- marker:

  Path suffix identifying the project root.

## Value

A file path (character scalar).
