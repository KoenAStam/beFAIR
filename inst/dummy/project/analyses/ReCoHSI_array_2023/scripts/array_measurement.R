###
## Dependencies
#


# meta.yaml
analysisFile <- paste0("analyses/ReCoHSI_array_2023/meta.yaml")
analysisInfo <- yaml::read_yaml(analysisFile)
analysisName <- analysisInfo$name
analysisID <- analysisInfo$analysis_id
studyID <- "RCHSI"

###
## Load raw data
#

# quick fix: get the data with source_ids (very slow fix)
experimentEnv <- new.env()
experimentEnv$con <- FAIRpoint::FAIRpointConnection(con)
source("experiments/ReCoHSI_array_2023/scripts/arrayexpression.R", local = experimentEnv)
arraydata <- experimentEnv$databook$data
# we need to pass the connection for the validation?

#TODO [200] Get the data from the database and fix that we don't have the source_ids
# arraydata <- DBI::dbReadTable(con, "arrayexpression") %>% filter(experiment_id == "E2b852c") # ReCoHSI expression

###
## Analysis specific data preparation
#
data <- arraydata %>%
  # remove flagged data
  dplyr::filter((flags==0)|(flags==-50)) %>% 
  
  # set fluorescence <150 to 150
  mutate(fi_f_minus_b_median_cor = pmax(fi_f_minus_b_median, 150)) %>% 
  
  # calculate the average fluorescence intensity per target_id, source_id, timepoint, antibody, and block for "test" data
  dplyr::filter(test_type == "test") %>%
  group_by(target_id, source_id, timepoint, block, wavelength_name) %>%
  summarise(average_fi = mean(as.numeric(fi_f_minus_b_median_cor), na.rm = TRUE)) %>%
  
  # calculate the median blank fluorescence intensity per source_id, timepoint, per block, per wavelength (for "blank" data)
  left_join(
    arraydata %>%
      dplyr::filter(test_type == "blank") %>%
      group_by(source_id, timepoint, block, wavelength_name) %>%
      summarise(blank_fi = median(as.numeric(fi_f_minus_b_median), na.rm = TRUE)),
    by = c("source_id", "timepoint", "block", "wavelength_name")  # Join by source_id, timepoint, and block to add the blank_fi to the data
  ) %>%
  
  # subtract the blank fluorescence intensity from the measured fluorescence intensity
  mutate(minus_blanks = average_fi - blank_fi) %>%
  
  # make sure any negative values are set to 0
  mutate(final_fi = pmax(minus_blanks, 0))  # pmax sets negative values to 0

###
## CODEBOOK
#
dataLength <- nrow(data)
databook <- beFAIR::codebookToEntries("array_measurement", nrow=dataLength)

###
## DATA
#
#analysis_id
databook$data$analysis_id <- analysisID

#source_id
databook$data$source_id <- data$source_id

#study_id
databook$data$study_id <- studyID

#timepoint
databook$data$timepoint <- as.numeric(data$timepoint)

#wavelength_name
databook$data$wavelength_name <- data$wavelength_name

#target_id
databook$data$target_id <- data$target_id

#fluorescence_intensity
databook$data$fluorescence_intensity <- data$final_fi

###
## Validate entries
#

databook$validation <- beFAIR::validateDatabook(databook)

###
## Clean environment
#
rm(list = setdiff(ls(), c("databook")))
