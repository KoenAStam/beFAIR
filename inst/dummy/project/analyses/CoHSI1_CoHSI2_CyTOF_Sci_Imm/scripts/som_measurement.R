###
## Dependencies
#
library(dplyr)

# meta.yaml
analysisFile <- paste0("analyses/CoHSI1_CoHSI2_CyTOF_Sci_imm/meta.yaml")
analysisInfo <- yaml::read_yaml(analysisFile)
analysisName <- analysisInfo$name
analysisID <- analysisInfo$analysis_id

###
## Load raw data
#
dataInfo1 <- yaml::read_yaml(sprintf("analyses/%s/data/cellcounts.yaml", analysisName), eval.expr=TRUE)
rawData <-  read.csv2(dataInfo1$path)

###
## Analysis specific data preparation
#

# # ID is in format S032A (participant + timepoint)
# Timepoint conversion
# A = 0
# B = 28 (4 weeks)
# C = 56 (8 weeks)
# D = 84 (12 weeks) only CHSI2 (female S mansoni)

# TODO we need to find out which samples belonged to CHSI1 and which to CHSI2
data <- rawData %>%
  mutate( 
    # study_id = "CHSI1" "CHSI2"
    source_id = substr(X, 1, 4), # e.g. S020
    timepoint_code =  substr(X, 5, 5), #timepoint letter (A-D)
    timepoint_days = case_when(
      timepoint_code == "A" ~ 0,
      timepoint_code == "B" ~ 28,   # 4 weeks
      timepoint_code == "C" ~ 56,   # 8 weeks
      timepoint_code == "D" ~ 84    # 12 weeks
    )
  ) %>% 
  select(-X, -timepoint_code) %>%
  tidyr::pivot_longer(
    cols = -c(source_id, timepoint_days),
    names_to = "cluster_id",
    values_to = "counts"
  ) %>%
  mutate(cluster_id = sub("^X", "c", cluster_id)) %>% 
  group_by(source_id) %>% 
  mutate(study_id = if_else(any(timepoint_days == 84), "CHSI2", "CHSI1")) %>%
  ungroup()

###
## CODEBOOK
#
dataLength <- nrow(data)
databook <- beFAIR::codebookToEntries("som_measurement", nrow=dataLength)

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
databook$data$timepoint <-  data$timepoint_days

#cluster_id
databook$data$cluster_id <- data$cluster_id

#measurement
databook$data$measurement <- "count"

#value
databook$data$value <- as.numeric(data$counts)

###
## Validate entries
#

databook$validation <- beFAIR::validateDatabook(databook)

###
## Clean environment
#
rm(list = setdiff(ls(), c("databook")))
