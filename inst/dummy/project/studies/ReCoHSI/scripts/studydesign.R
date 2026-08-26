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

designData <- data.frame(studyarm_id=rep(paste0(studyID, "_", c("reinfection", "control")), each=6),
                         timepoint=c(0, 56, 63, 119, 126, 210),
                         event_name=c("I1", "T1", "I2", "T2", "I3", "T3")) %>% 
  mutate(
    event_type = case_when(
      timepoint %in% c(0, 63) & studyarm_id == "RCHSI_control" ~ "placebo",
      timepoint %in% c(0, 63) & studyarm_id == "RCHSI_reinfection" ~ "immunization",
      timepoint == 126 ~ "immunization",
      grepl("T", event_name) ~ "treatment"
    ),
    product_name = case_when(
      event_type == "immunization" ~ "male Schistosoma mansoni cercariae",
      event_type == "placebo" ~ "mock exposure",
      event_type == "treatment" ~ "Praziquantel"
    ),
    product_administration = case_when(
      event_type == "treatment" ~ "oral",
      grepl("I", event_name) ~ "skin (forearm)"
    ),
    dose = case_when(
      event_type == "treatment" ~ 60,
      event_type == "immunization" ~ 20
    ),
    dose_unit = case_when(
      event_type == "treatment" ~ "mg/kg",
      event_type == "immunization" ~ "cercariae"
    )
  )

###
## DATABOOK
#

nEntries <- nrow(designData)
databook <- beFAIR::codebookToEntries("studydesign", nrow=nEntries)

###
## DATA
#
#studyarm_id
databook$data$studyarm_id <- designData$studyarm_id

#study_id
databook$data$study_id <- studyID

#timepoint
databook$data$timepoint <- designData$timepoint

#event_type
databook$data$event_type <- designData$event_type

#event_name
databook$data$event_name <- designData$event_name

#product_name
databook$data$product_name <- designData$product_name
  
#product_administration
databook$data$product_administration <- designData$product_administration

#dose
databook$data$dose <- designData$dose

#dose_unit
databook$data$dose_unit <- designData$dose_unit

###
## Validate entries
#

databook$validation <- beFAIR::validateDatabook(databook)

###
## Clean environment
#
rm(list = setdiff(ls(), c("databook")))
