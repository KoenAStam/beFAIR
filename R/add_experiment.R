#' Add an experiment to the FAIRground
#'
#' Creates an experiment directory structure under `experiments/`, writes a
#' `meta.yaml` initialised from the base `experiment` codebook and a
#' type-specific codebook, copies a data template, and drafts the standard
#' ETL scripts for the selected experiment type.
#'
#' @param experiment_name A character string specifying the name of the
#'   experiment. Typically composed of the study name, experiment type, and a
#'   descriptor, separated by underscores (e.g. `"CoHSI1_CyTOF_surface"`).
#' @param experiment_type A character string specifying the type of the
#'   experiment. Must be one of `"CyTOF"`, `"Array"`, `"Luminex"`, `"ELISA"`,
#'   `"Aurora"`, `"Olink"`, `"UPLC"`, or `"LCMS"`.
#'
#' @return Called for its side effects. Creates the experiment directory and
#'   subdirectories (`scripts/`, `data/`), writes `meta.yaml`, copies a data
#'   template, and drafts scripts. Prints a message on success. Invisibly
#'   returns `NULL`.
#'
#' @seealso [addStudy()], [addAnalysis()], [draftScript()]
#'
#' @examples
#' \dontrun{
#' addExperiment("CoHSI1_CyTOF_exvivo", "CyTOF")
#' addExperiment("ReCHHI1_ELISA_IgE", "ELISA")
#' }
#' @export
addExperiment <- function(experiment_name,
  experiment_type = c(
    "CyTOF",
    "Array",
    "Luminex",
    "ELISA",
    "Aurora",
    "Olink",
    "UPLC",
    "LCMS"
    )
  ) {

  # Check if experiment_type is provided and is valid
  if (missing(experiment_type)) {
    stop("Error: 'experiment_type' is required and cannot be missing.")
  }
  experiment_type <- match.arg(experiment_type)

  dir <- paste0("experiments/", experiment_name)

  # Check if experiment_name already exists
  if(dir.exists(dir)){
    stop("A folder with this experiment name already exists. Please choose a unique name for the experiment.")
  } else {
    dir.create(dir)
    dir.create(paste0(dir, "/scripts"))
    dir.create(paste0(dir, "/data"))
  }

  # Copy example data_template file to the data folder
  templatePath <- system.file("codebooks", "data", "data_template.yaml", package = "beFAIR")
  file.copy(templatePath, paste0(dir, "/data/template.yaml"))

  # Initialize the meta list and a descriptions list from the experiment codebook
  meta <- list()
  meta$version="1.0"

  expCodebook <- codebookRead(codebook_name="experiment")$variables

  for (key in names(expCodebook)) {
    meta[[key]] <- NA
  }

  if (experiment_type == "Array") {
    extraCodebook <- codebookRead(codebook_name="experiment_array")$variables

    for (key in names(extraCodebook)) {
      meta[[key]] <- NA
    }

    draftScript(name=experiment_name, pillar="experiments", codebook_name="arraypanel")
    draftScript(name=experiment_name, pillar="experiments", codebook_name="arrayexpression")
  } else if (experiment_type == "Luminex") {
    extraCodebook <- codebookRead(codebook_name="experiment_luminex")$variables

    for (key in names(extraCodebook)) {
      meta[[key]] <- NA
    }

    draftScript(name=experiment_name, pillar="experiments", codebook_name="luminexexpression")
  } else if (experiment_type == "CyTOF") {
    extraCodebook <- codebookRead(codebook_name="experiment_cytof")$variables

    for (key in names(extraCodebook)) {
      meta[[key]] <- NA
    }

    draftScript(name=experiment_name, pillar="experiments", codebook_name="cytofpanel")
    draftScript(name=experiment_name, pillar="experiments", codebook_name="cytofbarcodingscheme")
  } else if (experiment_type == "Aurora") {
    extraCodebook <- codebookRead(codebook_name="experiment_aurora")$variables

    for (key in names(extraCodebook)) {
      meta[[key]] <- NA
    }

    draftScript(name=experiment_name, pillar="experiments", codebook_name="aurorapanel")
    draftScript(name=experiment_name, pillar="experiments", codebook_name="aurorabarcodingscheme")
  } else if (experiment_type == "ELISA") {
    extraCodebook <- codebookRead(codebook_name="experiment_elisa")$variables

    for (key in names(extraCodebook)) {
      meta[[key]] <- NA
    }

    draftScript(name=experiment_name, pillar="experiments", codebook_name="elisa_absorbance")
    draftScript(name=experiment_name, pillar="experiments", codebook_name="elisa_layout")
  } else if (experiment_type == "Olink") {
    extraCodebook <- codebookRead(codebook_name="experiment_olink")$variables

    for (key in names(extraCodebook)) {
      meta[[key]] <- NA
    }

    draftScript(name=experiment_name, pillar="experiments", codebook_name="olinkexpression")
  } else if (experiment_type == "UPLC") {
    extraCodebook <- codebookRead(codebook_name="experiment_UPLC")$variables

    for (key in names(extraCodebook)) {
      meta[[key]] <- NA
    }

    draftScript(name=experiment_name, pillar="experiments", codebook_name="UPLC_layout")
  } else if (experiment_type == "LCMS") {
    extraCodebook <- codebookRead(codebook_name="experiment_LCMS")$variables

    for (key in names(extraCodebook)) {
      meta[[key]] <- NA
    }

    draftScript(name=experiment_name, pillar="experiments", codebook_name="LCMS_layout")
  }

  meta$experiment_id <- .setExperimentId()
  meta$name <- experiment_name
  meta$type <- experiment_type

  # save the meta file
  metaPath <- paste0(dir, "/meta.yaml")
  yaml::write_yaml(meta, metaPath)

  message(
    message(sprintf(
      "Experiment added: %s. Add the additional experiment information to the meta.yaml file located at: %s",
      meta$name,
      metaPath
    )))
}
