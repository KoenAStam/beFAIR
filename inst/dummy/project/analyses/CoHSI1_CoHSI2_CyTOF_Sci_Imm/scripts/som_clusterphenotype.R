###
## Dependencies
#
library(dplyr)

# meta.yaml
analysisFile <- paste0("analyses/CoHSI1_CoHSI2_CyTOF_Sci_Imm/meta.yaml")
analysisInfo <- yaml::read_yaml(analysisFile)
analysisName <- analysisInfo$name
analysisID <- analysisInfo$analysis_id

###
## Load raw data
#
dataInfo1 <- yaml::read_yaml(sprintf("analyses/%s/data/phenotype.yaml", analysisName), eval.expr=TRUE)
dataList <-  readRDS(dataInfo1$path)

###
## Analysis specific data preparation
#
# check markers that should be renamed

# Convert phenotype matrix to long format
phenotypeLong <- dataList$phenotype_table %>%
  as.data.frame() %>%
  rename("CD335" = "NCR1") %>% 
  tibble::rownames_to_column(var = "cluster_id") %>%
  tidyr::pivot_longer(
    cols = -cluster_id,
    names_to = "marker_name",
    values_to = "value"
  ) %>%
  dplyr::mutate(measurement = "phenotype") %>% 
  dplyr::mutate(cluster_id = paste0("c", cluster_id))

# Rename NCR1 in the list before processing
marker_quantiles_renamed <- dataList$marker_quantiles
names(marker_quantiles_renamed) <- recode(names(marker_quantiles_renamed), "NCR1" = "CD335")

# Reshape quantiles to long format with marker names
quantilesLong <- purrr::imap_dfr(
  marker_quantiles_renamed,
  ~ .x %>%
    as.data.frame() %>%
    tibble::rownames_to_column(var = "measurement") %>%
    tidyr::pivot_longer(
      cols = -measurement,
      names_to = "cluster_id",
      values_to = "value"
    ) %>%
    mutate(
      cluster_id = paste0("c", cluster_id),
      marker_name = .y,
      measurement = recode(
        measurement,
        `50%` = "median",
        `80%` = "ptile_80",
        `95%` = "ptile_95"
      )
    ) %>%
    dplyr::filter(measurement %in% c("median", "ptile_80", "ptile_95"))
)

data <- bind_rows(phenotypeLong, quantilesLong)

###
## CODEBOOK
#
dataLength <- nrow(data)
databook <- beFAIR::codebookToEntries("som_clusterphenotype", nrow=dataLength)

###
## DATA
#
#analysis_id
databook$data$analysis_id <- analysisID

#cluster_id
databook$data$cluster_id <- data$cluster_id

#marker_name
databook$data$marker_name <- data$marker_name

#measurement
databook$data$measurement <- data$measurement

#value
databook$data$value <- data$value

###
## Validate entries
#

databook$validation <- beFAIR::validateDatabook(databook)

###
## Clean environment
#
rm(list = setdiff(ls(), c("databook")))
