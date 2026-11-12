# Summarise a codebook or one of its variables

Prints a summary of a codebook to the console. If no codebook name is
given, all available codebooks are listed. If a variable name is
supplied, detailed information for that variable (description, type,
categories, labels) is printed instead.

## Usage

``` r
codebookToSummary(codebook_name = NULL, var = NULL)
```

## Arguments

- codebook_name:

  Optional character string specifying the name of the codebook. If
  `NULL`, all available codebooks are listed.

- var:

  Optional character string specifying a variable within the codebook.
  If provided, detailed information for that variable is printed.

## Value

Invisibly returns `NULL`. Output is written to the console.

## See also

[`codebookRead()`](https://koenastam.github.io/beFAIR/reference/codebookRead.md),
[`codebookToDraft()`](https://koenastam.github.io/beFAIR/reference/codebookToDraft.md)

## Examples

``` r
if (FALSE) { # \dontrun{
  codebookToSummary()
  codebookToSummary("event")
  codebookToSummary("event", var = "event_id")
} # }
```
