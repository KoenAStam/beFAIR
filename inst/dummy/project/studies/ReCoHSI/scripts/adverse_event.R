###
## Dependencies
#
library(dplyr)

# meta.yaml
studyFile <- sprintf("studies/%s/meta.yaml", "ReCoHSI")
studyInfo <- yaml::read_yaml(studyFile)
studyName <- studyInfo$name
studyID <- studyInfo$study_id 

### 
## Load raw data
#
dataInfo1 <- yaml::read_yaml(sprintf("studies/%s/data/AE.yaml", studyName), eval.expr=TRUE)
adverse_events <-  readxl::read_excel(dataInfo1$path, sheet=dataInfo1$sheet, na = c("N/A", "NA"), col_types = "text")

###
## Study specific data preparation
#

adverse_events <- adverse_events %>% 
  mutate(
    timepoint = readr::parse_number(ae_visit) * 7,
    AE_onset = as.Date(ae_onset_date, format = "%d-%m-%Y"),
    AE_end   = as.Date(ae_end_date,   format = "%d-%m-%Y")
  ) %>% 
  arrange(`Participant Id`, AE_onset) %>% 
  mutate(
    adverse_event_id = paste0(studyID, "_AE", sprintf("%04d", row_number()))
  )

###
## CODEBOOK  
#
databook <- beFAIR::codebookToEntries("adverse_event", nrow=nrow(adverse_events))

###
## DATA
#
# adverse_event_id
databook$data$adverse_event_id  <- adverse_events$adverse_event_id

# source_id
databook$data$source_id <- adverse_events$`Participant Id`

# study_id
databook$data$study_id <- studyID

#description
databook$data$description <- adverse_events$ae_description

#clinical_condition_code
databook$data$clinical_condition_code <- adverse_events$ae_icd10

#code_classification_system
databook$data$code_classification_system <- "ICD-10"

#location
databook$data$location <- NA_character_

#severity
databook$data$severity <- as.character(adverse_events$ae_severity)

#serious
databook$data$serious <- as.character(adverse_events$ae_sae)

#relation
databook$data$relation <- as.character(adverse_events$ae_relation)

#additional_treatment_given
databook$data$additional_treatment_given <- as.character(adverse_events$ae_treatment)

#additional_treatment_name
databook$data$additional_treatment_name <- NA_character_

#start_date
databook$data$start_date <- as.character(adverse_events$AE_onset) 

#end_date
databook$data$end_date <- as.character(adverse_events$AE_end)

#start_timepoint
databook$data$start_timepoint <- NA_real_

#end_timepoint
databook$data$end_timepoint <- NA_real_

#registration_timepoint
databook$data$registration_timepoint <- adverse_events$timepoint

###
## Validate entries
#

databook$validation <- beFAIR::validateDatabook(databook)

###
## Clean environment
#
rm(list = setdiff(ls(), c("databook")))
