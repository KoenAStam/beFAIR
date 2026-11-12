# Update a script record in `table_script`

Updates the `table_script` row identified by `script_id` with the MD5
hash of the current script file, codebook metadata, run time, and any
warning or TODO flags from the most recent ETL run. Called internally by
[`databaseUpdate()`](https://koenastam.github.io/beFAIR/reference/databaseUpdate.md)
after each script is sourced and validated.

## Usage

``` r
.updateTableScript(con = NULL, script_id, databook)
```

## Arguments

- con:

  A DBI connection. If `NULL`, the default connection set by
  [`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
  is used.

- script_id:

  A character string identifying the ETL script. Used both as the
  database key and the file path from which the MD5 hash is computed.

- databook:

  A named list as produced by
  [`sourceScript()`](https://koenastam.github.io/beFAIR/reference/sourceScript.md).
  Must contain:

  - `codebook_name`: Character scalar; target table name in the
    database.

  - `codebook_version`: Character scalar; version identifier for the
    codebook.

  - `run_time`: Numeric scalar; duration of the ETL script execution in
    seconds.

  - `flag_TODO`: Logical scalar; whether the script contains TODO flags.

  - `flag_WARN`: Logical scalar; whether the script produced warnings.

## Value

Invisibly returns `TRUE` on success or `FALSE` if the update query
fails.

## See also

[`databaseUpdate()`](https://koenastam.github.io/beFAIR/reference/databaseUpdate.md),
[`sourceScript()`](https://koenastam.github.io/beFAIR/reference/sourceScript.md)
