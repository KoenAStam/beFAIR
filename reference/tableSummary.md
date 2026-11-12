# Summarise all variables in a codebook as a `gt` table

Produces a `gt` summary table for all variables defined in the named
codebook. For each variable, the table reports its type, completeness,
percentage not applicable (`-999` / `"N/A"`), percentage not measured
(`"N/M"`), mean, SD, and median, min, max (numeric variables), or the
set of unique values (character variables).

## Usage

``` r
tableSummary(data, codebook_name)
```

## Arguments

- data:

  A data frame containing the data to summarise, structured according to
  `codebook_name`.

- codebook_name:

  A character string specifying the codebook name (without `.yaml`
  extension).

## Value

A `gt` table object with one row per codebook variable. The table header
shows the codebook name and total row count. Completeness is
colour-coded on a red-yellow-green scale.

## See also

[`tableVariableByStudy()`](https://koenastam.github.io/beFAIR/reference/tableVariableByStudy.md),
[`codebookRead()`](https://koenastam.github.io/beFAIR/reference/codebookRead.md),
[`codebookToSummary()`](https://koenastam.github.io/beFAIR/reference/codebookToSummary.md)

## Examples

``` r
if (FALSE) { # \dontrun{
FAIRgroundConnect("LUCID_FAIRPOINT")
data <- DBI::dbReadTable(FAIRgroundConnection(), "participant")
tableSummary(data, "participant")
} # }
```
