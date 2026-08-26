###
## Dependencies
#
library(tidyr)
library(dplyr)

# meta.yaml
experimentFile <- paste0("experiments/ReCoHSI_array_2023/meta.yaml")
experimentInfo <- yaml::read_yaml(experimentFile)
experimentName <- experimentInfo$name
experimentID <- experimentInfo$experiment_id
studyID <- experimentInfo$study_ids

###
## Load raw data
#

# excel file with overview of array
dataInfo <- yaml::read_yaml(sprintf("experiments/%s/data/overview.yaml", experimentName), eval.exp=TRUE)
overview <- readxl::read_excel(dataInfo$path)

dataPath <- yaml::read_yaml(sprintf("experiments/%s/data/raw_data.yaml", experimentName), eval.exp=TRUE)$path

###
## Experiment specific data preparation
#

# Read each slide data and bind together
uniqueFilePaths <- unique(overview$file_path)
mergedSlideData <- data.frame()
for (filePath in uniqueFilePaths) {
  tryCatch({
    fullFillPath <- paste0(dataPath, "/", filePath)
    # For slides with longer metadata (e.g., 2023.05.30 Slide #1), the table starts 
    # after 'ArrayerSoftwareVersion', while others start after 'Supplier'
    lines <- readLines(fullFillPath, n = 40) # read the meta data
    
    if (any(grepl("ArrayerSoftwareVersion", lines))) {
      skipLines <- grep("ArrayerSoftwareVersion", lines)
    } else if (any(grepl("Supplier", lines))) {
      skipLines <- grep("Supplier", lines)
    } else {
      warning(paste("No recognizable metadata in file:", fullFillPath))
    }
    
    data <- read.table(
      paste0(fullFillPath),
      sep = "\t",
      header = TRUE,
      quote = "\"",
      stringsAsFactors = FALSE,
      fill = TRUE,
      skip = skipLines, # skip metadata, start with data table
      colClasses = "character"  # set all columns to character preventing bind errors
    )
    data$file_path <- filePath # Store with file name as key, to keep this information
    
    # Fix the discrepancy between column names: replace 633 with 635
    colnames(data) <- gsub('635', '633', colnames(data))
    
    mergedSlideData <- bind_rows(mergedSlideData, data)
    
  }, error = function(e) {
    print(paste("error in file", filePath,":", e))
  })
}

# Expand block ranges in overview,(e.g., "29:32" to 29, 30, 31, 32)
overviewLong <- overview %>%
  mutate(block = lapply(strsplit(blocks, ":"), function(x) seq(as.numeric(x[1]), as.numeric(x[2])))) %>%
  unnest(cols = c(block)) %>% 
  mutate(block = as.character(block)) 

# Perform the join between the overview and the raw data
data <- left_join(overviewLong, mergedSlideData, by = c("file_path" = "file_path", "block" = "Block"))

data$source_id <- data$participant
data$timepoint_in_days <- data$timepoint * 7
data$study_id <- studyID

###
## CODEBOOK
#
# read experiment codebook and create empty data frame with codebook info
dataLength <- nrow(data)
databook <- beFAIR::codebookToEntries("arrayexpression", nrow=dataLength)

###
## DATA
#
#experiment_id
databook$data$experiment_id <- experimentID

#source_id
databook$data$source_id <- data$source_id

#study_id
databook$data$study_id <- data$study_id

#timepoint
databook$data$timepoint <- data$timepoint_in_days

#target_id
# check if we should fill in blank info here
databook$data$target_id <- paste0(gsub("\n", "", data$Name), "_", data$ID) #combine the protein name and the entry id, remove \n

#wavelength
# wavelength is in the datafile name
databook$data$wavelength <- as.numeric(sub(".*_", "", data$`Data file`))

#wavelength_name
# use the wavelength in the file name
databook$data$wavelength_name <- case_when(
  grepl("532", data$file_path) ~ "IgG",
  grepl("633", data$file_path) ~ "IgM",
  TRUE ~ NA
)

#test_type
databook$data$test_type <- ifelse(grepl("blank", data$Name), "blank", "test")

#slide
databook$data$slide <- as.numeric(data$`slideID (slide nr.)`)

#block
databook$data$block <- as.numeric(data$block)

#fi_f_median
databook$data$fi_f_median <- as.numeric(data$F532.Median)

#fi_f_mean
databook$data$fi_f_mean <- as.numeric(data$F532.Mean)

#fi_f_sd
databook$data$fi_f_sd <- as.numeric(data$F532.SD)

#fi_b_median
databook$data$fi_b_median <- as.numeric(data$B532.Median)

#fi_b_mean
databook$data$fi_b_mean <- as.numeric(data$B532.Mean)

#fi_b_sd
databook$data$fi_b_sd <- as.numeric(data$B532.SD)

#fi_f_minus_b_median
databook$data$fi_f_minus_b_median <- as.numeric(data$F532.Median...B532)

#fi_f_minus_b_mean
databook$data$fi_f_minus_b_mean <- as.numeric(data$F532.Mean...B532)

#x_coordinate
databook$data$x_coordinate <- as.numeric(data$X)

#y_coordinate
databook$data$y_coordinate <- as.numeric(data$Y)

#diameter
databook$data$diameter <- as.numeric(data$Dia.)

#flags
databook$data$flags <- data$Flags

#date
databook$data$date <- data$`dateArrayPerformed (incubation date)`


###
## Validate entries
#

databook$validation <- beFAIR::validateDatabook(databook)

###
## Clean environment
#
rm(list = setdiff(ls(), c("databook")))
