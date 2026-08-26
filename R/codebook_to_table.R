#' Compile all codebooks into a data frame
#'
#' Scans the `study/`, `experiment/`, and `analyses/` codebook directories
#' bundled with the package, reads each YAML file, and returns the metadata
#' as a data frame. If a `codebooks/` folder exists in the current working
#' directory, custom codebooks found there are included as well.
#'
#' Used internally by [databasePrepareCodebooks()] to populate `table_codebook`.
#'
#' @return A data frame with one row per codebook and the following columns:
#'
#' - `codebook_id`: Relative path identifier (e.g. `"study/participant"`).
#' - `codebook_name`: The `name` field from the codebook YAML.
#' - `codebook_version`: The version string (e.g. `"2.1"`).
#' - `authors`: Comma-separated list of authors, or `"Unknown"` if absent.
#' - `created_at`: Creation date from the YAML metadata.
#' - `updated_at`: Last update date from the YAML metadata, or `NA`.
#' - `n_parameters`: Number of variables defined in the codebook.
#' - `codebook_origin`: `"beFAIR"` for built-in codebooks; the project
#'   directory basename for custom codebooks.
#'
#' @seealso [databasePrepareCodebooks()], [codebookRead()],
#'   [codebookToSummary()]
#'
#' @examples
#' \dontrun{
#' codebookToTable()
#' }
#' @export
codebookToTable <- function() {
  lg <- lgr::get_logger("beFAIR")

  dirs <- c(study = "study", experiment = "experiment", analyses = "analyses")
  res <- data.frame(
    codebook_id      = character(0),
    codebook_name    = character(0),
    codebook_origin  = character(0),
    codebook_version = character(0),
    authors          = character(0),
    created_at       = character(0),
    updated_at       = character(0),
    n_parameters     = numeric(0)
  )

  lg$info("Building `table_codebook` from beFAIR",
          beFAIR_version = as.character(utils::packageVersion("beFAIR")),
          package_location = system.file(package = "beFAIR")
          )

  # --- Package (built-in) codebooks ---
  for (type in names(dirs)) {
    path <- system.file("codebooks", dirs[type], package = "beFAIR")
    files <- list.files(path, pattern = "\\.ya?ml$", full.names = TRUE)
    lg$info("Codebook files found", path = path, N = length(files))

    for (f in files) {
      file_base <- basename(f)

      yml <- tryCatch({
        yaml::read_yaml(f)
      }, error = function(e) {
        lg$error("Failed to parse codebook file",
                 codebook_name = sub(".yaml", "", file_base),
                 error_message = conditionMessage(e))
        return(NULL)
      })

      if (is.list(yml) && !is.null(yml$version)) {
        ver        <- format(yml$version, nsmall = 1)
        authors    <- if (!is.null(yml$authors)) paste(yml$authors, collapse = ", ") else "Unknown"
        created_at <- yml$created_at
        updated_at <- ifelse(is.null(yml$updated_at), NA, yml$updated_at)
        n_params   <- length(yml$variables)

        # TODO Maybe add relevant warnings, things like mismatch between variables,
        # missing validations. This would be the place to scrutinize the codebooks.
        # A hidden bug that I encounterd is that the yml$name was not matching with
        # the name of the file, so in the end we had analysis_luminex in de 'table_codebook'
        # with codebook_name = analysis_ELISA.

        codebook_id_val <- paste0(dirs[type], "/", tools::file_path_sans_ext(file_base))

        res <- rbind(res,
                     data.frame(
                       codebook_id      = codebook_id_val,
                       codebook_name    = yml$name,
                       codebook_origin  = "beFAIR",
                       codebook_version = ver,
                       authors          = authors,
                       created_at       = created_at,
                       updated_at       = updated_at,
                       n_parameters     = n_params
                     ))

        lg$info("Successfully processed codebook",
                codebook_id     = codebook_id_val,
                codebook_name   = yml$name,
                codebook_version = ver,
                parameters      = n_params)

      } else {
        lg$error("Invalid codebook (missing 'version' or not a list)", codebook_name = sub(".yaml", "", file_base))
      }
    }
  }

  # --- Custom codebooks from the project's codebooks/custom/ directory ---
  custom_root <- file.path(getwd(), "codebooks")
  if (dir.exists(custom_root)) {
    origin <- basename(getwd())

    path <- file.path(custom_root)
    if (dir.exists(path)) {
      files <- list.files(path, pattern = "\\.ya?ml$", full.names = TRUE)
      lg$info("Scanning custom codebook directory", path = path, origin = origin,
              N = length(files))

      for (f in files) {
        file_base <- basename(f)

        yml <- tryCatch({
          yaml::read_yaml(f)
        }, error = function(e) {
          lg$error("Failed to parse custom codebook file",
                   codebook_name = sub(".yaml", "", file_base),
                   error_message = conditionMessage(e))
          return(NULL)
        })

        if (is.list(yml) && !is.null(yml$version)) {
          ver        <- format(yml$version, nsmall = 1)
          authors    <- if (!is.null(yml$authors)) paste(yml$authors, collapse = ", ") else "Unknown"
          created_at <- yml$created_at
          updated_at <- ifelse(is.null(yml$updated_at), NA, yml$updated_at)
          n_params   <- length(yml$variables)

          codebook_id_val <- paste0("custom/", tools::file_path_sans_ext(file_base))

          res <- rbind(res,
                       data.frame(
                         codebook_id      = codebook_id_val,
                         codebook_name    = yml$name,
                         codebook_origin  = origin,
                         codebook_version = ver,
                         authors          = authors,
                         created_at       = created_at,
                         updated_at       = updated_at,
                         n_parameters     = n_params
                       ))

          lg$info("Successfully processed custom codebook",
                  codebook_id      = codebook_id_val,
                  codebook_name    = yml$name,
                  codebook_version = ver,
                  parameters       = n_params)

        } else {
          lg$error("Invalid custom codebook (missing 'version' or not a list)",
                   codebook_name = sub(".yaml", "", file_base))
        }
      }
    }

    # Conflict check: same codebook_name appearing in both package and custom sets
    pkg_names    <- res$codebook_name[res$codebook_origin == "beFAIR"]
    custom_names <- res$codebook_name[res$codebook_origin != "beFAIR"]
    conflicts    <- intersect(pkg_names, custom_names)
    if (length(conflicts) > 0) {
      stop(
        "Custom codebook(s) conflict with built-in beFAIR codebook(s). ",
        "Rename or remove the conflicting custom codebook(s): ",
        paste(conflicts, collapse = ", ")
      )
    }
  } else {
    lg$info("No codebooks/custom/ directory found; skipping custom codebook scan",
            path = path)
  }

  lg$info("'table_codebook' succesfully build from beFAIR with 'N' entries", N = nrow(res))
  return(res)
}
