###
## Dependencies
#
studyID <- "RCHSI"

# meta.yaml
studyFile <- paste0("studies/ReCoHSI/meta.yaml")
studyInfo <- yaml::read_yaml(studyFile)
studyName <- studyInfo$name

###
## Study specific data preparation
#

studyarms <- paste0(studyID, "_", c("reinfection", "control"))
  
###
## DATABOOK
#

nEntries <- 2
databook <- beFAIR::codebookToEntries("studyarm", nrow=nEntries)

###
## DATA
#
#studyarm_id
databook$data$studyarm_id <- studyarms

#study_id
databook$data$study_id <- studyID

#studyarm_name
databook$data$studyarm_name <- NA_character_

#studyarm_description
databook$data$studyarm_description <- c(
  "Participants will be exposed three times to 20 male Schistosoma mansoni cercariae (weeks 0, 9, and 18)",
  "Participants who will undergo a placebo mock infection with water twice (weeks 0 and 9) and will be exposed once to 20 male Schistosoma mansoni cercariae (week 18)"
)

###
## Validate entries
#

databook$validation <- beFAIR::validateDatabook(databook)

###
## Clean environment
#
rm(list = setdiff(ls(), c("databook")))
