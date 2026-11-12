# Generate a unique analysis ID

Generates a random analysis ID in the format `A` followed by 6 lowercase
hexadecimal characters (e.g. `"Aa3f9c1d"`). Uniqueness is guaranteed by
comparing against all existing analysis IDs read from the project's
`meta.yaml` files via
[`FAIRgroundOverview()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundOverview.md);
a new ID is resampled if a collision is detected.

## Usage

``` r
.setAnalysisId()
```

## Value

A character string: `"A"` followed by 6 random lowercase hexadecimal
characters (e.g. `"Aa3f9c1d"`), guaranteed to be unique within the
current FAIRground.

## See also

[`.setExperimentId()`](https://koenastam.github.io/beFAIR/reference/dot-setExperimentId.md),
[`addAnalysis()`](https://koenastam.github.io/beFAIR/reference/addAnalysis.md)
