# Generate a unique experiment ID

Generates a random experiment ID in the format `E` followed by 6
lowercase hexadecimal characters (e.g. `"Ea3f9c1d"`). Uniqueness is
guaranteed by comparing against all existing experiment IDs read from
the project's `meta.yaml` files via
[`FAIRgroundOverview()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundOverview.md);
a new ID is resampled if a collision is detected.

## Usage

``` r
.setExperimentId()
```

## Value

A character string: `"E"` followed by 6 random lowercase hexadecimal
characters (e.g. `"Ea3f9c1d"`), guaranteed to be unique within the
current FAIRground.

## See also

[`.setAnalysisId()`](https://koenastam.github.io/beFAIR/reference/dot-setAnalysisId.md),
[`addExperiment()`](https://koenastam.github.io/beFAIR/reference/addExperiment.md)
