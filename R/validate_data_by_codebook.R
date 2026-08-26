#' Validate a databook against its codebook rules
#'
#' Applies the validation rules defined in the codebook to the `databook$data`
#' data frame using `pointblank`. Also checks that all `source_id` values exist
#' in the `id_mapping` table (unless the codebook is `id_mapping` itself).
#'
#' @param databook A databook list as produced by [codebookToEntries()],
#'   containing `$data`, `$codebook`, and `$codebook_name`.
#' @param print Logical. If `TRUE` (default), prints the pointblank agent
#'   report to the console.
#' @param con A DBI connection. If `NULL`, the default connection set by [FAIRgroundConnect()] is used.
#'
#' @return A list with two elements:
#'   - `$status`: `1` if all validations passed, `0` if any failed.
#'   - `$summary`: the interrogated pointblank agent object.
#' @seealso [codebookToEntries()]
#' @examples
#' \dontrun{
#'   databook <- codebookToEntries("participant", nrow = 0)
#'   result <- validateDatabook(databook, print = FALSE)
#' }
#'
#' @export
validateDatabook <- function(databook, print=TRUE, con=NULL) {
  lg <- lgr::get_logger("beFAIR")

  ref_names <- names(databook$codebook)
  to_check_names <- names(databook$data)

  # Create an agent
  agent <- pointblank::create_agent(tbl = databook$data)

  # Do not perform validation if the dataset is empty
  if (!any(!is.na(databook$data))) {
    lg$error("Validation stopped: no data present in databook.")

    return(list(
      status  = 0,
      summary = NULL
    ))
  }

  # check to see if there are fewer or more columns expected by the database
  if (length(databook$codebook) != length(databook$data)){

    if (length(databook$codebook) < length(databook$data)){
      for(i in seq_along(ref_names)){
        mismatch <- to_check_names[!(to_check_names %in% ref_names)]
      }
      lg$error(sprintf("validation stopped: the number of data columns exceeds the required maximum.\n mismatches: %s", paste(unlist(mismatch), collapse = ", ")))

      return(list(
        status  = 0,
        summary = NULL
      ))
    }
    else if (length(databook$codebook) > length(databook$data))
    {
      for(i in seq_along(ref_names)){
        mismatch <- ref_names[!(ref_names %in% to_check_names)]
      }
      lg$error(sprintf("Validation stopped: the number of data columns is fewer than the required minimum.\n mismatches: %s", paste(unlist(mismatch), collapse = ", ")))
      return(list(
        status  = 0,
        summary = NULL
      ))
    }
  }

  # Apply validation steps from YAML
  for (item in ref_names) {
    if (!is.null(databook$codebook[[item]]$validations)) {
      for (validation in databook$codebook[[item]]$validations) {
        rule <- names(validation)[1]
        # arguments
        args <- validation[[rule]]

        # Convert "NA" string to actual NA value for col_vals_in_set validation rule
        if (rule == "col_vals_in_set") {
          if (!is.null(args$set)) {
            args$set <- lapply(args$set, function(x) if (x == "NA") NA else x)
          }
        }

        # Dynamically apply the validation rule using get() with the package namespace
        func <- get(rule, envir = asNamespace("pointblank"))  # Get the function from the pointblank namespace
        agent <- do.call(func, c(
          list(agent),
          dplyr::vars(!!rlang::sym(item)),
          args,
          list(actions = pointblank::warn_on_fail())
        ))
      }
    }
  }

  sourceIdsValid <- TRUE
  if ("source_id" %in% names(databook$data) && databook$codebook_name != "id_mapping") {
    idsExist <- validateSourceId(databook$data$source_id, databook$data$study_id, con=con)

    if (!isTRUE(idsExist$all_exist)) {
      lg$warn(
        "Not all source_ids exist in the id_mapping. Validation set to FALSE.",
        "Use missing_ids <- beFAIR::validateSourceId(databook$data$source_id, databook$data$study_id) to find the mismatching ids"
      )
      sourceIdsValid <- FALSE
    }
  }

  # Interrogate the data
  agent <- pointblank::interrogate(agent)
  if (print == TRUE){
    print(agent)
  }

  status <- if (pointblank::all_passed(agent) && sourceIdsValid) 1 else 0

  if (status == 0) {
    lg$warn("Validation failed. Please check the validation summary above.")
  }

  # Return detailed results along with the status
  list(
    status  = status,
    summary = agent
  )
}
