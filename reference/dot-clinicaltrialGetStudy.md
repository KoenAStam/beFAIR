# Fetch study metadata from the ClinicalTrials.gov API

Queries the ClinicalTrials.gov v2 API for the given registration code
and returns a named list of study fields that map to the `study`
codebook variables.

## Usage

``` r
.clinicaltrialGetStudy(registration_code)
```

## Arguments

- registration_code:

  Character. ClinicalTrials.gov registration code (e.g.
  `"NCT04269915"`).

## Value

A named list of study metadata, or an empty list if the request fails.
