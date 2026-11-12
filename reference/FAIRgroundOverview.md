# Generate an overview of beFAIR meta.yaml files

This function reads and combines all `meta.yaml` files located under the
`studies`, `experiments`, and `analyses` directories. It returns a named
list containing data frames for each pillar, with each data frame
containing the standardized columns according to the respective
codebooks.

## Usage

``` r
FAIRgroundOverview(print = TRUE, print_full = FALSE)

overviewFAIRground(...)
```

## Arguments

- print:

  Logical. If TRUE (default), prints a summary preview to the console.

- print_full:

  Logical. If TRUE, prints all rows (up to 5 columns). Default is FALSE.

## Value

A named list of data frames. The list always contains three entries
corresponding to the main pillars: `studies`, `experiments`, and
`analyses`. When extended codebooks exist (e.g. `experiment_cytof`),
additional entries named after those codebooks are included, each
filtered to the matching `type`. Data frames contain only the columns
defined in the corresponding codebook; missing columns are silently
dropped. An empty data frame is returned for pillars that have no
`meta.yaml` files.

## Details

The function prints a preview of the main overviews. By default, only
the first 5 rows and first 5 columns are shown. Set `print_full = TRUE`
to display all rows (still limited to 5 columns for readability).

## Examples

``` r
FAIRgroundOverview()
#> 
#>  FAIRground Overview Summary
#> 
#> STUDIES: 0 rows × 0 columns
#>  (no data available)
#> 
#> EXPERIMENTS: 0 rows × 0 columns
#>  (no data available)
#> 
#> ANALYSES: 0 rows × 0 columns
#>  (no data available)
overview <- FAIRgroundOverview()
#> 
#>  FAIRground Overview Summary
#> 
#> STUDIES: 0 rows × 0 columns
#>  (no data available)
#> 
#> EXPERIMENTS: 0 rows × 0 columns
#>  (no data available)
#> 
#> ANALYSES: 0 rows × 0 columns
#>  (no data available)
```
