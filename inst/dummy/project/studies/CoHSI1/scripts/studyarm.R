###
## Dependencies
#
studyID <- "CHSI1"

# meta.yaml
studyFile <- paste0("studies/CoHSI1/meta.yaml")
studyInfo <- yaml::read_yaml(studyFile)
studyName <- studyInfo$name
studyID <- studyInfo$study_id

###
## Load raw data
#

studyArm <- data.frame(
  studyarm_id = c(
    "CHSI1_grA1",
    "CHSI1_grA2",
    "CHSI1_grA3",
    "CHSI1_grB3"
  ),
  studyarm_description = c(
    "One time challenge with 10 Male Schistosoma mansoni cercariae of Puerto Rican strain",
    "One time challenge with 30 Male Schistosoma mansoni cercariae of Puerto Rican strain",
    "One time challenge with 20 Male Schistosoma mansoni cercariae of Puerto Rican strain",
    "One time challenge with 20 Male Schistosoma mansoni cercariae of Puerto Rican strain"
  ),
  stringsAsFactors = FALSE
)
###
## Study specific data preparation
#

###
## DATABOOK
#

nEntries <- nrow(studyArm)
databook <- beFAIR::codebookToEntries("studyarm", nrow=nEntries)

###
## DATA
#
#studyarm_id
databook$data$studyarm_id <- studyArm$studyarm_id

#study_id
databook$data$study_id <- studyID

#studyarm_name
databook$data$studyarm_name <- NA_character_

#studyarm_description
databook$data$studyarm_description <- studyArm$studyarm_description

###
## Validate entries
#

databook$validation <- beFAIR::validateDatabook(databook)


###
## Clean environment
#
rm(list = setdiff(ls(), c("databook")))
