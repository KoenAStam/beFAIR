###
## Dependencies
#
library(dplyr)

studyID <- "RCHSI"

# meta.yaml
studyFile <- paste0("studies/ReCoHSI/meta.yaml")
studyInfo <- yaml::read_yaml(studyFile)
studyName <- studyInfo$name

### 
## Load raw data
# 

# get study source ids
dataInfo1 <- yaml::read_yaml(sprintf("studies/%s/data/screening.yaml", studyName), eval.expr=TRUE)
screening <-  readxl::read_excel(dataInfo1$path, sheet=dataInfo1$sheet, na = c("N/A", "NA"))

###
## Data preparation
# 
idMapping <- screening %>% 
  dplyr::mutate(
    participant_nr = dplyr::row_number()
  ) %>%
  dplyr::select(
    participant_nr,
    source_id = `Participant Id`
  )

###
## CODEBOOK  
#
nrows <- nrow(idMapping)
databook <- beFAIR::codebookToEntries("id_mapping", nrow=nrows)

###
## DATA
#
#participant_nr
databook$data$participant_nr <- idMapping$participant_nr

#source_id
databook$data$source_id <- idMapping$source_id

#study_id
databook$data$study_id <- studyID

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

