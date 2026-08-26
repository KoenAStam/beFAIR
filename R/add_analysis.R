#' Add an analysis to the FAIRground
#'
#' Creates an analysis directory structure under `analyses/`, writes a
#' `meta.yaml` initialised from the base `analysis` codebook and a
#' type-specific codebook, copies a data template, and drafts the standard
#' ETL scripts for the selected analysis type.
#'
#' @param analysis_name A character string specifying the name of the analysis.
#'   Typically composed of the study name, analysis type, and a descriptor,
#'   separated by underscores (e.g. `"CoHSI1_SOM_surface"`).
#' @param analysis_type A character string specifying the scientific type of
#'   the analysis. Must be one of `"SOM"`, `"OMIQ"`, `"ELISA"`, `"Array"`,
#'   `"Luminex"`, `"Glycoprofiling"`, or `"Custom"` if only custom codebooks
#'   are used.
#'
#' @return Called for its side effects. Creates the analysis directory and
#'   subdirectories (`scripts/`, `data/`), writes `meta.yaml`, copies a data
#'   template, and drafts scripts.
#'
#' @seealso [addStudy()], [addExperiment()], [draftScript()]
#'
#' @examples
#' \dontrun{
#' addAnalysis("CHHIL_CyTOF_SOM_exvivo", "SOM")
#' addAnalysis("ReCHHI1_ELISA_IgE", "ELISA")
#' }
#'
#' @export
addAnalysis <- function(analysis_name, analysis_type) {

  # Ensure analysis_type is selected from the provided options
  if (!is.na(analysis_type)) {
    analysis_type <- match.arg(
      analysis_type,
      choices = c("SOM", "OMIQ", "ELISA", "Array", "Luminex", "Glycoprofiling",
                  "Custom")
    )
  }

  dir <- paste0("analyses/", analysis_name)

  # Check if analysis_name already exists
  if (dir.exists(dir)) {
    stop(
      "A folder with this analysis name already exists. Please choose a unique name for the analysis."
    )
  } else {
    dir.create(dir)
    dir.create(paste0(dir, "/scripts"))
    dir.create(paste0(dir, "/data"))
    # Copy example data_template file to the data folder
    templatePath <- system.file("codebooks", "data", "data_template.yaml", package = "beFAIR")
    file.copy(templatePath, paste0(dir, "/data/template.yaml"))
  }

  # Initialize the meta list from the base analysis codebook
  meta <- list()

  analysisCodebook <- codebookRead(codebook_name = "analysis")$variables
  for (key in names(analysisCodebook)) {
    meta[[key]] <- NA
  }

  meta$version <- "1.0"

  # Draft ETL scripts and load type-specific codebook fields
  if (analysis_type == "SOM") {
    extraCodebook <- codebookRead(codebook_name = "analysis_som")$variables
    for (key in names(extraCodebook)) meta[[key]] <- NA

    draftScript(name = analysis_name, pillar = "analyses",
                codebook_name = "som_clusterphenotype")
    draftScript(name = analysis_name, pillar = "analyses",
                codebook_name = "som_measurement")

  } else if (analysis_type == "OMIQ") {
    extraCodebook <- codebookRead(codebook_name = "analysis_omiq")$variables
    for (key in names(extraCodebook)) meta[[key]] <- NA

    draftScript(name = analysis_name, pillar = "analyses",
                codebook_name = "omiq_gatingphenotype")
    draftScript(name = analysis_name, pillar = "analyses",
                codebook_name = "omiq_measurement")

  } else if (analysis_type == "ELISA") {
    extraCodebook <- codebookRead(codebook_name = "analysis_elisa")$variables
    for (key in names(extraCodebook)) meta[[key]] <- NA

    draftScript(name = analysis_name, pillar = "analyses",
                codebook_name = "elisa_result")

  } else if (analysis_type == "Array") {
    extraCodebook <- codebookRead(codebook_name = "analysis_array")$variables
    for (key in names(extraCodebook)) meta[[key]] <- NA

    draftScript(name = analysis_name, pillar = "analyses",
                codebook_name = "array_measurement")

  } else if (analysis_type == "Luminex") {
    extraCodebook <- codebookRead(codebook_name = "analysis_luminex")$variables
    for (key in names(extraCodebook)) meta[[key]] <- NA

    draftScript(name = analysis_name, pillar = "analyses",
                codebook_name = "luminex_measurement")

  } else if (analysis_type == "Glycoprofiling") {
    extraCodebook <- codebookRead(codebook_name = "analysis_glycoprofiling")$variables
    for (key in names(extraCodebook)) meta[[key]] <- NA

    draftScript(name = analysis_name, pillar = "analyses",
                codebook_name = "glycoprofiling_measurement")
  }

  meta$analysis_id  <- .setAnalysisId()
  meta$name         <- analysis_name
  meta$type         <- analysis_type

  # save the meta file
  metaPath <- paste0(dir, "/meta.yaml")
  yaml::write_yaml(meta, metaPath)

  message(message(
    sprintf(
      "Analysis added: %s. Add the additional analysis information to the meta.yaml file located at: %s",
      meta$name,
      metaPath
    )
  ))
}
