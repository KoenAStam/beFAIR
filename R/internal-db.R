# ── IO primitives ─────────────────────────────────────────────────────────────

#' Hash a file, directory, or string
#'
#' @param x Path (for \code{type = "content"}) or an R object
#'   (for \code{type = "string"}).
#' @param type \code{"content"} (file/directory) or \code{"string"}.
#' @param algo Hash algorithm forwarded to \code{\link[digest]{digest}}.
#'   Defaults to \code{"md5"}.
#' @param serialize Forwarded to \code{\link[digest]{digest}}.
#'
#' @return A character scalar hash, or \code{NA_character_} if the path is
#'   missing or the directory is empty.
#'
#' @details
#' \strong{File}: raw bytes are hashed via \code{digest(file = x)}.
#' \strong{Directory}: a metadata hash of each file's mtime and size (sorted
#' by path) is produced — detects additions, removals, renames, and
#' size/mtime changes, but not in-place edits that preserve both.
#' \strong{String}: \code{x} is passed directly to \code{digest()}.
#'
#' @keywords internal
.hash <- function(x, type, algo = "md5", serialize = TRUE) {
  stopifnot(type %in% c("content", "string"))

  if (type == "string") {
    return(digest::digest(x, algo = algo, serialize = serialize))
  }

  is_dir <- tryCatch(file.info(x)$isdir, error = function(e) NA)
  if (is.na(is_dir)) return(NA_character_)

  if (!is_dir) {
    return(digest::digest(file = x, algo = algo))
  }

  files <- sort(list.files(x, full.names = TRUE, recursive = TRUE, all.files = TRUE))
  if (!length(files)) return(NA_character_)
  meta <- paste(file.mtime(files), file.size(files), sep = "|", collapse = "\n")
  digest::digest(meta, algo = algo, serialize = FALSE)
}

#' Safely extract a character field from a parsed YAML list
#'
#' Returns \code{NA_character_} when the field is absent or \code{NULL}.
#'
#' @param data A named list (typically from \code{yaml::read_yaml()}).
#' @param field Field name to extract.
#'
#' @return A length-1 character vector.
#'
#' @keywords internal
.yamlField <- function(data, field) {
  val <- data[[field]]
  if (is.null(val)) NA_character_ else as.character(val)
}


# ── Database helpers ───────────────────────────────────────────────────────────

#' Detect database table dependencies in an ETL script
#'
#' Reads an ETL script with \code{readLines} and statically scans for database
#' read calls. Returns one row per detected dependency.
#'
#' @param script_id Character. Path to the ETL script file.
#'
#' @return A data frame with columns \code{table_name}, \code{ids},
#'   \code{call_type}, and \code{line}. Returns zero rows when no reads are
#'   detected. Only string-literal table names can be resolved; names
#'   constructed via variables or \code{paste()} appear as \code{"(dynamic)"}.
#'
#' @details
#' Detected patterns: \code{dbReadTable}, \code{dbGetQuery} (inline string and
#' \code{sprintf} variants), \code{collectTable}, and \code{validateSourceId} (always resolves
#' to \code{id_mapping}).
#'
#' @seealso [databasePrepareScripts()], [collectTable()]
#'
#' @keywords internal
.scriptDependencies <- function(script_id) {
  lines <- readLines(script_id, warn = FALSE)
  text  <- paste(lines, collapse = "\n")

  # Map a character offset in the collapsed string back to a line number
  line_ends <- cumsum(nchar(lines) + 1L)
  to_line <- function(pos) findInterval(pos - 1L, line_ends) + 1L

  out <- data.frame(
    table_name = character(),
    ids        = character(),
    call_type  = character(),
    line       = integer(),
    stringsAsFactors = FALSE
  )

  .push <- function(tbl, ids, call_type, pos) {
    out <<- rbind(out, data.frame(
      table_name = tbl,
      ids        = if (is.na(ids) || !nzchar(trimws(ids))) NA_character_ else trimws(ids),
      call_type  = call_type,
      line       = to_line(pos),
      stringsAsFactors = FALSE
    ))
  }

  # --- 1. (DBI::)dbReadTable(con, "table") ---
  pat <- '(?:DBI::)?dbReadTable\\s*\\([^,\\n]+,\\s*["\']([^"\'\\n]+)["\']'
  hits <- gregexpr(pat, text, perl = TRUE)[[1]]
  if (hits[1] != -1) {
    ml <- attr(hits, "match.length")
    for (i in seq_along(hits)) {
      chunk <- substr(text, hits[i], hits[i] + ml[i] - 1L)
      tbl   <- sub(pat, "\\1", chunk, perl = TRUE)
      .push(tbl, NA_character_, "dbReadTable", hits[i])
    }
  }

  # --- 2. (DBI::)dbGetQuery(con, "...SQL...") with inline string literal ---
  pat <- '(?:DBI::)?dbGetQuery\\s*\\([^,\\n]+,\\s*["\']([^"\'\\n]+)["\']'
  hits <- gregexpr(pat, text, perl = TRUE)[[1]]
  if (hits[1] != -1) {
    ml <- attr(hits, "match.length")
    for (i in seq_along(hits)) {
      chunk <- substr(text, hits[i], hits[i] + ml[i] - 1L)
      sql   <- sub(pat, "\\1", chunk, perl = TRUE)

      # Extract table name(s) from FROM clause
      from_m  <- gregexpr("(?i)\\bFROM\\s+(\\w+)", sql, perl = TRUE)[[1]]
      from_ml <- attr(from_m, "match.length")
      tbls <- if (from_m[1] != -1) {
        vapply(seq_along(from_m), function(j) {
          trimws(sub("(?i).*\\bFROM\\s+", "",
                     substr(sql, from_m[j], from_m[j] + from_ml[j] - 1L),
                     perl = TRUE))
        }, character(1))
      } else {
        NA_character_
      }

      # Extract raw WHERE condition
      ids <- if (grepl("(?i)\\bWHERE\\b", sql, perl = TRUE))
        sub("(?i).*\\bWHERE\\b\\s*", "", sql, perl = TRUE)
      else
        NA_character_

      for (tbl in tbls) .push(tbl, ids, "dbGetQuery", hits[i])
    }
  }

  # --- 3. (DBI::)dbGetQuery(con, sprintf("...FROM table...", ...)) ---
  pat <- '(?:DBI::)?dbGetQuery\\s*\\([^,\\n]+,\\s*sprintf\\s*\\(["\']([^"\'\\n]+)["\']'
  hits <- gregexpr(pat, text, perl = TRUE)[[1]]
  if (hits[1] != -1) {
    ml <- attr(hits, "match.length")
    for (i in seq_along(hits)) {
      chunk    <- substr(text, hits[i], hits[i] + ml[i] - 1L)
      template <- sub(pat, "\\1", chunk, perl = TRUE)

      from_m  <- gregexpr("(?i)\\bFROM\\s+(\\w+|%s)", template, perl = TRUE)[[1]]
      from_ml <- attr(from_m, "match.length")
      tbls <- if (from_m[1] != -1) {
        vapply(seq_along(from_m), function(j) {
          raw <- trimws(sub("(?i).*\\bFROM\\s+", "",
                            substr(template, from_m[j], from_m[j] + from_ml[j] - 1L),
                            perl = TRUE))
          if (raw == "%s") "(dynamic)" else raw
        }, character(1))
      } else {
        NA_character_
      }

      for (tbl in tbls) .push(tbl, NA_character_, "dbGetQuery (sprintf)", hits[i])
    }
  }

  # --- 4. collectTable(table_name = "...", script_id = "...") ---
  pat <- '(?:collectTable)\\s*\\([^)]*?table_name\\s*=\\s*["\']([^"\']+)["\']'
  hits <- gregexpr(pat, text, perl = TRUE)[[1]]
  if (hits[1] != -1) {
    ml <- attr(hits, "match.length")
    for (i in seq_along(hits)) {
      chunk <- substr(text, hits[i], hits[i] + ml[i] - 1L)
      tbl   <- sub(pat, "\\1", chunk, perl = TRUE)
      sid_m <- regexpr('script_id\\s*=\\s*["\']([^"\']+)["\']', chunk, perl = TRUE)
      sid   <- if (sid_m != -1) {
        sid_chunk <- substr(chunk, sid_m, sid_m + attr(sid_m, "match.length") - 1L)
        sub('.*=\\s*["\']([^"\']+)["\']', "\\1", sid_chunk, perl = TRUE)
      } else {
        NA_character_
      }
      .push(tbl, sid, "collectTable", hits[i])
    }
  }

  # --- 5. validateSourceId(...) → always reads id_mapping ---
  hits <- gregexpr("validateSourceId\\s*\\(", text, perl = TRUE)[[1]]
  if (hits[1] != -1) {
    .push("id_mapping", NA_character_, "validateSourceId", hits[1])
  }

  out
}

#' Generate a SQL table from a codebook schema
#'
#' Creates a new table in the database whose columns and SQL types are derived
#' from the specified codebook. `DECIMAL` fields are created as
#' `DECIMAL(38, 18)`.
#'
#' @param con A DBI connection. If `NULL`, the default connection set by [FAIRgroundConnect()] is used.
#' @param table_name Character. Name of the codebook (and resulting table).
#'
#' @return Invisibly returns `NULL`. Logs success or failure via the beFAIR
#'   logger.
#' @seealso [databasePrepareCodebooks()]
#'
#' @keywords internal
.sqlGenerateTable <- function(con=NULL, table_name) {
  #TODO add functionality that drops the table if it already exists (log warning)

  lg <- lgr::get_logger("beFAIR")
  con <- FAIRgroundConnection(con)

  codebook <- codebookRead(codebook_name = table_name)$variables

  sqlCreate <- paste0("CREATE TABLE ", table_name, " (\n")

  for (field in names(codebook)) {
    fieldInfo <- codebook[[field]]
    fieldName <- field
    sqlType <- fieldInfo$type_sql

    if (toupper(sqlType) == "DECIMAL") {
      sqlType <- "DECIMAL(38, 18)"
    }

    sqlCreate <- paste0(sqlCreate, "  ", fieldName, " ", sqlType, ",\n")
  }

  sqlCreate <- substr(sqlCreate, 1, nchar(sqlCreate) - 2)
  sqlCreate <- paste0(sqlCreate, "\n);")

  tryCatch({
    DBI::dbExecute(con, sqlCreate)
    lg$info("Table created successfully",
            table_name = table_name,
            caller = ".sqlGenerateTable")
  }, error = function(e) {
    lg$info("Failed to create table",
            table_name = table_name,
            error_message = conditionMessage(e),
            caller = ".sqlGenerateTable")
  })
}

#' Append a data frame to a SQL table
#'
#' Appends all rows of `data` to an existing table in the database using
#' `DBI::dbWriteTable` with `append = TRUE`.
#'
#' @param con A DBI connection. If `NULL`, the default connection set by [FAIRgroundConnect()] is used.
#' @param data Data frame to append.
#' @param table_name Character. Name of the target database table.
#' @param script_id Character. The script identifier associated with these
#'   rows; used for logging only. Default: `NA`.
#'
#' @return Invisibly returns `TRUE` on success, `FALSE` on error.
#' @seealso [databasePrepareData()]
#'
#' @keywords internal
.sqlPushTable <- function(con=NULL, data, table_name, script_id=NA) {
  lg <- lgr::get_logger("beFAIR")
  con <- FAIRgroundConnection(con)

  # TODO check if entries are already in the database

  tryCatch({
    DBI::dbWriteTable(con, table_name, data, append = TRUE, row.names = FALSE)
    lg$info("Successfully pushed 'N' rows to table in database",
            table_name = table_name,
            script_id = script_id,
            N = nrow(data),
            caller = ".sqlPushTable")
    invisible(TRUE)
  }, error = function(e) {
    lg$error("Failed to push data to database",
             table_name = table_name,
             script_id = script_id,
             error_message = conditionMessage(e),
             caller = ".sqlPushTable")
    invisible(FALSE)
  })
}

#' Remove rows from a table matching a script ID
#'
#' Deletes all rows in the specified table where `script_id` matches the
#' given value. Used before re-sourcing an ETL script to clear its previous
#' output.
#'
#' @param con A DBI connection. If `NULL`, the default connection set by [FAIRgroundConnect()] is used.
#' @param table_name Character. Name of the database table to remove rows from.
#' @param script_id Character. The script identifier whose rows should be deleted.
#'
#' @return Invisibly returns `TRUE` on success (including when no rows matched),
#'   `FALSE` on error.
#' @seealso [databaseUpdate()]
#'
#' @keywords internal
.sqlRemoveEntries <- function(con=NULL, table_name, script_id) {
  lg <- lgr::get_logger("beFAIR")
  con <- FAIRgroundConnection(con)

  tbl_id <- DBI::dbQuoteIdentifier(con, table_name)

  # Check current entries
  entries <- DBI::dbGetQuery(
    con,
    paste0("SELECT * FROM ", tbl_id, " WHERE script_id = ?"),
    params = list(script_id)
  ) |> nrow()
  if(entries == 0){
    lg$info("No entries currently exist in table for given script_id",
            script_id = script_id,
            table_name = table_name,
            caller=".sqlRemoveEntries")
    invisible(TRUE)
  } else {
    tryCatch({
      n <- DBI::dbExecute(
        con,
        paste0("DELETE FROM ", tbl_id, " WHERE script_id = ?"),
        list(script_id)
      )
      lg$info("Removed N rows from table",
              N = n,
              table_name = table_name,
              script_id = script_id,
              caller=".sqlRemoveEntries")
      invisible(TRUE)
    }, error = function(e) {
      lg$error("Failed to remove entries",
               table_name = table_name,
               script_id = script_id,
               error = conditionMessage(e),
               caller=".sqlRemoveEntries")
      invisible(FALSE)
    })
  }
}

#' Drop a database table if it exists
#'
#' @param con A DBI connection.
#' @param table_name Character. Name of the table to drop.
#' @param lg An lgr logger object.
#'
#' @return Invisibly `NULL`.
#'
#' @keywords internal
.sqlDropTable <- function(con, table_name) {
  lg <- lgr::get_logger("beFAIR")
  if (!DBI::dbExistsTable(con, table_name)) return(invisible(NULL))
  DBI::dbRemoveTable(con, table_name)
  lg$info("Dropped table", table_name = table_name)
  invisible(NULL)
}

#' Delete rows from a table matching a single column value
#'
#' Executes a parameterized \code{DELETE FROM <table> WHERE <col> = ?}.
#'
#' @param con A DBI connection.
#' @param table_name Character. Name of the table.
#' @param where_col Character. Column name used in the WHERE clause.
#' @param where_val The value to match.
#' @param lg An lgr logger object.
#'
#' @return Invisibly, the number of rows deleted.
#'
#' @keywords internal
.sqlDeleteRows <- function(con, table_name, where_col, where_val) {
  lg <- lgr::get_logger("beFAIR")
  sql <- sprintf("DELETE FROM %s WHERE %s = ?",
                 DBI::dbQuoteIdentifier(con, table_name),
                 DBI::dbQuoteIdentifier(con, where_col))
  n <- DBI::dbExecute(con, sql, list(where_val))
  lg$info("Deleted rows", table_name = table_name, n_deleted = n)
  invisible(n)
}


#' Update a script record in `table_script`
#'
#' Updates the `table_script` row identified by `script_id` with the MD5 hash
#' of the current script file, codebook metadata, run time, and any warning or
#' TODO flags from the most recent ETL run. Called internally by [databaseUpdate()]
#' after each script is sourced and validated.
#'
#' @param con A DBI connection. If `NULL`, the default connection set by [FAIRgroundConnect()] is used.
#' @param script_id A character string identifying the ETL script. Used both as
#'   the database key and the file path from which the MD5 hash is computed.
#' @param databook A named list as produced by [sourceScript()]. Must contain:
#'
#' - `codebook_name`: Character scalar; target table name in the database.
#' - `codebook_version`: Character scalar; version identifier for the codebook.
#' - `run_time`: Numeric scalar; duration of the ETL script execution in seconds.
#' - `flag_TODO`: Logical scalar; whether the script contains TODO flags.
#' - `flag_WARN`: Logical scalar; whether the script produced warnings.
#'
#' @return Invisibly returns `TRUE` on success or `FALSE` if the update query fails.
#'
#' @seealso [databaseUpdate()], [sourceScript()]
#'
#' @keywords internal
.updateTableScript <- function(con = NULL, script_id, databook) {
  lg <- lgr::get_logger("beFAIR")
  con <- FAIRgroundConnection(con)

  scriptHash <- .hash(
    paste(readLines(script_id, warn = FALSE), collapse = "\n"),
    type = "string",
    algo = "md5"
  )

  tryCatch({
    query <- "
    UPDATE table_script
    SET script_hash         = ?,
        codebook_name       = ?,
        codebook_version    = ?,
        updated_at          = ?,
        run_time            = ?,
        flag_TODO           = ?,
        flag_WARN           = ?,
        queued_for_update   = 0,
        entries_in_database = 1
    WHERE script_id         = ?
    "
    params <- list(
      script_hash      = scriptHash,
      codebook_name    = databook$codebook_name,
      codebook_version = databook$codebook_version,
      updated_at       = as.character(Sys.Date()),
      run_time         = databook$run_time,
      flag_TODO        = databook$flag_TODO,
      flag_WARN        = databook$flag_WARN,
      script_id        = script_id
    )

    DBI::dbExecute(con, query, params)

    lg$info("Succesfully updated table_script with latest version of script_id",
             script_id = script_id,
             script_hash = scriptHash,
             codebook_name = databook$codebook_name,
             table_name = "script_table",
             caller = ".updateTableScript")

    invisible(TRUE)
  }, error = function(e) {
    lg$error("Failed to update table_script with latest version of script_id",
             script_id = script_id,
             script_hash = scriptHash,
             codebook_name = databook$codebook_name,
             table_name = "script_table",
             error_message = conditionMessage(e),
             caller = ".updateTableScript")

    invisible(FALSE)
  })
}


# ── Date / time utilities ──────────────────────────────────────────────────────

#' Convert a timepoint to days
#'
#' Converts a timepoint expressed in days, weeks, months, or years to a total
#' number of days. Multiple units are summed. Assumes 1 year = 365 days,
#' 1 month = 30 days, 1 week = 7 days.
#'
#' @param days Number of days.
#' @param weeks Number of weeks.
#' @param months Number of months.
#' @param years Number of years.
#'
#' @return A numeric value representing the total number of days.
#'
#' @keywords internal
.timeToDays <- function(days = 0, weeks = 0, months = 0, years = 0) {
  (years * 365) + (months * 30) + (weeks * 7) + days
}


# ── External API ───────────────────────────────────────────────────────────────

#' Fetch study metadata from the ClinicalTrials.gov API
#'
#' Queries the ClinicalTrials.gov v2 API for the given registration code and
#' returns a named list of study fields that map to the \code{study} codebook
#' variables.
#'
#' @param registration_code Character. ClinicalTrials.gov registration code
#'   (e.g. \code{"NCT04269915"}).
#'
#' @return A named list of study metadata, or an empty list if the request
#'   fails.
#'
#' @keywords internal
.clinicaltrialGetStudy <- function(registration_code) {
  baseApiUrl <- "https://clinicaltrials.gov/api/v2"
  studyUrl <- paste0(baseApiUrl, "/studies/", registration_code)
  studyResponse <- httr::GET(studyUrl, httr::accept("application/json"))

  # Check if the response is successful (status code 200)
  if (studyResponse$status_code != 200) {
    message("Failed to fetch study information for registration code ", registration_code)
    return(list())  # Return an empty list
  }

  study <<- httr::content(studyResponse)

  locations <- study[["protocolSection"]][["contactsLocationsModule"]][["locations"]]
  outcomes <- study[["protocolSection"]][["outcomesModule"]][["primaryOutcomes"]]
  geopoints <- lapply(locations, function(location) sprintf("lat: %f lon: %f", location[["geoPoint"]][1], location[["geoPoint"]][2]))
  overallOfficials <- study[["protocolSection"]][["contactsLocationsModule"]][["overallOfficials"]]

  piNames <- Filter(function(o) identical(o[["role"]], "PRINCIPAL_INVESTIGATOR"), overallOfficials)

  studyInfo <- list()

  # variables are defined in codebooks/study/study.yaml
  studyInfo$facilities <- paste(countries <- lapply(locations, function(location) location[["facility"]]), collapse = ", ")
  studyInfo$cities <- paste(countries <- lapply(locations, function(location) location[["city"]]), collapse = ", ")
  studyInfo$countries <- paste(countries <- lapply(locations, function(location) location[["country"]]), collapse = ", ")
  studyInfo$geopoints <- paste(geopoints, collapse = ", ")
  studyInfo$principal_investigator <- paste(sapply(piNames, function(o) o[["name"]]), collapse = ", ")
  studyInfo$geopoints <- paste(geopoints, collapse = ", ")
  studyInfo$primary_outcome <- paste(countries <- lapply(outcomes, function(outcomes) outcomes[["measure"]]), collapse = ", ")
  studyInfo$summary <- study[["protocolSection"]][["descriptionModule"]][["briefSummary"]]
  studyInfo$description <- study[["protocolSection"]][["descriptionModule"]][["detailedDescription"]]
  studyInfo$actual_start_date <- harmonizeDate(as.character(study[["protocolSection"]][["statusModule"]][["startDateStruct"]][["date"]]))
  studyInfo$actual_completion_date <- harmonizeDate(as.character(study[["protocolSection"]][["statusModule"]][["completionDateStruct"]][["date"]]))
  studyInfo$actual_enrollment <- study[["protocolSection"]][["designModule"]][["enrollmentInfo"]][["count"]]
  studyInfo$registration_link <- paste0("https://clinicaltrials.gov/study/", registration_code)

  return(studyInfo)
}
