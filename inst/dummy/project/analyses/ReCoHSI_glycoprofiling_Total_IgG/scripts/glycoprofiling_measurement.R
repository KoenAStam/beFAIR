###
## Dependencies
#
library(dplyr)
library(tidyr)
library(stringr)

# meta.yaml
metaFile <- paste0("analyses/ReCoHSI_glycoprofiling_Total_IgG/meta.yaml")
metaInfo <- yaml::read_yaml(metaFile)
analysisID <- metaInfo$analysis_id
analysisName <- metaInfo$name 
studyID <- metaInfo$study_ids

###
## Load raw data
#
dataInfo1 <- yaml::read_yaml(sprintf("analyses/%s/data/processed_data.yaml", analysisName), eval.expr=TRUE)
processedData <- readxl::read_excel(dataInfo1$path, sheet=dataInfo1$sheet)

###
## Data preparation
#

data <- processedData %>%
  select(-IgGI_sum_intensity, -IgGII_sum_intensity, -IgGIV_sum_intensity) %>% 
  pivot_longer(
    cols = matches("^IgG(I|II|IV)(\\d|_)"),
    names_to = "glycan_col",
    values_to = "value"
  ) %>%
  mutate(
    backbone = case_when(
      stringr::str_detect(glycan_col, "^IgGIV(\\d|_)") ~ "IgG4",
      stringr::str_detect(glycan_col, "^IgGII(\\d|_)") ~ "IgG2",
      stringr::str_detect(glycan_col, "^IgGI(\\d|_)")  ~ "IgG1",
      TRUE ~ NA_character_
    ),
    glycan_composition_name = case_when(
      backbone == "IgG1" ~ stringr::str_remove(glycan_col, "^IgGI_?"),
      backbone == "IgG2" ~ stringr::str_remove(glycan_col, "^IgGII_?"),
      backbone == "IgG4" ~ stringr::str_remove(glycan_col, "^IgGIV_?"),
      TRUE ~ NA_character_
    ),
    source_id = case_when(
      grepl("Visucon|PBS", sample_id) ~ "CTRL",
      TRUE ~ stringr::str_remove(sample_id, "-w\\d+$")
    ),
    timepoint_weeks = as.numeric(stringr::str_extract(sample_id, "(?<=-w)\\d+$")),
    timepoint_days = timepoint_weeks * 7,
    study_id = studyID,
    sample_type = "serum"
  )

# TODO[200] what do we do with Vicuson and PBS?

###
## DATABOOK
#

nEntries <- nrow(data)
databook <- beFAIR::codebookToEntries("glycoprofiling_measurement", nrow = nEntries)

###
## DATA
#
#analysis_id
databook$data$analysis_id <- analysisID

#source_id
databook$data$source_id <- data$source_id

#study_id
databook$data$study_id <- data$study_id

#timepoint
databook$data$timepoint <- data$timepoint_days

#sample_type
databook$data$sample_type <- data$sample_type

#glycan_id
databook$data$glycan_id <- data$glycan_composition_name

#backbone
databook$data$backbone <- data$backbone

#signal_to_noise
databook$data$signal_to_noise <- "27" # from lucid-r-n$/Users/Tom_Veldhuizen/Needs to be sorted/LC-MS/ReCoHSI - Total IgG/2023-10-04-1321Z_Summary.xlsx

#final_chosen
databook$data$final_chosen <- "NA_character_"

#glycan_composition_name
databook$data$glycan_composition_name <- data$glycan_composition_name

#intensity
databook$data$intensity <- NA_real_

#relative_abundance
databook$data$relative_abundance <- data$value

###
## Validate entries
#

databook$validation <- beFAIR::validateDatabook(databook)

###
## Clean environment
#
rm(list = setdiff(ls(), c("databook")))
