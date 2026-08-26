###
## Dependencies
#
library(dplyr)

# meta.yaml
studyFile <- paste0("studies/CoHSI1/meta.yaml")
studyInfo <- yaml::read_yaml(studyFile)
studyName <- studyInfo$name
studyID <- studyInfo$study_id

###
## Load raw data
#
dataInfo1 <- yaml::read_yaml(sprintf("studies/%s/data/participant.yaml", studyName), eval.expr=TRUE)
study_results <-  read.csv2(dataInfo1$path)

###
## Study specific data preparation
data <- study_results %>%
  dplyr::filter(!Site.Abbreviation %in% c("scr", "TES")) # exclude scr en test participants

###
## CODEBOOK
#
nParticipants <- nrow(data)
databook <- beFAIR::codebookToEntries("participant", nrow=nParticipants)

###
## DATA
#
#source_id
databook$data$source_id <- data$Participant.Id

#study_id
databook$data$study_id <- studyID

#study_name
databook$data$study_name <- studyName

#studyarm_id
databook$data$studyarm_id <- paste0(studyID, "_", data$`Site Abbreviation`)

#age
databook$data$age <- as.numeric(data$scr_Age)

#sex
sex <- data %>%
  mutate(`Gender` = recode(Gender, '1' = 'M', '2' = 'F'))
databook$data$sex <- sex$`Gender`

#ethnicity
ethnicity <- data %>%
  mutate(`scr_Race` = recode(scr_Race, '1' = 'Caucasian', '2' = 'Black', '3' = 'Asian', '4' = 'Other' ))
databook$data$ethnicity <- ethnicity$`scr_Race`

#height
databook$data$height <- as.numeric(data$scr_Height)

#weight
databook$data$weight <- as.numeric(data$scr_Weight)

#bmi
databook$data$bmi <- as.numeric(data$scr_BMI)

#residence
databook$data$residence <- NA_character_

#site
databook$data$site <- "Leiden University Medical Center"

#reference_date
databook$data$reference_date <- NA_character_

#study_status
databook$data$study_status <- NA_character_

#discontinuation_reason
databook$data$discontinuation_reason <- NA_character_

#discontinuation_timepoint
databook$data$discontinuation_timepoint <- NA_real_

###
## Validate entries
#

# Validate all entries using the codebook
# set validated to a 1 if all validation rules are passed
databook$validation <- beFAIR::validateDatabook(databook)


###
## Clean environment
#
rm(list = setdiff(ls(), c("databook")))

