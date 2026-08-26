###
## Dependencies
#
library(dplyr)
library(tidyr)

# meta.yaml
metaFile <- paste0("experiments/ReCoHSI_LCMS_Total_IgG/meta.yaml")
metaInfo <- yaml::read_yaml(metaFile)
experimentID <- metaInfo$experiment_id
experimentName <- metaInfo$name
studyID <- metaInfo$study_ids


###
## Load raw data
#

dataInfo1 <- yaml::read_yaml(sprintf("experiments/%s/data/plate_layout.yaml", experimentName), eval.expr=TRUE)
plate1 <- readxl::read_excel(dataInfo1$path, range = "E4:Q12")
plate2 <- readxl::read_excel(dataInfo1$path, range = "E26:Q34")

###
## Data preparation
#

makePlateLong <- function(df, plate_id) {
  names(df)[1] <- "plate_row"
  
  df %>%
    mutate(plate_row = as.character(plate_row)) %>%
    pivot_longer(
      cols = -plate_row,
      names_to = "plate_col",
      values_to = "raw_id"
    ) %>%
    mutate(
      plate_id = plate_id,
      plate_col = as.numeric(plate_col),
      well_id = paste0(plate_row, plate_col),
      raw_id = as.character(raw_id),
      
      test_type = case_when(
        stringr::str_detect(raw_id, "^RC-") ~ "test",
        stringr::str_detect(raw_id, "PBS") ~ "blank",
        # TODO [200] check if Visucon is control
        stringr::str_detect(raw_id, stringr::regex("Visucon", ignore_case = TRUE)) ~ "control", 
        TRUE ~ NA_character_
      ),
      
      source_id = case_when(
        test_type == "test"  ~ stringr::str_remove(raw_id, "-w\\d+$"),
        test_type == "blank" ~ "BLANK",
        test_type == "control"  ~ "CTRL",
        TRUE ~ NA_character_
      ),
      timepoint_weeks = as.numeric(stringr::str_extract(raw_id, "(?<=-w)\\d+$")),
      timepoint_days = timepoint_weeks * 7
    )
}

data <- bind_rows(
  makePlateLong(plate1, "plate1"),
  makePlateLong(plate2, "plate2")
)

###
## DATABOOK
#

nEntries <- nrow(data)
databook <- beFAIR::codebookToEntries("LCMS_layout", nrow = nEntries)

###
## DATA
#
#experiment_id
databook$data$experiment_id <- experimentID

#plate_id
databook$data$plate_id <- data$plate_id

#plate_row
databook$data$plate_row <- data$plate_row

#plate_col
databook$data$plate_col <- data$plate_col

#well_id
databook$data$well_id <- data$well_id

#file_name
databook$data$file_name <- NA_character_ 

#source_id
databook$data$source_id <- data$source_id

#study_id
databook$data$study_id <- studyID

#timepoint
databook$data$timepoint <- data$timepoint_days

#test_type
databook$data$test_type <- data$test_type

###
## Validate entries
#

databook$validation <- beFAIR::validateDatabook(databook)

###
## Clean environment
#
rm(list = setdiff(ls(), c("databook")))
