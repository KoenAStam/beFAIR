#' Add a study to the FAIRground
#'
#' Creates a study directory structure under `studies/`, writes a `meta.yaml`,
#' copies a data template, and drafts the standard ETL scripts for the
#' `id_mapping`, `participant`, `studyarm`, and `studydesign` codebooks.
#' If a `registration_code` is provided, study metadata is fetched from
#' ClinicalTrials.gov and merged into the `meta.yaml`.
#'
#' @param study_name A character string specifying the name of the study.
#'   Used as the directory name under `studies/`.
#' @param study_id A unique identifier for the study. Must be exactly 5
#'   alphanumeric characters. Used as a prefix when generating
#'   `participant_id` values.
#' @param registration_code Optional. The ClinicalTrials.gov registration
#'   code (e.g. "NCT04269915"). If provided, additional study metadata
#'   is fetched from ClinicalTrials.gov and merged into `meta.yaml`.
#'
#' @return Called for its side effects. Creates the study directory and
#'   subdirectories (`scripts/`, `data/`), writes `meta.yaml`, copies a
#'   data template, and drafts four ETL scripts. Prints a message on success.
#'
#' @seealso [addExperiment()], [addAnalysis()], [draftScript()]
#'
#' @examples
#' \dontrun{
#' addStudy("CoHSI1", "CHSI1", "NCT04269915")
#' addStudy("MyStudy", "MSTUDY")
#' }
#' @export
addStudy <- function(study_name, study_id, registration_code=NULL){
  dir <- paste0("studies/", study_name)

  if(missing(study_id)){
    stop("study_id is missing")
  }

  # check requirements of study_id
  if(nchar(study_id) != 5){
    stop("study_id should be length == 5")
  } else if(!grepl("^[a-zA-Z0-9]+$", study_id)){
    stop("study_id should only contain alphanumeric characters")
  }

  studies <- FAIRgroundOverview(print=FALSE)$studies

  # check if study_id is unique using the meta files within the study directories
  if(sum(dim(studies)) != 0){
    if (study_id %in% studies$study_id) {
      stop(sprintf("study_id already exists, please ensure it is not one of these existing IDs: %s", toString(studies$study_id)))
    }
  }

  # Check if study_name already exists
  if(dir.exists(dir)){
    stop("study_name already exists, check if unique.")
  } else {
    dir.create(dir)
    dir.create(paste0(dir, "/scripts"))
    dir.create(paste0(dir, "/data"))
  }

  # Copy example data_template file to the data folder
  templatePath <- system.file("codebooks", "data", "data_template.yaml", package = "beFAIR")
  file.copy(templatePath, paste0(dir, "/data/template.yaml"))

  # create meta file
  meta <- modifyList(
    lapply(codebookRead("study")$variables, function(x) NULL),
    list(
      study_id = study_id,
      name = study_name,
      registration_code = registration_code
    )
  )


  # Check if registration code exists and fetch study info if it does
  # Assume that the study is registered at clinicaltrial.gov
  if (!is.null(registration_code)) {
    additionalStudyInfo <- .clinicaltrialGetStudy(registration_code)

    # Merge additional info
    meta <- modifyList(meta, additionalStudyInfo)
  }

  # TODO without registration code the entries should also be added(facilities, primary_outcome etc)
  yaml::write_yaml(meta, paste0(dir, "/meta.yaml"))

  # scripts
  draftScript(name=study_name, pillar="studies", codebook_name="id_mapping")
  draftScript(name=study_name, pillar="studies", codebook_name="participant")
  draftScript(name=study_name, pillar="studies", codebook_name="studyarm")
  draftScript(name=study_name, pillar="studies", codebook_name="studydesign")

  message(sprintf("Study added: %s. Fill in the missing study information in the meta.yaml file.", meta$name))
}
