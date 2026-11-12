# Convert a timepoint to days

Converts a timepoint expressed in days, weeks, months, or years to a
total number of days. Multiple units are summed. Assumes 1 year = 365
days, 1 month = 30 days, 1 week = 7 days.

## Usage

``` r
.timeToDays(days = 0, weeks = 0, months = 0, years = 0)
```

## Arguments

- days:

  Number of days.

- weeks:

  Number of weeks.

- months:

  Number of months.

- years:

  Number of years.

## Value

A numeric value representing the total number of days.
