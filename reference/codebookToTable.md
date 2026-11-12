# Compile all codebooks into a data frame

Scans the `study/`, `experiment/`, and `analyses/` codebook directories
bundled with the package, reads each YAML file, and returns the metadata
as a data frame. If a `codebooks/` folder exists in the current working
directory, custom codebooks found there are included as well.

## Usage

``` r
codebookToTable()
```

## Value

A data frame with one row per codebook and the following columns:

- `codebook_id`: Relative path identifier (e.g. `"study/participant"`).

- `codebook_name`: The `name` field from the codebook YAML.

- `codebook_version`: The version string (e.g. `"2.1"`).

- `authors`: Comma-separated list of authors, or `"Unknown"` if absent.

- `created_at`: Creation date from the YAML metadata.

- `updated_at`: Last update date from the YAML metadata, or `NA`.

- `n_parameters`: Number of variables defined in the codebook.

- `codebook_origin`: `"beFAIR"` for built-in codebooks; the project
  directory basename for custom codebooks.

## Details

Used internally by
[`databasePrepareCodebooks()`](https://koenastam.github.io/beFAIR/reference/databasePrepareCodebooks.md)
to populate `table_codebook`.

## See also

[`databasePrepareCodebooks()`](https://koenastam.github.io/beFAIR/reference/databasePrepareCodebooks.md),
[`codebookRead()`](https://koenastam.github.io/beFAIR/reference/codebookRead.md),
[`codebookToSummary()`](https://koenastam.github.io/beFAIR/reference/codebookToSummary.md)

## Examples

``` r
if (FALSE) { # \dontrun{
codebookToTable()
} # }
```
