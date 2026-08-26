###
## Dependencies
#
library(dplyr)

# meta.yaml
studyFile <- paste0("studies/ReCoHSI/meta.yaml")
studyInfo <- yaml::read_yaml(studyFile)
studyName <- studyInfo$name
studyID <- studyInfo$study_id

### 
## Load raw data
# 
# 

dataInfo1 <- yaml::read_yaml(sprintf("studies/%s/data/screening.yaml", studyName), eval.expr=TRUE)
screening <-  readxl::read_excel(dataInfo1$path, sheet=dataInfo1$sheet, na = c("N/A", "NA"))

###
## Study specific data manipulation
#

#study_results <- study_results %>%
#  dplyr::filter(`Site Abbreviation` == "INCL") #only include INCL, exclude SCR

data <- screening %>%
  dplyr::filter(`Participant Status` != "Not Set") #exculde not set


###
## CODEBOOK  
#
nParticipants <- nrow(data)
databook <- beFAIR::codebookToEntries("participant", nrow=nParticipants)

###
## DATA
#
#source_id 
databook$data$source_id <- data$`Participant Id`

#study_id
databook$data$study_id <- studyID

#study_name
databook$data$study_name <- studyName

#studyarm_id
databook$data$studyarm_id <- sapply(data$`Participant Status`, function(x){
  c(
    "Control" = "control",
    "Intervention" = "reinfection"
   )[x]
}) %>% paste0(studyID, "_", .)


#age
databook$data$age <- as.numeric(data$scr_age)

#sex
# in sheet Field options: male = 0, female = 1
databook$data$sex <- sapply(data$scr_sex, function(x) ifelse(x == 0, "M", "F"))

#ethnicity
databook$data$ethnicity <- NA_character_

#height
databook$data$height <- as.numeric(data$scr_height)

#weight_
databook$data$weight <-  as.numeric(data$scr_weight)

#bmi
databook$data$bmi <- as.numeric(data$scr_bmi)

#residence
databook$data$residence <- "Netherlands"

#site
# https://clinicaltrials.gov/study/NCT05085470 
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

databook$validation <- beFAIR::validateDatabook(databook)

###
## Clean environment
#
rm(list = setdiff(ls(), c("databook")))
