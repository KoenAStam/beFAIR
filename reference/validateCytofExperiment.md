# Validate a CyTOF experiment

Performs a series of checks for a CyTOF experiment: verifies that the
experiment, panel, and barcoding scheme tables exist in the database;
checks FCS file structure and folder layout (`raw/`, `raw_processed/`);
compares panel channel IDs against the FCS file parameters; and verifies
that all barcoding scheme `event_id` values are linked to known
participants.

## Usage

``` r
validateCytofExperiment(experimentID, con = NULL)
```

## Arguments

- experimentID:

  Character. The experiment ID to validate (e.g. `"EG12345"`).

- con:

  A DBI connection. If `NULL`, the default connection set by
  [`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
  is used.

## Value

Invisibly returns `NULL`. Results are printed to the console with
`[OK]`, `[WARNING]`, and `[ERROR]` prefixes.

## See also

[`addExperiment()`](https://koenastam.github.io/beFAIR/reference/addExperiment.md),
[`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)

## Examples

``` r
if (FALSE) { # \dontrun{
  validateCytofExperiment("EG12345")
} # }
```
