###
## Dependencies
#
library(tidyr)
library(dplyr)

# meta.yaml
experimentFile <- paste0("experiments/ReCoHSI_Olink_innateStim/meta.yaml")
experimentInfo <- yaml::read_yaml(experimentFile)
experimentName <- experimentInfo$name
experimentID <- experimentInfo$experiment_id

###
## Load raw data
#
dataInfo <- yaml::read_yaml(sprintf("experiments/%s/data/expression.yaml", experimentName), eval.expr=TRUE)
expression <- read.csv2(dataInfo$path)

###
## Experiment specific data preparation
#
# TODO check if the warning from separate() gets correctly registerd in lgr
expressionPrep <- expression %>% 
  separate(SampleID, sep =  ' ', into = c('stim', 'original_id', 'week'), remove = FALSE) %>%
  mutate(source_id = case_when(is.na(original_id) ~ NA,
    .default = paste0('RC-', original_id)),
    timepoint = as.numeric(gsub("wk", "", week)) * 7,
    stim = case_when(is.na(week) ~ NA,
      .default = stim)) %>%
  filter(!is.na(original_id)) # TODO Add exceptions to checkSourceIDexist so it can handle internal sample controls like here


###
## CODEBOOK
#
# read experiment codebook and create empty data frame with codebook info
dataLength <- nrow(expressionPrep)
databook <- beFAIR::codebookToEntries("olinkexpression", nrow=dataLength)

###
## DATA
#
#experiment_id
databook$data$experiment_id <- experimentID

#source_id
databook$data$source_id <- expressionPrep$source_id

#study_id
databook$data$study_id <- experimentInfo$study_ids

#timepoint
databook$data$timepoint <- expressionPrep$timepoint

#target_id
databook$data$target_id <- expressionPrep$Assay

#npx
databook$data$npx <-  as.numeric(expressionPrep$NPX)

#condition - 
databook$data$condition <- expressionPrep$stim

###
## Validate entries
#

databook$validation <- beFAIR::validateDatabook(databook)

###
## Clean environment
#
rm(list = setdiff(ls(), c("databook")))
