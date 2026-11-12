# Hash a file, directory, or string

Hash a file, directory, or string

## Usage

``` r
.hash(x, type, algo = "md5", serialize = TRUE)
```

## Arguments

- x:

  Path (for `type = "content"`) or an R object (for `type = "string"`).

- type:

  `"content"` (file/directory) or `"string"`.

- algo:

  Hash algorithm forwarded to
  [`digest`](https://eddelbuettel.github.io/digest/man/digest.html).
  Defaults to `"md5"`.

- serialize:

  Forwarded to
  [`digest`](https://eddelbuettel.github.io/digest/man/digest.html).

## Value

A character scalar hash, or `NA_character_` if the path is missing or
the directory is empty.

## Details

**File**: raw bytes are hashed via `digest(file = x)`. **Directory**: a
metadata hash of each file's mtime and size (sorted by path) is produced
— detects additions, removals, renames, and size/mtime changes, but not
in-place edits that preserve both. **String**: `x` is passed directly to
`digest()`.
