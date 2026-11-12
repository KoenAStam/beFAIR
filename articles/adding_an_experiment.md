# Adding an experiment

``` r

library(basictabler)
library(dplyr)
library(htmltools)
library(beFAIR)
library(yaml)
```

## 🚧 *Under construction* 🚧

## The Experimental pillar

One of three data pillars is the `experiments` pillar. These contain the
experimental data, typically generated in the lab from samples acquired
from volunteers who participated in the clinical trials (or studies).
It’s important to note that experiments may have been performed on
samples from different studies. Therefore, the data pillars are
interconnected through the `event_id`. Any additional information
required to better understand the experimental data can be retrieved
from the `participant` or `event` table. To get an quick overview of the
folder structure of you FAIRPoint you can run
[`overviewFAIRground()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundOverview.md)

    #> [1] "analyses"       "beFAIR.Rproj"   "codebooks"      "common"        
    #> [5] "experiments"    "fairground.yml" "logs"           "studies"

``` r

overviewFAIRground()
#> Warning in overviewFAIRground(): 'overviewFAIRground' is deprecated.
#> Use 'FAIRgroundOverview' instead.
#> See help("Deprecated")
#> 
#>  FAIRground Overview Summary
#> 
#> STUDIES: 0 rows × 0 columns
#>  (no data available)
#> 
#> EXPERIMENTS: 0 rows × 0 columns
#>  (no data available)
#> 
#> ANALYSES: 0 rows × 0 columns
#>  (no data available)
```

A new experiment can be added by running
[`addExperiment()`](https://koenastam.github.io/beFAIR/reference/addExperiment.md).
A unique study name together with the type of experiment is required and
will kickstart the necessary ETL scripts under
`/experiments/[experiment_name]`. Any unique name is possible, but we
strongly recommend using our naming convention: \[reference to studies\]
*\[experiment type\]*\[other specifics\]. The experiment type is there
to ask for extra relevant meta information, e.g. machine specifics, but
will also kickstart technique specific ETL scripts, e.g. for cytof we
need a panel that specefies which antibodies and metals were used for
the experiment. It’s possible to add an experiment without a
experiment_type, but it is not recommended.

## The experiment folder

``` r

addExperiment(experiment_name = "CoHSI1_CyTOF_exvivo",
              experiment_type = "CyTOF")
#> Experiment added: CoHSI1_CyTOF_exvivo. Add the additional experiment information to the meta.yaml file located at: experiments/CoHSI1_CyTOF_exvivo/meta.yaml
#> 
```

A new folder can be found in the `experiments` directory, named after
the experiment name you provided (e.g., `CoHSI1_CyTOF_exvivo`).

In this folder, you will find the following components:

- **`meta.yaml`**: This file contains essential metadata about the
  experiment
- **`data/`**: A folder designated for storing the data locations.
- **`scripts/`**: A folder with the ETL scripts related to the
  experiment

We will break down each of these components in the following sections
for a clearer understanding.

### meta.yaml

Just as with studies, you will find a `meta.yaml` file located at
`/experiments/[experiment_name]/meta.yaml`. This file contains essential
metadata about the experiment, which you are requested to supplement
with the missing information. The table below is a small snapshot of
information stored in the meta.yaml file.

### Data folder

The data folder in each study directory is intended to organize and
manage the locations of the raw data files associated with the study.
This is facilitated by YAML files, where each raw data file can have its
own YAML configuration file. These YAML files provide key metadata about
the raw data, including its location, file type, and contact information
of the data owner.

This information is used to automate the extraction and transformation
processes within the study’s ETL pipeline. The YAML files ensure that
raw data is easily located and interpreted in a structured, standardized
format.

An example YAML file, `template.yaml`, is automatically placed in the
data folder of a new study. You can edit the template.yaml file or
create additional YAML files for each raw data file in your study. Below
is the structure of the template:

    #> ```yaml
    #>  contact_name: ~ # Name of the person to contact for any inquiries or support
    #> contact_email: ~ # Email address of the contact person
    #> filetype: ~ # Extension of the data file (e.g. .xlsx or .csv)
    #> path: ~ # Full file path to the data file including file extension
    #> sheet: ~ # Name of the sheet within the file that contains the relevant data (if applicable) 
    #> ```

### ETL scripts

In the scripts folder, the ETL (Extract, Transform, Load) scripts are
provided in R format. These scripts correspond to different entities:
participants, events, and samples. Each script follows the data
structure defined in the codebook and is responsible for extracting,
transforming, and validating the data before it can be loaded into the
data warehouse.

``` r

list.files("experiments/CoHSI1_CyTOF_exvivo/scripts")
#> [1] "cytofbarcodingscheme.R" "cytofpanel.R"
```
