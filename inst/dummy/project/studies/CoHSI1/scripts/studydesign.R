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

studyArm <- c(
  "CHSI1_grA1",
  "CHSI1_grA2",
  "CHSI1_grA3",
  "CHSI1_grB3"
)
timepoints <- c(0, 84)

###
## Study specific data preparation
#

studyDesign <- expand.grid(
  studyarm_id = studyArm,
  timepoint   = timepoints,
  KEEP.OUT.ATTRS = FALSE,
  stringsAsFactors = FALSE
) %>%
  arrange(studyarm_id, timepoint)

#TODO add treatment
studyDesign <- studyDesign %>%
  mutate(
    event_type = case_when(
      timepoint == 0 ~ "challenge",

      # https://www.science.org/doi/epdf/10.1126/sciimmunol.adl1965 study design: week 12
      timepoint == 84 ~ "treatment", # one day at week 12
      TRUE ~ NA_character_
    ),

    event_name = case_when(
      event_type == "challenge" ~ "C1",
      event_type == "treatment" ~ "T1",
      TRUE ~ NA_character_
    ),

    product_name = case_when(
      event_type == "challenge" ~ "Male Schistosoma mansoni cercariae Puerto Rican strain",
      event_type == "treatment" ~ "Praziquantel",

      TRUE ~ NA_character_
    ),

    product_administration = case_when(
      event_type == "challenge"    ~ "Percutaneous",
      event_type == "treatment"    ~ "Oral",

      TRUE ~ NA_character_
    ),

    dose = case_when(
      event_type == "challenge" & studyarm_id == "CHSI1_grA1" ~ 10,
      event_type == "challenge" & studyarm_id == "CHSI1_grA2" ~ 30,
      event_type == "challenge" & studyarm_id == "CHSI1_grA3" ~ 20,
      event_type == "challenge" & studyarm_id == "CHSI1_grB3" ~ 20,
      event_type == "treatment" ~ 40,
      TRUE ~ NA_real_
    ),

    dose_unit = case_when(
      event_type == "challenge"    ~ "cercariae",
      event_type == "treatment"    ~ "mg/kg",
      TRUE ~ NA_character_
    )
  )  %>%
  filter(!is.na(event_type))


###
## DATABOOK
#
nEntries <- nrow(studyDesign)
databook <- beFAIR::codebookToEntries("studydesign", nrow=nEntries)

###
## DATA
#
#studyarm_id
databook$data$studyarm_id <- studyDesign$studyarm_id

#study_id
databook$data$study_id <- studyID

#timepoint
databook$data$timepoint <- studyDesign$timepoint

#event_type
databook$data$event_type <- studyDesign$event_type

#event_name
databook$data$event_name <-  studyDesign$event_name

#product_name
databook$data$product_name <- studyDesign$product_name

#product_administration
databook$data$product_administration <- studyDesign$product_administration

#dose
databook$data$dose <- studyDesign$dose

#dose_unit
databook$data$dose_unit <- studyDesign$dose_unit

###
## Validate entries
#

databook$validation <- beFAIR::validateDatabook(databook)


###
## Clean environment
#
rm(list = setdiff(ls(), c("databook")))
