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

# barcoding scheme for cytof uses different ids. I include them in id_mapping
dataInfo2 <- yaml::read_yaml(sprintf("studies/%s/data/barcodingscheme_surface.yaml", studyName), eval.expr=TRUE)
files <- list.files(dataInfo2$path, full.names=T)
dataSurface <- data.frame()

for(i in seq_along(files)){
  dataSurface <-  rbind(dataSurface,
    cbind(batch=paste0("S", i),
      read.csv2(list.files(dataInfo2$path, full.names=T)[i], check.names=F)))
}

###
## Data preparation
#

# create wide id mapping dataframe with id given during study (source_id) and a number
originalIdMapping <- study_results %>%
  dplyr::distinct(Participant.Id) %>%
  dplyr::mutate(participant_nr = dplyr::row_number()) %>%
  dplyr::select(
    participant_nr,
    original_id = Participant.Id
  )

surfaceWideMapping <- dataSurface %>%
  dplyr::filter(!startsWith(sample, "ref")) %>%
  mutate(
    surface_id = substr(sample, 1, 4), # remove timepoint (A, B, C)
    original_id = substr(sub("S", "CS1-", sample), 1, 7) # add original source id
  ) %>%
  dplyr::distinct(surface_id, original_id) %>%
  dplyr::select(surface_id, original_id)

wideIdMapping <- originalIdMapping %>%
  dplyr::left_join(surfaceWideMapping, by = "original_id")

idMapping <- wideIdMapping %>%
  tidyr::pivot_longer(
    cols = c(original_id, surface_id),
    names_to = "id_type",
    values_to = "source_id"
  ) %>%
  dplyr::filter(!is.na(source_id)) %>%
  dplyr::select(
    participant_nr,
    source_id
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
