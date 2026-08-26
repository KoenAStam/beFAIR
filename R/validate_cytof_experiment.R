#' Validate a CyTOF experiment
#'
#' Performs a series of checks for a CyTOF experiment: verifies that the
#' experiment, panel, and barcoding scheme tables exist in the database; checks
#' FCS file structure and folder layout (`raw/`, `raw_processed/`); compares
#' panel channel IDs against the FCS file parameters; and verifies that all
#' barcoding scheme `event_id` values are linked to known participants.
#'
#' @param experimentID Character. The experiment ID to validate (e.g.
#'   `"EG12345"`).
#' @param con A DBI connection. If `NULL`, the default connection set by [FAIRgroundConnect()] is used.
#'
#' @return Invisibly returns `NULL`. Results are printed to the console with
#'   `[OK]`, `[WARNING]`, and `[ERROR]` prefixes.
#' @seealso [addExperiment()], [FAIRgroundConnect()]
#' @import dplyr
#' @examples
#' \dontrun{
#'   validateCytofExperiment("EG12345")
#' }
#' @export

validateCytofExperiment <- function(experimentID, con=NULL) {

  cat("\n\n ### CHECKING DATATABLES FROM DATABASE  ###\n\n")

  con <- FAIRgroundConnection(con)

  experiment <- DBI::dbGetQuery(con, "SELECT * FROM experiment") %>%
    dplyr::filter(experiment_id == experimentID)

  panel <- DBI::dbGetQuery(con, "SELECT * FROM cytofpanel") %>%
    dplyr::filter(experiment_id == experimentID)

  barcodingScheme <- DBI::dbGetQuery(con, "SELECT * FROM cytofbarcodingscheme") %>%
    dplyr::filter(experiment_id == experimentID)

  participant <- DBI::dbGetQuery(con, "SELECT * FROM participant")

  if (nrow(experiment) == 0) {
    cat("Experiment", experimentID, "does not exist.\n")
  } else {
    if (experiment$type == "CyTOF") {
      cat("[OK] Experiment found:", experiment$name, "(type: CyTOF)\n")
    } else {
      stop(experiment$name, " is not a CyTOF experiment.\n")
    }

    if (nrow(panel) == 0) {
      cat("[ERROR] No panel data found for this experiment.\n")
    } else {
      cat("[OK] Panel data found (", nrow(panel), "rows).\n")
    }

    if (nrow(barcodingScheme) == 0) {
      cat("[ERROR] No barcoding scheme found for this experiment.\n")
    } else {
      cat("[OK] Barcoding scheme found (", nrow(barcodingScheme), "samples).\n")
    }
  }


  cat("\n\n ### CHECKING FCS FILES...  ###\n\n")

  protocolFilePath <- experiment$location_protocol

  if (file.exists(protocolFilePath)) {
    cat("[OK] Protocol file exists. \n")
    fileInfo <- file.info(protocolFilePath)
  } else {
    cat("[ERROR] Protocol file does NOT exist at:", protocolFilePath, "\n")
  }

  fcsDir <- experiment$location_data

  if (dir.exists(fcsDir)) {
    cat("[OK] FCS dir exists. \n")

    fcsFilePaths <- list.files(
      path = fcsDir,
      pattern = "\\.fcs$|\\.FCS$",
      full.names = TRUE,
      recursive = TRUE
    )
    lmdFilePaths <- list.files(
      path = fcsDir,
      pattern = "\\.lmd$",
      full.names = TRUE,
      recursive = TRUE
    )

    numFcsFiles <- length(fcsFilePaths)
    numlmdFiles <- length(lmdFilePaths)
    cat(numFcsFiles, "FCS files found. \n")
    cat(numlmdFiles, "lmd files found. \n")

  } else {
    cat("[ERROR] FCS directory does NOT exist at:", fcsDir, "\n")
  }


  cat("\n\n ### CHECKING FCS FOLDER STRUCTURE... ###")

  rawFcsFiles <- fcsFilePaths[grepl("/raw/", fcsFilePaths)]
  rawLmdFiles <- lmdFilePaths[grepl("/raw/", lmdFilePaths)]
  processedFcsFiles <- fcsFilePaths[grepl("/raw_processed/", fcsFilePaths)]
  otherFiles <- fcsFilePaths[!(grepl("/raw/", fcsFilePaths) |
      grepl("/raw_processed/", fcsFilePaths))]

  numRawFiles <- length(rawFcsFiles) + length(rawLmdFiles)
  numProcessedFiles <- length(processedFcsFiles)
  numotherFiles <- length(otherFiles)

  cat("\n Number of FCS/LMD files in raw folder: ", numRawFiles)
  cat("\n Number of FCS files in raw_processed folder: ", numProcessedFiles)
  cat("\n Number of FCS files in other folders: ", numotherFiles)

  if(numRawFiles == numProcessedFiles) {
    cat("\n [OK] The number of FCS/LMD files in the 'raw' folder matches the number of FCS files in the 'raw_processed' folder.\n")
  } else {
    cat("\n [WARNING] The number of FCS/LMD files in the 'raw' folder DOES NOT match the number of FCS files in the 'raw_processed' folder.\n")
  }


  cat("\n\n ### CHECKING FCS FOLDER BATCH NAMES IN RAW PROCESSED...  ###")

  batchNamesFCS <- list.files(paste0(fcsDir, "/raw_processed"))
  batchNamesBarcoding <- unique(barcodingScheme$batch_id)

  sortedbatchNamesFCS <- sort(batchNamesFCS)
  sortedbatchNamesBarcoding <- sort(batchNamesBarcoding)

  if (identical(sortedbatchNamesFCS, sortedbatchNamesBarcoding)) {
    cat("\n [OK] All batch names match between FCS files and barcodingscheme\n")
  } else {
    inFCSnotBarcoding <- setdiff(sortedbatchNamesFCS, sortedbatchNamesBarcoding)
    inBarcodingNotFCS <- setdiff(sortedbatchNamesBarcoding, sortedbatchNamesFCS)

    if (length(inFCSnotBarcoding) > 0) {
      cat("\n [ERROR] These batch names appear in FCS files but NOT in the barcodingscheme:\n")
      cat(paste0("- ", inFCSnotBarcoding), sep = "\n")
    }
    if (length(inBarcodingNotFCS) > 0) {
      cat("\n [ERROR] These batch names appear in the barcoding but NOT in FCS files:\n")
      cat(paste0("- ", inBarcodingNotFCS), sep = "\n")
    }
  }


  cat("\n\n ### COMPARING CHANNEL_ID WITH CHANNEL_ID_FCS IN PANEL...  ###")
  mismatchChannelPanel <- panel[panel$channel_id != panel$channel_id_fcs, c("channel_id", "channel_id_fcs", "target_name", "notes")]

  if (nrow(mismatchChannelPanel) > 0) {
    cat("\n [WARNING] The following rows in your panel have a mismatch between 'channel_id' and 'channel_id_fcs':\n\n")
    print(mismatchChannelPanel, row.names = FALSE)
    cat("\n Please verify whether a note is added to explain the discrepancy.\n")
  } else {
    cat("\n [OK] All 'channel_id' and 'channel_id_fcs' pairs match within the panel.\n")
  }


  cat("\n\n ### COMPARING CHANNEL_ID_FCS WITH MARKER NAMES IN FCS...  ###")

  fcsFilePath <- fcsFilePaths[1] #Use the first FCS file

  x <- flowCore::read.FCS(fcsFilePath, which.lines=100, emptyValue = FALSE)
  fcsPanel <- x@parameters@data

  mismatchChannel <- panel[!(panel$channel_id_fcs %in% fcsPanel$name), c("channel_id", "channel_id_fcs", "notes")]

  if (nrow(mismatchChannel) > 0) {
    cat("\n [ERROR] There are mismatches between your panel and the FCS file parameters.\n")
    cat("\n The following channels in your panel (column 'channel_id_fcs') do NOT match any channel name in the FCS file:\n\n")
    print(mismatchChannel, row.names = FALSE)
    cat("\n Please check your panel and the FCS file for consistency.\n")
  } else {
    cat("\n [OK] All 'channel_id_fcs' entries in the panel match those in the FCS file. \n")
  }



  # target name harmonization
  dfTargetName <- data.frame(
    target_name = panel$target_name,
    target_name_harmonized = suppressMessages(harmonizeMarkers(panel$target_name)),
    stringsAsFactors = FALSE
  )


  cat("\n\n ### CHECKING HARMONIZATION...  ###")

  if (all(dfTargetName$original == dfTargetName$harmonized)) {
    cat("\n [OK] All target names are harmonized.\n")
  } else {
    cat("\n [ERROR] Not all target names are harmonized. See differences below:\n")
    print(dfTargetName[dfTargetName$target_name != dfTargetName$target_name_harmonized, ], row.names = FALSE)
  }


  cat("\n\n ### CHECKING BARCODINGSCHEME EVENT_IDS... ###")

  # Check if the participants exist in the participant table)
  validEventIDFormat <- grepl("^\\w+_\\w+_\\w+$", barcodingScheme$event_id)

  if (any(!validEventIDFormat)) {
    cat("\n [WARNING] Some event_id values do not match the expected format. This may be expected for reference samples. Please check if these are reference IDs: ")
    print(barcodingScheme$event_id[!validEventIDFormat])
  }
  # check if the reference samples are unique.
  participantIDs <- rep(NA, length(barcodingScheme$event_id))

  participantIDs[validEventIDFormat] <- sapply(
    strsplit(barcodingScheme$event_id[validEventIDFormat], "_"),
    function(x) paste(x[1], x[2], sep = "_")
  )

  if (any(validEventIDFormat)) {
    matches <- participantIDs %in% participant$participant_id
    nonMatchingEventIDs <- barcodingScheme$event_id[!matches & !is.na(participantIDs)]

    if (length(nonMatchingEventIDs) > 0) {
      cat("\n [ERROR] The following event_ids do NOT match any participant:\n")
      print(nonMatchingEventIDs)
    } else {
      cat("\n [OK] All event_ids match a participant ID.")
    }
  } else {
    cat("\n [ERROR] No valid event_id values found to match against participants.")
  }
}

