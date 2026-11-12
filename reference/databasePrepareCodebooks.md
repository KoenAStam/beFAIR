# Prepare and synchronize beFAIR codebooks with the database

Builds a codebook metadata overview from the beFAIR package and
synchronizes it with the database table `table_codebook`. New codebooks
are inserted and their corresponding SQL tables are created. For
existing codebooks, version changes are detected and handled as follows:

## Usage

``` r
databasePrepareCodebooks(con = NULL)
```

## Arguments

- con:

  A DBI connection. If `NULL`, the default connection set by
  [`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
  is used.

## Value

Invisibly returns `NULL`. Called for its side effects on the database.

## Details

- **Major version increase**: drops and recreates the corresponding data
  table, and replaces the metadata row in `table_codebook`.

- **Minor version increase**: updates metadata in `table_codebook`
  (e.g., version, authors, update date, and parameter count).

**Database requirements:** This function expects the metadata table
`table_codebook` to exist and be readable.

**Database effects:**

- Inserts rows into `table_codebook` for newly detected codebooks.

- Creates SQL data tables for new codebooks via
  [`.sqlGenerateTable()`](https://koenastam.github.io/beFAIR/reference/dot-sqlGenerateTable.md).

- On major updates, executes `DROP TABLE IF EXISTS <codebook_name>` and
  recreates the table, then replaces the corresponding `table_codebook`
  row.

- On minor updates, updates `table_codebook` fields in-place.

**Version semantics:** Codebook versions are interpreted as
`major.minor` numeric pairs. Only increases trigger database actions;
equal versions result in no changes.

## See also

[`codebookToTable()`](https://koenastam.github.io/beFAIR/reference/codebookToTable.md),
[`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md),
[`FAIRgroundConnection()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnection.md)

## Examples

``` r
if (FALSE) { # \dontrun{
FAIRgroundConnect("MY_DSN")
databasePrepareCodebooks()
} # }
```
