# Codebook reference

This page documents all codebooks included in beFAIR. Each codebook
defines the schema for a database table — its variables, types, and
validation rules.

See [Codebook configuration
guide](https://koenastam.github.io/beFAIR/articles/codebook_configuration.md)
for details on the YAML format.

## Study

Tables related to participants, events, and study design.

### `adverse_event`

**Version:** 4

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| adverse_event_id | PK | Unique identifier for the adverse event. Format is study_id + “ae” + a 4-digit number (e.g., “CHSI1ae0001”). | character | VARCHAR(255) |  |  |
| source_id |  | Original ID given to the participant during the study. | character | VARCHAR(255) |  |  |
| participant_id | FK → participant.participant_id | Identifier of the participant who experienced this adverse event. | character | VARCHAR(255) |  |  |
| study_id | FK → study.study_id | ID given to the study or trial; foreign key to study. | character | VARCHAR(255) |  |  |
| description |  | verbatim description of the adverse event. | character | VARCHAR(255) |  |  |
| clinical_condition_code |  | dictionary-derived code. Like “R51” for headache according to the ICD-10. | character | VARCHAR(255) |  |  |
| code_classification_system |  | dictionary name and version used to map description to code. Like “ICD-10 Version:2019”. | character | VARCHAR(255) |  |  |
| location |  | relevent anatomical location. Like “arm” for skin rash. Only required when missing from description and code. | character | VARCHAR(255) |  |  |
| severity |  | severity or intensity of the event on a three-point scale from mild to severe. | character | VARCHAR(255) |  |  |
| serious |  | is this a ‘serious’ event, yes or no, as defined by the ICH E2A. | character | VARCHAR(255) |  |  |
| relation |  | opinion on causality between event and intervention on a five-point scale from defintely not related to defintely related. | character | VARCHAR(255) |  |  |
| additional_treatment_given |  | was another treatment given because of the event? Valid are “Y” and “N”. | character | VARCHAR(255) |  |  |
| additional_treatment_name |  | verbatim name of the additional drug, medication or therapy. | character | VARCHAR(255) |  |  |
| start_date |  | Start date of the adverse event in ISO 8601 character format (YYYY-MM-DD). | character | VARCHAR(255) |  |  |
| end_date |  | End date of the adverse event in ISO 8601 character format (YYYY-MM-DD). | character | VARCHAR(255) |  |  |
| start_timepoint |  | start of the event relative to the participants reference start date. | integer | INT |  |  |
| end_timepoint |  | end of the event relative to the participants reference start date. | integer | INT |  |  |
| registration_timepoint |  | timepoint when the adverse event was recorded. | integer | INT |  |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground (e.g. “\_event”). | character | VARCHAR(255) |  |  |

### `id_mapping`

**Version:** 1.3

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| participant_nr |  | Sequential integer assigned to a participant within the ID mapping table. It serves as the basis for generating the anonymized participant_id via a SHA-256 hash, and links one or more source_id values (e.g., from different data sources or time points) to a single individual. | integer | INT |  |  |
| source_id |  | Raw participant identifier as recorded in the original data source (e.g., a clinical trial database or laboratory system). Multiple source_id values may map to the same participant_nr when a participant appears under different IDs across data sources or studies. Reserved control/blank identifiers (“BLANK”, “STD”, “NEG_CTRL”, “POS_CTRL”) are never entered in this table and are skipped automatically during source ID validation. | character | VARCHAR(255) |  |  |
| participant_id | FK → participant.participant_id | Anonymized participant identifier assigned during the database update. Derived by computing the SHA-256 hash of the concatenation “\<study_id\>*\<NNNN\>” (where NNNN is the zero-padded participant_nr) and taking the first 6 hexadecimal characters, resulting in the format ”\<study_id\>*\<hash6\>” (e.g., “CapTan_a3f2b1”). | character | VARCHAR(255) |  |  |
| study_id | FK → study.study_id | Identifier of the study or clinical trial to which this ID mapping entry belongs. | character | VARCHAR(255) |  |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground (e.g. “”). | character | VARCHAR(255) |  |  |

### `participant`

**Version:** 3.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| source_id |  | Original ID given to the participant during the study. | character | VARCHAR(255) |  |  |
| participant_id | PK | Anonymized unique identifier assigned to each participant. Generated internally by beFAIR as “\<study_id\>*\<hash6\>” where hash6 is the first 6 characters of the SHA-256 hash of ”\<study_id\>*\<NNNN\>” (e.g., “CapTan_a3f2b1”). | character | VARCHAR(255) |  |  |
| study_id | FK → study.study_id | ID of the study or trial this participant belongs to. Within one participant table all entries must have the same study_id. | character | VARCHAR(255) |  |  |
| study_name |  | Readable name given to the study or trial. Within the participant table, all entries must have the same study_name. | character | VARCHAR(255) |  |  |
| studyarm_id | FK → studyarm.studyarm_id | ID of the study arm this participant belongs to (e.g., treatment, control, or placebo group). Each arm corresponds to a different intervention or condition. Starts with study_id (e.g., “CHSI1_arm1”). | character | VARCHAR(255) |  | N/A=not applicable |
| age |  | Age of subject at enrollment; in years. Usually an integer, but decimals are allowed for newborns (e.g. 0.2). | numeric | DECIMAL |  |  |
| sex |  | Sex of the subject, recorded as one of the following options; M (Male), F (Female) or NA (Not available or not specified). | character | VARCHAR(255) | M;F | M=Male;F=Female |
| ethnicity |  | Ethnicity of the subject. This may be narrow if known (Hausa, Fang, Irish, German), or vague (African, European) | character | VARCHAR(255) |  |  |
| height |  | Height of subject; in cm. | numeric | DECIMAL |  |  |
| weight |  | Weight of subject; in kg. | numeric | DECIMAL |  |  |
| bmi |  | Body mass index, calculated as weight(kg)/length(m)^2. | numeric | DECIMAL |  |  |
| residence |  | Place where the subject resides or lives. | character | VARCHAR(255) |  |  |
| site |  | Site where the study has been performed. | character | VARCHAR(255) |  |  |
| reference_date |  | Reference start date for the participant in ISO 8601 format (YYYY-MM-DD). Usually equivalent to first exposure. | character | VARCHAR(255) |  |  |
| study_status |  | Whether the participant completed the study or not. | character | VARCHAR(255) | completed;ongoing;discontinued | completed=Completed;ongoing=Ongoing;discontinued=Discontinued |
| discontinuation_reason |  | When study_status == “discontinued, the reason for study discontinuation. For example,”informed consent withdrawn”. | character | VARCHAR(255) |  |  |
| discontinuation_timepoint |  | When study_status == “discontinued, the timepoint of discontinuation in days relative to start of the study. | numeric | INT |  |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground (e.g. “”). | character | VARCHAR(255) |  |  |

### `sample`

**Version:** 3.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| source_id |  | Original ID given to the participant during the study. | character | VARCHAR(255) |  |  |
| study_id | FK → study.study_id | ID given to the study or trial for this source id; foreign key to study. | character | VARCHAR(255) |  |  |
| timepoint |  | Timepoint in days relative to start of the study. | integer | INT |  |  |
| participant_id | FK → participant.participant_id | ID given to the participant; foreign key. Automatically filled in. | character | VARCHAR(255) |  |  |
| event_id | FK → event.event_id | Unique identifier for the event (participant × timepoint). Automatically filled during the database update from source_id, study_id, and timepoint. | character | VARCHAR(255) |  |  |
| serum_number_of_vials |  | Vials of serum that are in storage | numeric | DECIMAL |  |  |
| plasma_number_of_vials |  | Vials of plasma that are in storage | numeric | DECIMAL |  |  |
| pbmc_timepoint_on_vials |  | Timepoint on the pbmc vial | character | VARCHAR(255) |  |  |
| pbmc_number_of_vials |  | Vials of PBMCs that are in storage | numeric | DECIMAL |  |  |
| urine_number_of_vials |  | Vials of urine that are in storage | numeric | DECIMAL |  |  |
| paxgene_number_of_vials |  | Vials of paxgene that are in storage | numeric | DECIMAL |  |  |
| wholeblood_number_of_vials |  | Vials of wholeblood that are in storage | numeric | DECIMAL |  |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground (e.g. “”). | character | VARCHAR(255) |  |  |

### `study`

**Version:** 2

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| study_id | PK | Unique identifier assigned to the study or clinical trial. | character | VARCHAR(255) |  |  |
| name |  | Human-readable name of the study or clinical trial (e.g., “CapTan”, “HypoVax Phase II”). Used for display and reporting purposes. | character | VARCHAR(255) |  |  |
| title |  | Full, descriptive title of the study or clinical trial, written in a way that is understandable without prior knowledge of abbreviations or acronyms. | character | VARCHAR(1000) |  |  |
| study_organism |  | Organism in which the study is performed (e.g., “Homo sapiens” for human trials, or the relevant model organism for pre-clinical studies). | character | VARCHAR(255) |  |  |
| disease |  | Name of the disease under investigation in the study (e.g., “malaria”, “schistosomiasis”, “COVID-19”). | character | VARCHAR(255) |  |  |
| pathogen |  | Name of the pathogen relevant to the study (e.g., “Plasmodium falciparum”, “Schistosoma mansoni”). | character | VARCHAR(255) |  |  |
| registration_code |  | Official trial registration code from a clinical trial registry (e.g., a ClinicalTrials.gov NCT number such as “NCT01234567” or an EudraCT number). | character | VARCHAR(255) |  |  |
| facilities |  | Names of the institutions or clinical facilities where the study was conducted, separated by commas (e.g., “LUMC, Radboudumc”). | character | VARCHAR(5000) |  |  |
| cities |  | Cities where the study was conducted, separated by commas (e.g., “Leiden, Nijmegen”). | character | VARCHAR(5000) |  |  |
| countries |  | Countries where the study was conducted, separated by commas (e.g., “Netherlands, Gabon”). | character | VARCHAR(5000) |  |  |
| geopoints |  | Geographic coordinates (latitude, longitude) of the study sites, separated by commas. Format per entry is “lat,lon” (e.g., “52.1601,4.4970”). | character | VARCHAR(5000) |  |  |
| principal_investigator |  | Name(s) of the principal investigator(s) responsible for conducting the study | character | VARCHAR(5000) |  |  |
| contact_name |  | Name of the contact person for questions about the study. | character | VARCHAR(255) |  |  |
| contact_email |  | Email address of the contact person for questions about the study. | character | VARCHAR(255) |  |  |
| primary_outcome |  | The pre-specified primary endpoint of the study, describing what the trial is designed to measure (e.g., “vaccine efficacy against parasitemia by qPCR at day 28 post-challenge”). | character | VARCHAR(5000) |  |  |
| summary |  | Short summary of the study design, objectives, and key findings. Intended for quick orientation when browsing studies in the database. | character | VARCHAR(5000) |  |  |
| description |  | Detailed description of the study, including background, design, interventions, and population. May contain multiple paragraphs. | character | VARCHAR(8000) |  |  |
| actual_start_date |  | Date on which the study actually started (i.e., first participant enrolled), in ISO 8601 format (YYYY-MM-DD). | character | VARCHAR(255) |  |  |
| actual_completion_date |  | Date on which the study was completed (i.e., last participant visit or data lock), in ISO 8601 format (YYYY-MM-DD). | character | VARCHAR(255) |  |  |
| actual_enrollment |  | Actual number of participants enrolled in the study (as opposed to the planned or target enrollment). | character | VARCHAR(255) |  |  |
| registration_link |  | Full URL to the study registration page on a public clinical trial registry (e.g., ClinicalTrials.gov or EU Clinical Trials Register). | character | VARCHAR(5000) |  |  |
| pbmc_location_file |  | Path to the file containing information about the PBMC sample storage location | character | VARCHAR(5000) |  |  |
| pbmc_location_vials |  | Physical storage location of the PBMC vials (e.g., freezer, nitrogen tank, or tower) | character | VARCHAR(5000) |  |  |
| pbmc_contact |  | Contact details (name, email) of the person responsible for PBMC sample storage | character | VARCHAR(5000) |  |  |

### `studyarm`

**Version:** 1.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| studyarm_id | PK | Unique identifier for the study arm. Typically prefixed with the study_id (e.g., “EGSV2_arm1a”). | character | VARCHAR(255) |  |  |
| study_id | FK → study.study_id | Identifier of the study this arm belongs to. | character | VARCHAR(255) |  |  |
| studyarm_name |  | Human-readable name for the study arm (e.g., “PfSPZ vaccine 27000 sporozoites”). | character | VARCHAR(255) |  |  |
| studyarm_description |  | Detailed description of the study arm, including age group, regimen, compound, dose, and any other relevant information. | character | VARCHAR(255) |  |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground (e.g. “”). | character | VARCHAR(255) |  |  |

### `studydesign`

**Version:** 1.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| studyarm_id | FK → studyarm.studyarm_id | Identifier of the study arm this design event belongs to. | character | VARCHAR(255) |  |  |
| study_id | FK → study.study_id | Identifier of the study this design event belongs to. | character | VARCHAR(255) |  |  |
| timepoint |  | Planned timepoint in days relative to the study start (day 0). | integer | INT |  |  |
| event_type |  | Type of scheduled event (e.g., immunization, challenge, treatment, drug, prophylaxis). | character | VARCHAR(255) |  |  |
| event_name |  | Short descriptive name for the scheduled event (e.g., “V1”, “CHMI”). | character | VARCHAR(255) |  |  |
| product_name |  | Name of the product administered (e.g., vaccine name, drug name). | character | VARCHAR(255) |  |  |
| product_administration |  | Route of administration for the product (e.g., “intramuscular”, “DVI”, “mosquito bites”). | character | VARCHAR(255) |  |  |
| dose |  | Planned dose of the product administered. | numeric | DECIMAL |  |  |
| dose_unit |  | Unit of the dose (e.g., “sporozoites”, “mg”, “mL”). | character | VARCHAR(255) |  |  |
| script_id |  | Identifier of the source script that produced this dataset. It is automatically filled during the database update and serves as a foreign key to the table_script table. It equals the relative path name of the script inside the FAIRground (e.g. “”). | character | VARCHAR(255) |  |  |

## Experiment

Tables related to laboratory experiments and measurement panels.

### `arrayexpression`

**Version:** 5

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| experiment_id | FK → experiment.experiment_id | Experiment ID; foreign key | character | VARCHAR(255) |  |  |
| source_id |  | Original ID given to the participant during the study. | character | VARCHAR(255) |  |  |
| study_id | FK → study.study_id | ID given to the study or trial for this source id; foreign key to study. | character | VARCHAR(255) |  |  |
| timepoint |  | Timepoint in days relative to start of the study. | integer | INT |  |  |
| participant_id | FK → participant.participant_id | ID given to the participant; foreign key. Automatically filled in. | character | VARCHAR(255) |  |  |
| event_id | FK → event.event_id | Identifier for the event (sample). Consist of participant id and timepoint in days. Automatically filled in. | character | VARCHAR(255) |  |  |
| target_id | FK → arraypanel.target_id | Target id; foreign key to entry name in array panel | character | VARCHAR(255) |  |  |
| wavelength |  | Measured wavelength | numeric | DECIMAL |  |  |
| wavelength_name |  | Name of what is measured at this wavelength (e.g. antibody subclass) | character | VARCHAR(255) |  |  |
| test_type |  | Indication of whether actual test material is used versus a blank. To be more specific test would correspond to a sample. Blank is nothing added. | character | VARCHAR(255) | test;blank |  |
| slide |  | The slide number | numeric | DECIMAL |  |  |
| block |  | The block number on the slide, needed for corrections and substraction of the blanks | numeric | DECIMAL |  |  |
| row |  | Row number of a given spot within a block. There are 18 rows in total | numeric | DECIMAL |  |  |
| column |  | Column number of a given spot within a block. There are 12 columns in total | numeric | DECIMAL |  |  |
| fi_f_median |  | Foreground (F) median fluorescence intensity measured for this spot. | numeric | DECIMAL |  |  |
| fi_f_mean |  | Foreground (F) mean fluorescence intensity measured for this spot. | numeric | DECIMAL |  |  |
| fi_f_sd |  | Foreground (F) standard deviation of fluorescence intensity measured for this spot. | numeric | DECIMAL |  |  |
| fi_b_median |  | Background (B) median fluorescence intensity measured around this spot. | numeric | DECIMAL |  |  |
| fi_b_mean |  | Background (B) mean fluorescence intensity measured around this spot. | numeric | DECIMAL |  |  |
| fi_b_sd |  | Background (B) standard deviation of fluorescence intensity measured around this spot. | numeric | DECIMAL |  |  |
| fi_f_minus_b_median |  | Foreground minus background median fluorescence intensity (F - B median). | numeric | DECIMAL |  |  |
| fi_f_minus_b_mean |  | Foreground minus background mean fluorescence intensity (F - B mean). | numeric | DECIMAL |  |  |
| x_coordinate |  | X coordinate of the circle | numeric | DECIMAL |  |  |
| y_coordinate |  | Y coordinate of the circle | numeric | DECIMAL |  |  |
| diameter |  | diameter of the circle | numeric | DECIMAL |  |  |
| flags |  | Quality control flags for the spot (e.g., 0 = no flag, 50 = artifact flag, -150 = outlier flag). | character | VARCHAR(255) |  |  |
| date |  | Date of the experiment | character | VARCHAR(255) |  |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground. | character | VARCHAR(255) |  |  |

### `arraypanel`

**Version:** 1.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| experiment_id | FK → experiment.experiment_id | Experiment ID; foreign key | character | VARCHAR(255) |  |  |
| target_name |  | Standardized name for target. Shared concept across studies. Unique within one experiment. | character | VARCHAR(255) |  |  |
| target_id | PK | Target entry name given to the target by the researcher during the experiment, corresponds to the entries in the outcome tables. | character | VARCHAR(255) |  |  |
| type |  | Type of array (e.g., protein array, glycan array). | character | VARCHAR(255) |  |  |
| organism |  | Source organism of the spotted target (e.g., ‘Plasmodium falciparum’, ‘Homo sapiens’). | character | VARCHAR(255) |  |  |
| catolog_number |  | Catalog number of the spotted antigen or antibody from the supplier. | character | VARCHAR(255) |  |  |
| uniprot |  | UniProt accession number of the target protein, if applicable. | character | VARCHAR(255) |  |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground. | character | VARCHAR(255) |  |  |

### `aurorabarcodingscheme`

**Version:** 3.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| experiment_id | FK → experiment.experiment_id | Experiment ID; foreign key | character | VARCHAR(255) |  |  |
| source_id |  | Original ID given to the participant during the study. | character | VARCHAR(255) |  |  |
| study_id | FK → study.study_id | ID given to the study or trial for this source id; foreign key to study. | character | VARCHAR(255) |  |  |
| timepoint |  | Timepoint in days relative to start of the study. | integer | INT |  |  |
| participant_id | FK → participant.participant_id | ID given to the participant; foreign key. Automatically filled in. | character | VARCHAR(255) |  |  |
| event_id | FK → event.event_id | Identifier for the event (sample). Consist of participant id and timepoint in days. Automatically filled in. | character | VARCHAR(255) |  |  |
| batch_id |  | Identifier for which batch this event (sample) came from | character | VARCHAR(255) |  |  |
| barcode_fluorochrome |  | List of which fluorochromes are used for the barcoding scheme, character separated by a comma e.g. BUV661, BV740, RB744 | character | VARCHAR(255) |  |  |
| barcode_scheme |  | The barcode scheme encoded with 1’s and 0’s corresponding to the list specified in barcode_fluorochrome, character separated by a comma e.g. 1, 1, 0, 0, 0, 0 | character | VARCHAR(255) |  |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground. | character | VARCHAR(255) |  |  |

### `aurorapanel`

**Version:** 2.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| experiment_id | FK → experiment.experiment_id | Experiment ID; foreign key | character | VARCHAR(255) |  |  |
| fluorochrome_id |  | A unique identifier for the fluorochrome. It serves as the definitive reference to be used. | character | VARCHAR(255) |  |  |
| fluorochrome_id_fcs |  | This identifier corresponds to the `ftr (prim)` parameter in the .fcs file. This name is used for cross-referencing or mapping data from the .fcs. | character | VARCHAR(255) |  |  |
| target_id |  | The primary identifier of the protein of interest. It serves as the definitive reference to be used. | character | VARCHAR(255) |  |  |
| target_id_fcs |  | This identifier corresponds to the `ftr (sec)` parameter in the .fcs file. It serves as a reference for cross-checking or mapping data from the .fcs file. | character | VARCHAR(255) |  |  |
| target_name |  | Harmonized name/label of target protein, either `CD`, `HGNC` or custom name. See CyStore package for more info | character | VARCHAR(255) |  |  |
| clone |  | Clone of given antibody target | character | VARCHAR(255) |  |  |
| vendor |  | By whom the antibody was produced or sold | character | VARCHAR(255) |  |  |
| catalog_number |  | Catalog number | character | VARCHAR(255) |  |  |
| RRID |  | Antibody identifier according to the resource identification portal (<https://rrid.site/>) | character | VARCHAR(255) |  |  |
| staining_type |  | Indicates whether the antibody staining is intracellular or extracellular. | character | VARCHAR(255) | intracellular; extracellular |  |
| self_conjugated |  | Whether the target was self conjugated or not | integer | INT | 0;1 | 0=No;1=Yes |
| dilution |  | dilution factor 1/x of antibody to volume | numeric | DECIMAL |  |  |
| notes |  | Any additional comments or notes about the data, such as mismatches between the identifiers used in the primary dataset and the .fcs file, and their corresponding target names. | character | VARCHAR(255) |  |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground. | character | VARCHAR(255) |  |  |

### `cytofbarcodingscheme`

**Version:** 3.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| experiment_id | FK → experiment.experiment_id | Unique identifier for the CyTOF experiment; foreign key referencing the experiment table. | character | VARCHAR(255) |  |  |
| source_id |  | Original identifier assigned to the participant within the source study, as used in the raw data or study metadata. | character | VARCHAR(255) |  |  |
| study_id | FK → study.study_id | Identifier of the study or trial from which this source ID originates; foreign key to the study table. | character | VARCHAR(255) |  |  |
| timepoint |  | Time of sample collection in days relative to the start of the study (day 0). | integer | INT |  |  |
| participant_id | FK → participant.participant_id | Harmonized participant identifier; foreign key to the id_mapping table. Automatically derived from study_id and source_id during the database update. | character | VARCHAR(255) |  |  |
| event_id | FK → event.event_id | Unique identifier for the sample collection event, composed of the participant_id and the timepoint in days. Automatically filled in during the database update. | character | VARCHAR(255) |  |  |
| batch_id |  | Identifier for the CyTOF acquisition batch in which this sample was measured. Samples within the same batch were acquired together and typically share the same normalization beads run. | character | VARCHAR(255) |  |  |
| barcode_mass |  | Comma-separated list of metal isotope masses (in atomic mass units) used in the barcoding scheme, e.g. ‘104, 106, 108, 110, 194, 198’. Each mass corresponds to one barcoding channel and defines the encoding alphabet for this sample. | character | VARCHAR(255) |  |  |
| barcode_scheme |  | Binary encoding indicating which metal isotopes from barcode_mass were used to label this sample (1 = labeled, 0 = unlabeled), given as a comma-separated string, e.g. ‘1, 1, 0, 0, 0, 0’. Together with barcode_mass, this uniquely identifies the sample within a batch. | character | VARCHAR(255) |  |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground. | character | VARCHAR(255) |  |  |

### `cytofpanel`

**Version:** 1.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| experiment_id | FK → experiment.experiment_id | Experiment ID; foreign key | character | VARCHAR(255) |  |  |
| channel_id |  | A unique identifier for the channel. It serves as the definitive reference to be used. | character | VARCHAR(255) |  |  |
| channel_id_fcs |  | The channel `name` as it appears in the .fcs file. This name is used for cross-referencing or mapping data from the .fcs. | character | VARCHAR(255) |  |  |
| channel_mass |  | Atomic weight or mass number of metal | numeric | DECIMAL |  |  |
| channel_element |  | Element name derived from periodic table | character | VARCHAR(255) |  |  |
| target_id |  | The primary identifier of the protein of interest. It serves as the definitive reference to be used. | character | VARCHAR(255) |  |  |
| target_id_fcs |  | This identifier corresponds to the `desc` parameter in the .fcs file. It serves as a reference for cross-checking or mapping data from the .fcs file. | character | VARCHAR(255) |  |  |
| target_name |  | Harmonized name/label of target protein, either `CD`, `HGNC` or custom name. See CyStore package for more info | character | VARCHAR(255) |  |  |
| clone |  | Clone of given antibody target | character | VARCHAR(255) |  |  |
| vendor |  | By whom the antibody was produced or sold | character | VARCHAR(255) |  |  |
| catalog_number |  | Catalog number | character | VARCHAR(255) |  |  |
| RRID |  | Antibody identifier according to the resource identification portal (<https://rrid.site/>) | character | VARCHAR(255) |  |  |
| staining_type |  | Indicates whether the antibody staining is intracellular or extracellular. | character | VARCHAR(255) | intracellular; extracellular |  |
| self_conjugated |  | Whether the target was self conjugated or not | integer | INT | 0;1 | 0=No;1=Yes |
| dilution |  | dilution factor 1/x of antibody to volume | numeric | DECIMAL |  |  |
| notes |  | Any additional comments or notes about the data, such as mismatches between the identifiers used in the primary dataset and the .fcs file, and their corresponding target names. | character | VARCHAR(255) |  |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground. | character | VARCHAR(255) |  |  |

### `cytofspillover`

**Version:** 1.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| experiment_id | FK → experiment.experiment_id | Identifier of the experiment; links to the experiment table. | character | VARCHAR(255) |  |  |
| channel_metal_from |  | The channel where spillover is calculated FROM, written as \[element\]\[mass\], (e.g. Cd114, Yb171, Y89) | character | VARCHAR(255) |  |  |
| channel_metal_to |  | The channel where spillover is calculated TO, written as \[element\]\[mass\], (e.g. Cd114, Yb171, Y89) | character | VARCHAR(255) |  |  |
| value |  | degree of spillover | numeric | DECIMAL |  |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground. | character | VARCHAR(255) |  |  |

### `elisa_absorbance`

**Version:** 1.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| experiment_id | FK → experiment.experiment_id | Experiment ID; foreign key | character | VARCHAR(255) |  |  |
| plate_id |  | unique plate identifier within the experiment | character | VARCHAR(255) |  |  |
| well_id |  | unique well identifier within the plate. combination of the row and column e.g. A1, B6, D12 etc.. | character | VARCHAR(255) |  |  |
| absorbance_wavelength |  | wavelength of given absorbance value, e.g. 450, 650 | numeric | INT |  |  |
| absorbance_value |  | absorbance value, or OD (optical density) that reflects the concentration of target analyte | numeric | DECIMAL |  |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground. | character | VARCHAR(255) |  |  |

### `elisa_layout`

**Version:** 3.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| experiment_id | FK → experiment.experiment_id | Experiment ID; foreign key | character | VARCHAR(255) |  |  |
| plate_id |  | unique plate identifier within the experiment | character | VARCHAR(255) |  |  |
| plate_row |  | row letter on the plate, annotated as a letter (A, B, C, …) | character | VARCHAR(255) |  |  |
| plate_col |  | column number on the plate, annotated as a number | numeric | INT |  |  |
| well_id |  | unique well identifier within the plate. combination of the row and column e.g. A1, B6, D12 etc.. | character | VARCHAR(255) |  |  |
| source_id |  | Original ID given to the participant during the study. | character | VARCHAR(255) |  |  |
| study_id | FK → study.study_id | ID given to the study or trial for this source id; foreign key to study. | character | VARCHAR(255) |  |  |
| timepoint |  | Timepoint in days relative to start of the study. | integer | INT |  |  |
| participant_id | FK → participant.participant_id | ID given to the participant; foreign key. Automatically filled in. | character | VARCHAR(255) |  |  |
| event_id | FK → event.event_id | Identifier for the event (sample). Consist of participant id and timepoint in days. Automatically filled in. | character | VARCHAR(255) |  |  |
| test_type |  | Type of sample used in the assay. ‘test’ stands for test samples, ‘blank’ are the wells that are kept empty, and stdcurve are the wells used for the standard curve. | character | VARCHAR(255) | test;blank;stdcurve |  |
| dilution |  | dilution factor 1/x of sample to volume. Relevant for ‘test’ samples, set NA for ‘stdcruve’ and ‘blank’ | numeric | DECIMAL |  |  |
| concentration |  | concentration values of the known standard curve. For units check ‘concentration_units’ in experiment_elisa. This value can be set to NA for ‘blank’ and ‘test’ | numeric | DECIMAL |  |  |
| notes |  | Any relevant notes that could influence the layout identification. For example accidental swapping of samples or change to standard curve etc.. | character | VARCHAR(255) |  |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground. | character | VARCHAR(255) |  |  |

### `experiment_array`

**Version:** 1.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| experiment_id | FK → experiment.experiment_id | Identifier of the experiment; links to the experiment table. | character | VARCHAR(255) |  |  |
| channel_red |  | Antibody isotype measured in red channel | character | VARCHAR(255) |  |  |
| channel_green |  | Antibody isotype measured in green channel | character | VARCHAR(255) |  |  |
| analysis_done_by |  | Name of the person who manually drew the circles around the fluorescence spots during the array experiment | character | VARCHAR(255) |  |  |
| slides |  | Total number of slides measured during the experiment | character | VARCHAR(255) |  |  |

### `experiment_aurora`

**Version:** 1.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| experiment_id | FK → experiment.experiment_id | Identifier of the experiment; links to the experiment table. | character | VARCHAR(255) |  |  |
| barcoding_performed |  | If the samples where barcoded (yes / no). | character | VARCHAR(255) |  |  |
| reference_sample |  | List of used referenced samples. Use “none” if no reference sample was used. | character | VARCHAR(255) |  |  |

### `experiment_cytof`

**Version:** 1.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| experiment_id | FK → experiment.experiment_id | Identifier of the experiment; links to the experiment table. | character | VARCHAR(255) |  |  |
| barcoding_performed |  | If the samples where barcoded (yes / no). | character | VARCHAR(255) |  |  |
| reference_sample |  | List of used referenced samples. Use “none” if no reference sample was used. | character | VARCHAR(255) |  |  |

### `experiment_elisa`

**Version:** 1.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| target |  | Target analyte of interest e.g. IgG, IgM leptin, HMGB-1, TNFa. Try to use HGNC or Uniprot for naming conventions | character | VARCHAR(255) |  |  |
| kit |  | Kit manufacturer and catalogus number, if applicable | character | VARCHAR(255) |  |  |
| assay_type |  | What type of ELISA is performed. Direct, sandwich, competitive, or indirect. | character | VARCHAR(255) | direct, sandwich, competitive, indirect |  |
| concentration_units |  | Unit of back-calculated concentration e.g. ng/ml or AU (arbitrary units) | character | VARCHAR(255) |  |  |
| target_wavelength |  | Which wavelength is measured as the target, e.g. 405, 450, 492, 650 | numeric | INT |  |  |
| background_wavelength |  | Which wavelength is measured as background (if any), e.g. 405, 450, 492, 650 | numeric | INT |  |  |

### `experiment_LCMS`

**Version:** 1.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| enzyme |  | Enzyme used to digest proteins prior to mass spectrometry analysis (e.g., trypsin). | character | VARCHAR(255) |  |  |
| purification |  | Whether a purification step was performed before analysis. | character | VARCHAR(255) |  |  |
| purification_method |  | Method used to purify the sample prior to mass spectrometry (e.g., immunoprecipitation). | character | VARCHAR(255) |  |  |
| antigen |  | Antigen, if the experiment was antigen specific, else NA | character | VARCHAR(255) |  |  |
| platform |  | Column type and chemistry used for the chromatographic separation (e.g., C18 reverse-phase). | character | VARCHAR(255) |  |  |
| sample_prepartion |  | Sample preparation protocol applied (e.g., trypsin digest, reduction and alkylation). | character | VARCHAR(255) |  |  |
| ionization_method |  | Ionization method used in the mass spectrometer (e.g., ESI, MALDI). | character | VARCHAR(255) |  |  |

### `experiment_luminex`

**Version:** 1.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| experiment_id | FK → experiment.experiment_id | Identifier of the experiment; links to the experiment table. | character | VARCHAR(255) |  |  |
| luminex_type |  | Type of luminex | character | VARCHAR(255) | levels;functionality;avidity |  |
| functional_assay |  | Assay used to measure functionality, if applicable | character | VARCHAR(255) | NA;FcAR;FcgR2a;FcgR2b;FcgR3a(V);FcgR3b;C1q |  |
| number_of_plates |  | Total number of plates measured during the experiment | character | VARCHAR(255) |  |  |
| urea |  | Whether urea was added | character | VARCHAR(255) | yes;no |  |

### `experiment_olink`

**Version:** 1.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| product |  | Olink product type (e.g., ‘Explore’, ‘Target’, ‘Focus’). | character | VARCHAR(255) |  |  |
| panel |  | Olink panel name (e.g., ‘Inflammation’, ‘Oncology II’). | character | VARCHAR(255) |  |  |
| panel_version |  | Version number of the Olink panel used in this experiment. | character | VARCHAR(255) |  |  |
| plate_id |  | Unique plate identifier within the experiment. | character | VARCHAR(255) |  |  |
| readout |  | Readout type or unit (e.g., ‘NPX’, ‘pg/mL’). | character | VARCHAR(255) |  |  |

### `experiment_UPLC`

**Version:** 2

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| experiment_id | FK → experiment.experiment_id | Identifier of the experiment; links to the experiment table. | character | VARCHAR(255) |  |  |
| measurement_target |  | Type of biomolecule measured in this experiment | character | VARCHAR(255) | N-glycans |  |
| glycan_release_method |  | Method used to enzymatically release N-glycans from plasma proteins (e.g. PNGaseF) | character | VARCHAR(255) | PNGaseF |  |
| chromatography_method |  | Chromatographic method used to separate labeled glycans (e.g. HILIC-UHPLC-FLD) | character | VARCHAR(255) | HILIC-UHPLC-FLD |  |
| chromotography_column |  | Chromatographic column | character | VARCHAR(255) |  |  |
| gradient_conditions |  | Gradient conditions | character | VARCHAR(255) |  |  |
| fluorescent_dye |  | Fluorescent dye | character | VARCHAR(255) |  |  |
| number_of_peaks |  | Number of integrated glycan chromatographic peaks in the data | integer | INT |  |  |
| number_of_plates |  | Total number of plates measured during the experiment | character | VARCHAR(255) |  |  |

### `experiment`

**Version:** 1.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| experiment_id | PK | Unique identifier for the experiment, in the format ‘E’ followed by an additional letter and a 4-character code (e.g., ‘EC0001’). | character | VARCHAR(255) |  |  |
| name |  | Readable name given to the experiment | character | VARCHAR(255) |  |  |
| type |  | What type of experiment was performed. | character | VARCHAR(255) | CyTOF; Array; ELISA; Luminex; Aurora; Olink |  |
| study_ids | FK → study.study_id | Semicolon-separated list of study IDs whose samples were used in this experiment (e.g., ‘CHSI1;CHSI2’). | character | VARCHAR(255) |  |  |
| date |  | Date of the experiment YYYY-MM-DD (ISO 8601) | character | VARCHAR(255) |  |  |
| sample_type |  | On what type of samples the experiment was performed | character | VARCHAR(255) | pbmc; plasma; wholeblood; urine; other |  |
| location_data |  | Location of the raw data folder | character | VARCHAR(1000) |  |  |
| location_protocol |  | location of the lab journal | character | VARCHAR(1000) |  |  |
| stimulation |  | Stimulation conditions. Different conditions are separated by commas, while stimulations applied together or in sequence are joined by an underscore. If no stimulation is applied, use “none”. Examples; “LPS, aCD3_aCD28”, “none”, “uRBC, iRBC”, or “aCD3_aCD28_PMA_I”. Set; none, uRBC, iRBC, SEB, aCD3, aCD28, PMA, I, med, ssRNA40, LPS, YFvaccine | character | VARCHAR(255) |  |  |
| stimulation_descriptive |  | Structured description of the stimulation conditions. Different conditions are separated by commas, while stimulations belonging together are joined by an underscore. They are joined to their duration also by an underscore. Sequential addition is indicated by *then*. Removal of the previous stimulation(s) by washing is indicated by *wash*. Stimulation names should be abbreviated and written in camelCase. If no stimulation is applied, use NA. Examples; “none”, “iRBC_6h”, “inhibitor_30m_then_stimulation_1h”, “aCD3_aCD28_72h_wash_then_PMA_I_4h” | character | VARCHAR(255) |  |  |
| operator |  | Name of the person who performed the experiment | character | VARCHAR(255) |  |  |
| machine |  | Description of the machine | character | VARCHAR(255) |  |  |

### `glycanarraypanel`

**Version:** 1.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| target_name |  | Standardized name for target. Shared concept across studies. Unique within one experiment. | character | VARCHAR(255) |  |  |
| target_entry |  | Target entry name given to the target by the researcher during the experiment, corresponds to the entries in the outcome tables. | character | VARCHAR(255) |  |  |
| derived |  | Indicates whether the fraction is derived naturally or synthetically | character | VARCHAR(255) |  |  |
| source_organism |  | Organism of the source | character | VARCHAR(255) |  |  |
| source_lifestage |  | Life stage of the source | character | VARCHAR(255) |  |  |
| glycan_type |  | Type of glycan | character | VARCHAR(255) |  |  |
| enzym |  | Enzyme used in the process | character | VARCHAR(255) |  |  |
| hplc_normal_phase |  | Normal-phase HPLC retention value for this glycan. | numeric | DECIMAL |  |  |
| hplc_normal_phase_file |  | File of the hplc normal phase | character | VARCHAR(255) |  |  |
| hplc_normal_phase_date |  | Date of the hplc normal phase | character | VARCHAR(255) |  |  |
| hplc_reverse_phase |  | Reverse-phase HPLC retention value for this glycan. | numeric | DECIMAL |  |  |
| hplc_reverse_phase_file |  | File of the hplc normal phase | character | VARCHAR(255) |  |  |
| hplc_reverse_phase_date |  | Date of the hplc normal phase | character | VARCHAR(255) |  |  |
| concentration |  | Printed concentration of the spotted glycan. | numeric | DECIMAL |  |  |
| concentration_unit |  | Unit of the printed concentration (e.g., ‘pmol/spot’). | character | VARCHAR(255) |  |  |
| synthetic_name |  | Name given to the synthetic fraction (applicable to synthetic derived) | character | VARCHAR(255) |  |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground. | character | VARCHAR(255) |  |  |

### `LCMS_layout`

**Version:** 2.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| experiment_id | FK → experiment.experiment_id | Experiment ID; foreign key | character | VARCHAR(255) |  |  |
| plate_id |  | unique plate identifier within the experiment | character | VARCHAR(255) |  |  |
| plate_row |  | row letter on the plate, annotated as a letter (A, B, C, …) | character | VARCHAR(255) |  |  |
| plate_col |  | column number on the plate, annotated as a number | numeric | INT |  |  |
| well_id |  | unique well identifier within the plate. combination of the row and column e.g. A1, B6, D12 etc.. | character | VARCHAR(255) |  |  |
| file_name |  | Raw data file location | character | VARCHAR(255) |  |  |
| source_id |  | Original ID given to the participant during the study. | character | VARCHAR(255) |  |  |
| study_id | FK → study.study_id | ID given to the study or trial for this source id; foreign key to study. | character | VARCHAR(255) |  |  |
| timepoint |  | Timepoint in days relative to start of the study. | integer | INT |  |  |
| participant_id | FK → participant.participant_id | ID given to the participant; foreign key. Automatically filled in. | character | VARCHAR(255) |  |  |
| event_id | FK → event.event_id | Identifier for the event (sample). Consist of participant id and timepoint in days. Automatically filled in. | character | VARCHAR(255) |  |  |
| test_type |  | Type of sample used in the assay. ‘test’ stands for test samples, ‘blank’ are the wells that are kept empty, and control. | character | VARCHAR(255) | test;blank;stdcurve |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground. | character | VARCHAR(255) |  |  |

### `luminexexpression`

**Version:** 4.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| experiment_id | FK → experiment.experiment_id | Experiment ID; foreign key | character | VARCHAR(255) |  |  |
| source_id |  | Original ID given to the participant during the study. | character | VARCHAR(255) |  |  |
| study_id | FK → study.study_id | ID given to the study or trial for this source id; foreign key to study. | character | VARCHAR(255) |  |  |
| timepoint |  | Timepoint in days relative to start of the study. | integer | INT |  |  |
| participant_id | FK → participant.participant_id | ID given to the participant; foreign key. Automatically filled in. | character | VARCHAR(255) |  |  |
| event_id | FK → event.event_id | Identifier for the event (sample). Consist of participant id and timepoint in days. Automatically filled in. | character | VARCHAR(255) |  |  |
| plate_number |  | The number of the plate | character | VARCHAR(255) |  |  |
| isotype |  | Measured class or subclass of antibody | character | VARCHAR(255) |  |  |
| antigen |  | Specific antigen measured in the assay | character | VARCHAR(255) |  |  |
| source_lifestage |  | Life stage of the source (antigen) | character | VARCHAR(255) |  |  |
| sample_role |  | specifies the purpose of the sample in the assay. Like, test, control or blank. | character | VARCHAR(255) | TS;NC;PC;BL | TS=test;NC=negative control;PC=positive control;BL=blank |
| dilution |  | Dilution factor of the sample (as a character string, e.g., ‘1/100’). | character | VARCHAR(255) |  |  |
| mfi |  | Mean Fluorescence Intensity measured | numeric | DECIMAL |  |  |
| red_flags |  | Flags for potential issues with the data | character | VARCHAR(255) |  |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground. | character | VARCHAR(255) |  |  |

### `olinkexpression`

**Version:** 3.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| experiment_id | FK → experiment.experiment_id | Experiment ID; foreign key | character | VARCHAR(255) |  |  |
| source_id |  | Original ID given to the participant during the study. | character | VARCHAR(255) |  |  |
| study_id | FK → study.study_id | ID given to the study or trial for this source id; foreign key to study. | character | VARCHAR(255) |  |  |
| timepoint |  | Timepoint in days relative to start of the study. | integer | INT |  |  |
| participant_id | FK → participant.participant_id | ID given to the participant; foreign key. Automatically filled in. | character | VARCHAR(255) |  |  |
| event_id | FK → event.event_id | Identifier for the event (sample). Consist of participant id and timepoint in days. Automatically filled in. | character | VARCHAR(255) |  |  |
| target_id |  | Identifier of the Olink assay target measured in this row. | character | VARCHAR(255) |  |  |
| npx |  | Olink-specific standardized Ct values | numeric | DECIMAL |  |  |
| condition |  | E.g. stimulation type. If no stimulation keep blank. | character | VARCHAR(255) |  |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground. | character | VARCHAR(255) |  |  |

### `UPLC_layout`

**Version:** 3.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| experiment_id | FK → experiment.experiment_id | Experiment ID; foreign key | character | VARCHAR(255) |  |  |
| plate_id |  | unique plate identifier within the experiment | character | VARCHAR(255) |  |  |
| plate_row |  | row letter on the plate, annotated as a letter (A, B, C, …) | character | VARCHAR(255) |  |  |
| plate_col |  | column number on the plate, annotated as a number | numeric | INT |  |  |
| well_id |  | unique well identifier within the plate. combination of the row and column e.g. A1, B6, D12 etc.. | character | VARCHAR(255) |  |  |
| file_name |  | Raw data file location | character | VARCHAR(255) |  |  |
| source_id |  | Original ID given to the participant during the study. | character | VARCHAR(255) |  |  |
| study_id | FK → study.study_id | ID given to the study or trial for this source id; foreign key to study. | character | VARCHAR(255) |  |  |
| timepoint |  | Timepoint in days relative to start of the study. | integer | INT |  |  |
| participant_id | FK → participant.participant_id | ID given to the participant; foreign key. Automatically filled in. | character | VARCHAR(255) |  |  |
| event_id | FK → event.event_id | Identifier for the event (sample). Consist of participant id and timepoint in days. Automatically filled in. | character | VARCHAR(255) |  |  |
| test_type |  | Type of sample used in the assay. ‘test’ stands for test samples, ‘blank’ are the wells that are kept empty, and standard (stand). | character | VARCHAR(255) | test;blank;stdcurve |  |
| sample_type |  | Type of sample used in the assay | character | VARCHAR(255) | plasma;serum |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground. | character | VARCHAR(255) |  |  |

## Analyses

Tables containing processed measurement results.

### `analysis_array`

**Version:** 1.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| analysis_id | FK → analysis.analysis_id | ID given to the analysis | character | VARCHAR(255) |  |  |
| remove_flagged |  | Were flagged data (flags != 0 or -50) removed? | character | VARCHAR(255) | yes;no |  |
| floor_fi_150 |  | Were fluorescence values \<150 set to 150? | character | VARCHAR(255) | yes;no |  |
| average_of_triplet |  | Indicates whether the average value was calculated for each triplet in the array experiment | character | VARCHAR(255) | yes;no |  |
| blank_subtracted |  | Was blank median FI subtracted from test FI? | character | VARCHAR(255) | yes;no |  |
| set_negative_to_zero |  | Were negative blank-subtracted FI values set to 0? | character | VARCHAR(255) | yes;no |  |

### `analysis_elisa`

**Version:** 1.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| analysis_id | FK → analysis.analysis_id | ID given to the analysis | character | VARCHAR(255) |  |  |
| antigen |  | Specific antigen measured in the assay | character | VARCHAR(255) |  |  |
| isotype |  | Measured class or subclass of antibody | character | VARCHAR(255) |  |  |
| fit_information |  | Information on the curve-fitting model used for ELISA data analysis. Typically includes parameters for standard curve generation, such as the Four Parameter Logistic (4PL) model (y = d + (a - d) / (1 + (x / c)^b)) or alternative fitting methods. May also include blank-subtracted values and other relevant transformation details. | character | VARCHAR(255) |  |  |

### `analysis_glycoprofiling`

**Version:** 2

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| analysis_id |  | ID given to the analysis | character | VARCHAR(255) |  |  |
| protein_specific |  | Protein specific | character | VARCHAR(255) |  |  |
| antigen_specific |  | Antigen specific | character | VARCHAR(255) |  |  |
| antigen |  | Specific for which antigen | character | VARCHAR(255) |  |  |
| glycan_release |  | Glycan release | character | VARCHAR(255) |  |  |
| software |  | Used software for the analysis | character | VARCHAR(255) |  |  |
| lacytools_version |  | Version of LaCyTools used for glycan analysis | character | VARCHAR(50) |  |  |
| lacytools_build |  | Build number of LaCyTools used | character | VARCHAR(50) |  |  |
| calib_mass_window |  | Mass window used for calibration | numeric | DECIMAL |  |  |
| calib_sn_cutoff |  | Signal-to-noise cutoff used during calibration | numeric | DECIMAL |  |  |
| calib_min_peak |  | Minimum number of peaks required for calibration | integer | INT |  |  |
| sum_spectrum_resolution |  | Resolution used for summed spectrum generation | integer | INT |  |  |
| mass_window |  | Mass extraction window | numeric | DECIMAL |  |  |
| time_window |  | Retention time window for peak extraction | numeric | DECIMAL |  |  |
| min_charge |  | Minimum charge state considered during extraction | integer | INT |  |  |
| max_charge |  | Maximum charge state considered during extraction | integer | INT |  |  |
| min_total |  | Minimum total signal required for peak inclusion | numeric | DECIMAL |  |  |
| background_window |  | Window size used for background estimation | integer | INT |  |  |

### `analysis_luminex`

**Version:** 2

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| analysis_id | FK → analysis.analysis_id | ID given to the analysis | character | VARCHAR(255) |  |  |
| remove_flagged |  | Were flagged data (red_flags) removed? | character | VARCHAR(255) | yes;no |  |
| floor_fi_150 |  | Were fluorescence values \<150 set to 150? | character | VARCHAR(255) | yes;no |  |
| blank_subtracted |  | Was blank median FI subtracted from test FI? | character | VARCHAR(255) | yes;no |  |
| dilution_used |  | Was the dilution used to calculate final fluorescence intensity | character | VARCHAR(255) | yes;no |  |
| set_negative_to_zero |  | Were negative blank-subtracted FI values set to 0? | character | VARCHAR(255) | yes;no |  |

### `analysis_omiq`

**Version:** 1.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| analysis_id | FK → analysis.analysis_id | ID given to the analysis | character | VARCHAR(255) |  |  |
| dataset_name |  | Omiq dataset name | character | VARCHAR(255) |  |  |
| omiq_account |  | Omiq account | character | VARCHAR(255) |  |  |
| fcs_file_location |  | Location of the folder where the fcs files are stored | character | VARCHAR(255) |  |  |

### `analysis_som`

**Version:** 1.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| analysis_id | FK → analysis.analysis_id | ID given to the analysis | character | VARCHAR(255) |  |  |
| SOM_settings |  | placeholder | character | VARCHAR(255) |  |  |

### `analysis`

**Version:** 4

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| analysis_id | PK | ID given to the analysis, it consists out ‘A’ and 4 character code (e.g A0001) | character | VARCHAR(255) |  |  |
| name |  | Readable name given to the analysis | character | VARCHAR(255) |  |  |
| type |  | What type of analysis was performed | character | VARCHAR(255) | Array; ELISA; Glycoprofiling; Luminex; OMIQ; SOM |  |
| study_ids | FK → study.study_id | Semicolon-separated list of study IDs whose samples were used in this analysis (e.g., ‘CHSI1;CHSI2’). | character | VARCHAR(255) |  |  |
| experiment_ids | FK → experiment.experiment_id | Semicolon-separated list of experiment IDs that were processed in this analysis (e.g., ‘Ecf9a63;E50b04a’). | character | VARCHAR(255) |  |  |
| analysis_ids | FK → analysis.analysis_id | Semicolon-separated list of analyis IDs that were processed in this analysis (e.g., ‘A1b6b7f;A27a9ca’). | character | VARCHAR(255) |  |  |
| table_dependecies |  | Is this analysis performed with data from the beFAIR database? In that case list the table with id’s to register dependecies. e.g. participant\[CHSI1\];cytofbarcodingscheme\[Ecf9a63,E50b04a\] | character | VARCHAR(255) |  |  |
| publication_pmid |  | PubMed ID (PMID) for the publication describing this analysis. If the analysis is not yet published, this field can be marked as ‘Not published yet’. | character | VARCHAR(255) |  |  |
| description |  | Description of the analysis (max 1000 characters). | character | VARCHAR(2000) |  |  |
| project_location |  | Absolute path to the external R project directory that produces output CSVs for beFAIR (placed under data/tobeFAIR/). | character | VARCHAR(255) |  |  |
| source_ready |  | (!in development!) Whether this project has a `main.R` and can be sourced by `databaseUpdate`. By using this parameter the downstream analysis is automatically updated if any dependecies also changed. | character | VARCHAR(255) | yes;no |  |
| git_repo |  | Optional URL or path to the git repository of the external R project. | character | VARCHAR(255) |  |  |
| owner |  | Optional name of the person responsible for this analysis. | character | VARCHAR(255) |  |  |

### `array_measurement`

**Version:** 4.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| analysis_id | FK → analysis.analysis_id | Analysis ID; foreign key | character | VARCHAR(255) |  |  |
| source_id |  | Original ID given to the participant during the study. | character | VARCHAR(255) |  |  |
| study_id | FK → study.study_id | ID given to the study or trial for this source id; foreign key to study. | character | VARCHAR(255) |  |  |
| timepoint |  | Timepoint in days relative to start of the study. | integer | INT |  |  |
| participant_id | FK → participant.participant_id | ID given to the participant; foreign key. Automatically filled in. | character | VARCHAR(255) |  |  |
| event_id | FK → event.event_id | Identifier for the event (sample). Consist of participant id and timepoint in days. Automatically filled in. | character | VARCHAR(255) |  |  |
| target_id | FK → arraypanel.target_id | Identifier of the measured target; links to the arraypanel table. | character | VARCHAR(255) |  |  |
| wavelength_name |  | Which name is given to the wavelength. Usually corresponds to which antibody isotype is used to capture the fluoresence intensity. | character | VARCHAR(255) |  |  |
| fluorescence_intensity |  | Final fluorescence intensity calculated following the metadata steps | numeric | DECIMAL |  |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground. | character | VARCHAR(255) |  |  |

### `elisa_measurement`

**Version:** 3.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| analysis_id | FK → analysis.analysis_id | Analysis ID; foreign key | character | VARCHAR(255) |  |  |
| source_id |  | Original ID given to the participant during the study. | character | VARCHAR(255) |  |  |
| study_id | FK → study.study_id | ID given to the study or trial for this source id; foreign key to study. | character | VARCHAR(255) |  |  |
| timepoint |  | Timepoint in days relative to start of the study. | integer | INT |  |  |
| participant_id | FK → participant.participant_id | ID given to the participant; foreign key. Automatically filled in. | character | VARCHAR(255) |  |  |
| event_id | FK → event.event_id | Identifier for the event (sample). Consist of participant id and timepoint in days. Automatically filled in. | character | VARCHAR(255) |  |  |
| concentration |  | Back-calculated concentration values. For units check ‘concentration_units’ in experiment_elisa. For the back calculation check the analysis_elisa table | numeric | DECIMAL |  |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground. | character | VARCHAR(255) |  |  |

### `elisa_result`

**Version:** 2.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| analysis_id | FK → analysis.analysis_id | Analysis ID; foreign key | character | VARCHAR(255) |  |  |
| source_id |  | Original ID given to the participant during the study. | character | VARCHAR(255) |  |  |
| study_id | FK → study.study_id | ID given to the study or trial for this source id; foreign key to study. | character | VARCHAR(255) |  |  |
| timepoint |  | Timepoint in days relative to start of the study. | integer | INT |  |  |
| participant_id | FK → participant.participant_id | ID given to the participant; foreign key. Automatically filled in. | character | VARCHAR(255) |  |  |
| event_id | FK → event.event_id | Identifier for the event (sample). Consist of participant id and timepoint in days. Automatically filled in. | character | VARCHAR(255) |  |  |
| concentration |  | Concentration in AU/mL (Arbitrary Units per milliliter) | numeric | DECIMAL |  |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground. | character | VARCHAR(255) |  |  |

### `elisastandards`

**Version:** 1.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| analysis_id | FK → analysis.analysis_id | analysis ID; foreign key | character | VARCHAR(255) |  |  |
| experiment_id | FK → experiment.experiment_id | Experiment ID; foreign key | character | VARCHAR(255) |  |  |
| plate_id |  | unique plate identifier within the experiment | character | VARCHAR(255) |  |  |
| wells_used |  | character string of which well_id’s are used for the standard curve fit. separated by semi-colon e.g. A11;B11;C11;A12;B12;C12;D12;E12 | character | VARCHAR(255) |  |  |
| sigma_fit |  | residual standard error of the signal fit | numeric | DECIMAL |  |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground. | character | VARCHAR(255) |  |  |

### `glycoprofiling_measurement`

**Version:** 5

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| analysis_id | FK → analysis.analysis_id | Analysis ID; foreign key | character | VARCHAR(255) |  |  |
| source_id |  | Original ID given to the participant during the study. | character | VARCHAR(255) |  |  |
| study_id | FK → study.study_id | ID given to the study or trial for this source id; foreign key to study. | character | VARCHAR(255) |  |  |
| timepoint |  | Timepoint in days relative to start of the study. | integer | INT |  |  |
| participant_id | FK → participant.participant_id | ID given to the participant; foreign key. Automatically filled in. | character | VARCHAR(255) |  |  |
| event_id | FK → event.event_id | Identifier for the event (sample). Consist of participant id and timepoint in days. Automatically filled in. | character | VARCHAR(255) |  |  |
| sample_type |  | Type of sample used in the assay | character | VARCHAR(255) | plasma;serum |  |
| glycan_id | FK → glycan_dictionary.glycan_id | Glycan id, foreign key to glycan dictionary (e.g. 1H3N4F1) | character | VARCHAR(255) |  |  |
| backbone |  | Backbone, example IgG1, IgG4 if any else NA | character | VARCHAR(255) |  |  |
| signal_to_noise |  | Signal to noise value, if any | character | VARCHAR(255) |  |  |
| final_chosen |  | If this value of signal to noise is the chosen as the final value for this sample | character | VARCHAR(255) |  |  |
| glycan_composition_name |  | Example 1H3N4F1, fucosylation or peak 1 | character | VARCHAR(255) |  |  |
| intensity |  | Raw fluorescence or signal intensity for this glycan structure. | numeric | DECIMAL |  |  |
| relative_abundance |  | Relative abundance of the glycan structure after processing (batch correction and normalization applied where specified). | numeric | DECIMAL |  |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground. | character | VARCHAR(255) |  |  |

### `luminex_measurement`

**Version:** 7

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| analysis_id | FK → analysis.analysis_id | Analysis ID; foreign key | character | VARCHAR(255) |  |  |
| source_id |  | Original ID given to the participant during the study. | character | VARCHAR(255) |  |  |
| study_id | FK → study.study_id | ID given to the study or trial for this source id; foreign key to study. | character | VARCHAR(255) |  |  |
| timepoint |  | Timepoint in days relative to start of the study. | integer | INT |  |  |
| participant_id | FK → participant.participant_id | ID given to the participant; foreign key. Automatically filled in. | character | VARCHAR(255) |  |  |
| event_id | FK → event.event_id | Identifier for the event (sample). Consist of participant id and timepoint in days. Automatically filled in. | character | VARCHAR(255) |  |  |
| sample_type |  | Type of sample used in the assay | character | VARCHAR(255) | plasma;serum |  |
| target |  | What target is measured. E.g. IL-5, IgG1\[Cathepsin_B\], total IgG, or Sm-p80 | character | VARCHAR(255) |  |  |
| measurement |  | Type of readout produced by the assay for the given target, e.g. concentration, raw MFI, or avidity (relative binding strength). | character | VARCHAR(255) | concentration;mfi;avidity |  |
| value |  | measured value of the given target. Check ‘unit’ for the given units | numeric | DECIMAL |  |  |
| unit |  | Unit of the give value. E.g. “pg/mL”, kg, mfi, ratio. | character | VARCHAR(255) |  |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground. | character | VARCHAR(255) |  |  |

### `omiq_gatingphenotype`

**Version:** 1.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| analysis_id | FK → analysis.analysis_id | Analysis ID; foreign key | character | VARCHAR(255) |  |  |
| gating_id |  | Unique identifier for this gating definition, composed of dataset name and filter. | character | VARCHAR(255) |  |  |
| filter |  | Name of the filter/gate applied in OMIQ to derive this cell subset. | character | VARCHAR(255) |  |  |
| subset_name |  | Subset (harmonized given name to the subset) | character | VARCHAR(255) |  |  |
| lineage_name |  | Lineage name | character | VARCHAR(255) | Unc. T Cells; CD 4+ T Cells; CD 8+ T Cells; Myeloids; NK; ILCs; B Cells |  |
| gate_1 |  | Gate 1 in format HLA-DR\_+*OR_CD7*-; CD3\_+; CD16\_-*AND_CD56*++. Expression level options are ++, +, dim, -, –. Logical operators AND, OR, XOR. | character | VARCHAR(255) |  |  |
| gate_2 |  | Gate 2. Same format as gate 1. | character | VARCHAR(255) |  |  |
| gate_3 |  | Gate 3. Same format as gate 1. | character | VARCHAR(255) |  |  |
| gate_4 |  | Gate 4. Same format as gate 1. | character | VARCHAR(255) |  |  |
| gate_5 |  | Gate 5. Same format as gate 1. | character | VARCHAR(255) |  |  |
| gate_6 |  | Gate 6. Same format as gate 1. | character | VARCHAR(255) |  |  |
| gate_7 |  | Gate 7. Same format as gate 1. | character | VARCHAR(255) |  |  |
| gate_8 |  | Gate 8. Same format as gate 1. | character | VARCHAR(255) |  |  |
| gate_9 |  | Gate 9. Same format as gate 1. | character | VARCHAR(255) |  |  |
| gate_10 |  | Gate 10. Same format as gate 1. | character | VARCHAR(255) |  |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground. | character | VARCHAR(255) |  |  |

### `omiq_measurement`

**Version:** 3.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| analysis_id | FK → analysis.analysis_id | Analysis ID; foreign key | character | VARCHAR(255) |  |  |
| source_id |  | Original ID given to the participant during the study. | character | VARCHAR(255) |  |  |
| study_id | FK → study.study_id | ID given to the study or trial for this source id; foreign key to study. | character | VARCHAR(255) |  |  |
| timepoint |  | Timepoint in days relative to start of the study. | integer | INT |  |  |
| participant_id | FK → participant.participant_id | ID given to the participant; foreign key. Automatically filled in. | character | VARCHAR(255) |  |  |
| event_id | FK → event.event_id | Identifier for the event (sample). Consist of participant id and timepoint in days. Automatically filled in. | character | VARCHAR(255) |  |  |
| fcs_file |  | Filename of the FCS file associated with this measurement. | character | VARCHAR(255) |  |  |
| gating_id |  | Unique identifier for the gating definition; links to omiq_gatingphenotype.gating_id. | character | VARCHAR(255) |  |  |
| filter |  | Name of the filter/gate applied in OMIQ (use ‘CELLS’ for all cells). | character | VARCHAR(255) |  |  |
| subset_name |  | Given name for a subset | character | VARCHAR(255) |  |  |
| batch |  | Batch identifier for this measurement, used for batch correction tracking. | character | VARCHAR(255) |  |  |
| condition |  | Experimental condition label (e.g., stimulation type) for this measurement. | character | VARCHAR(255) |  |  |
| measurement_of_channel_name |  | Example BV-570A (N/A for count) | character | VARCHAR(255) |  |  |
| measurement_of_target_name |  | Target that was measured (e.g. IL-6, IFNg). Multiple targets can be added as they where filled in (e.g. with underscore) | character | VARCHAR(255) |  |  |
| count |  | Number of cells in the gated subset. | numeric | DECIMAL |  |  |
| median |  | Median marker expression across cells in the gated subset. | numeric | DECIMAL |  |  |
| ptile_80 |  | 80th percentile of marker expression in the gated subset. | numeric | DECIMAL |  |  |
| ptile_95 |  | 95th percentile of marker expression in the gated subset. | numeric | DECIMAL |  |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground. | character | VARCHAR(255) |  |  |

### `som_clusterphenotype`

**Version:** 1.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| analysis_id | FK → analysis.analysis_id | Analysis ID; foreign key | character | VARCHAR(255) |  |  |
| cluster_id |  | ID given to the cluster; (e.g in format c1, c71) | character | VARCHAR(255) |  |  |
| marker_name |  | Name of the marker | character | VARCHAR(255) |  |  |
| measurement |  | Type of measurement per cluster (e.g. percentile, min, max). Values of phenotype can be -1, 0 or 1. | character | VARCHAR(255) |  |  |
| value |  | Value of the measurement | numeric | DECIMAL |  |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground. | character | VARCHAR(255) |  |  |

### `som_codes`

**Version:** 1.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| analysis_id | FK → analysis.analysis_id | Analysis ID; foreign key linking to the SOM analysis that produced this codebook. | character | VARCHAR(255) |  |  |
| node |  | Sequential index of the SOM grid node (unit). In the kohonen R package, nodes are numbered from 1 to (grid_x \* grid_y), row by row from the top-left of the grid. Together with parameter_id, this uniquely identifies one weight in the codebook matrix. | character | VARCHAR(255) |  |  |
| parameter_id | FK → cytofpanel.channel_id; aurorapanel.channel_id | Identifier of the cytometry panel channel or marker used as input to the SOM. References the channel_id from the relevant panel codebook (cytofpanel or aurorapanel). Together with node, uniquely identifies one weight in the SOM codebook matrix. | character | VARCHAR(255) |  |  |
| value |  | The trained SOM prototype (codebook) value for this parameter at this node. Represents the weight of the SOM unit along this parameter’s axis after training, on the same scale as the preprocessed input data (typically arc-sinh transformed expression values). Equivalent to som\$codes\[\[layer\]\]\[node, parameter\] in the kohonen package. | numeric | DECIMAL |  |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground. | character | VARCHAR(255) |  |  |

### `som_measurement`

**Version:** 3.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| analysis_id | FK → analysis.analysis_id | Analysis ID; foreign key | character | VARCHAR(255) |  |  |
| source_id |  | Original ID given to the participant during the study. | character | VARCHAR(255) |  |  |
| study_id | FK → study.study_id | ID given to the study or trial for this source id; foreign key to study. | character | VARCHAR(255) |  |  |
| timepoint |  | Timepoint in days relative to start of the study. | integer | INT |  |  |
| participant_id | FK → participant.participant_id | ID given to the participant; foreign key. Automatically filled in. | character | VARCHAR(255) |  |  |
| event_id | FK → event.event_id | Identifier for the event (sample). Consist of participant id and timepoint in days. Automatically filled in. | character | VARCHAR(255) |  |  |
| cluster_id |  | ID given to the cluster; | character | VARCHAR(255) |  |  |
| measurement |  | Type of measurement (e.g. percentile, count, min, max) | character | VARCHAR(255) |  |  |
| value |  | Value of the measurement | numeric | DECIMAL |  |  |
| script_id | FK → table_script.script_id | Identifier of the source script that produced this dataset. Automatically filled during the database update. Equals the relative path of the script inside the FAIRground. | character | VARCHAR(255) |  |  |

## Common

Internal registry tables used by beFAIR to track scripts and codebook
versions.

### `glycan_dictionary`

**Version:** 1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| glycan_id | PK | Unique internal identifier for the glycan entry. This field may be empty when no internal glycan ID has been assigned yet. | character | VARCHAR(255) |  |  |
| glycan_composition |  | Short glycan composition notation (e.g., “H3N4F1” or “H4N4F1S1”). | character | VARCHAR(255) |  |  |
| protein |  | Protein associated with the glycan entry. | character | VARCHAR(255) |  |  |
| species |  | Species in which the glycan was observed. | character | VARCHAR(255) |  |  |
| glycan_type |  | Type of glycan, for example N-linked or O-linked. | character | VARCHAR(100) |  |  |
| glytoucan_id |  | GlyTouCan identifier for the glycan, if available. | character | VARCHAR(255) |  |  |
| hex |  | Number of hexose residues derived from the composition. | numeric | INT |  |  |
| hexnac |  | Number of N-acetylhexosamine residues derived from the composition. | numeric | INT |  |  |
| fuc |  | Number of fucose residues derived from dHex in the composition. | numeric | INT |  |  |
| neuac |  | Number of N-acetylneuraminic acid residues derived from the composition. | numeric | INT |  |  |

### `HGNC`

**Version:** 1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| hgnc_id | PK | Unique identifier created by the HGNC for every approved symbol (e.g. “HGNC:5”). | character | VARCHAR(50) |  |  |
| symbol |  | HGNC approved gene symbol (e.g. “CD3E”). | character | VARCHAR(255) |  |  |
| cd |  | Symbol used within the Human Cell Differentiation Molecule (HCDM) database. Empty when no CD annotation is available. | character | VARCHAR(255) |  |  |

### `LUNC`

**Version:** 1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| fcs_parameters_desc | PK | Parameter description as it appears in FCS files (e.g. “CD3”). | character | VARCHAR(255) |  |  |
| source |  | Information on the origin of this entry (e.g. “flow cytometer”, “manual curation”). | character | VARCHAR(255) |  |  |
| symbol |  | Standardised symbol chosen as the canonical label, preferably from HCDM or HGNC. | character | VARCHAR(255) |  |  |
| symbol_database |  | Database from which the symbol was sourced (e.g. “HCDM”, “HGNC”, “department”). “department” means the label was defined internally. | character | VARCHAR(100) |  |  |

### `publications`

**Version:** 1.1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| publication_id | PK | Unique ID for each publication. Preferably the PubMed reference number (PMID), but can also be another unique identifier. | character | VARCHAR(255) |  |  |
| study_ids | FK → study.study_id | Semicolon-separated list of study IDs that this publication is linked to (e.g., “CHSI1;CHSI2”). | character | VARCHAR(255) |  |  |
| link |  | URL to the PubMed entry for the publication, if available. If no PubMed entry exists, provide a link to the preprint or publisher’s page. | character | VARCHAR(255) |  |  |
| pmid |  | PubMed ID (PMID) of the publication. This is a unique numeric identifier assigned by PubMed to each indexed publication. | character | VARCHAR(255) |  |  |
| first_author |  | First author of the publication. | character | VARCHAR(255) |  |  |
| year |  | Year of publication. | integer | INTEGER |  |  |
| journal |  | Name of the journal where the publication appeared. | character | VARCHAR(255) |  |  |
| title |  | Title of the publication. | character | VARCHAR(1000) |  |  |

### `table_codebook`

**Version:** 2.2

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| codebook_id | PK | Identifier of the codebook, which is the path in beFAIR under codebooks (e.g. study/participant or experiment/experiment). Primary key. | character | VARCHAR(255) |  |  |
| codebook_name |  | Name of the codebook (and table in the database) | character | VARCHAR(255) |  |  |
| codebook_origin |  | Origin of the codebook. ‘beFAIR’ for built-in package codebooks; the project name (directory basename) for custom codebooks. | character | VARCHAR(255) |  |  |
| codebook_version |  | Current version of the codebook, major and minor annotation (e.g. 2.1, 3.0). A change is considered minor if the description of a variables gets updated. A major change is a change in variables, e.g. a new parameter entry. | character | VARCHAR(255) |  |  |
| authors |  | Author(s) of the codebook | character | VARCHAR(255) |  |  |
| created_at |  | Date and time of creation of the codebook in ISO 8601 format(YYYY-MM-DD) | character | VARCHAR(255) |  |  |
| updated_at |  | Date and time of last modification of codebook in ISO 8601 format(YYYY-MM-DD) | character | VARCHAR(255) |  |  |
| n_parameters |  | How many parameters are in the codebook | numeric | INT |  |  |

### `table_datasource`

**Version:** 1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| datasource_id | PK | Primary key. Relative path of the YAML file within the beFAIR project. E.g. “studies/CoHSI1/data/participant.yaml”. | character | VARCHAR(255) |  |  |
| contact_name |  | Name of the contact person responsible for this data source, as written in the YAML contact_name field. | character | VARCHAR(255) |  |  |
| contact_email |  | E-mail address of the contact person responsible for this data source, as written in the YAML contact_email field. | character | VARCHAR(255) |  |  |
| data_path |  | Full path to the actual data file on disk, taken from the YAML path field. | character | VARCHAR(512) |  |  |
| file_type |  | File type of the data source, taken from the YAML filetype field (e.g. “.csv”, “.xlsx”). Use “folder” to treat data_path as a directory whose contents are hashed collectively. NA when not specified. | character | VARCHAR(50) |  |  |
| sheet |  | Sheet name or index for multi-sheet files (e.g. Excel workbooks), taken from the YAML sheet field. NA when not applicable. | character | VARCHAR(255) |  |  |
| file_hash |  | MD5 hash of the data source at the time of last sync. For regular files, this is the MD5 of the file contents. For file_type “folder”, this is an MD5 of the concatenated sorted per-file hashes of all files in the directory (subdirectories excluded). Set to NA if the path could not be accessed. | character | VARCHAR(255) |  |  |
| present_in_project |  | Flag indicating whether the YAML file still exists in the beFAIR project (1) or has been removed since last registration (0). Never deleted from the registry — rows are only marked absent. | numeric | INT |  |  |
| created_at |  | ISO 8601 date (YYYY-MM-DD) when this data source was first registered in table_datasource. | character | VARCHAR(255) |  |  |
| updated_at |  | ISO 8601 date (YYYY-MM-DD) of the last sync for this data source. | character | VARCHAR(255) |  |  |

### `table_dependency`

**Version:** 2

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| dependency_id | PK | Primary key. For dependency_type “datasource” or “script”: MD5 of paste(script_id, dependency_type, external_id, sep=“\|\|”). For dependency_type “analysis_input”: MD5 of paste(project_id, codebook_name, external_id, sep=“\|\|”). | character | VARCHAR(255) |  |  |
| script_id |  | The dependent ETL script, identified by its path relative to the FAIRground folder. Foreign key to table_script.script_id. Populated for dependency_type “datasource” and “script”; NULL for “analysis_input”. | character | VARCHAR(255) |  |  |
| project_id |  | The dependent analysis project. Foreign key to table_project.project_id. Populated for dependency_type “analysis_input”; NULL for “datasource” and “script”. | character | VARCHAR(255) |  |  |
| dependency_type |  | Type of dependency. “datasource” when an ETL script reads a file registered in table_datasource; “script” when an ETL script implicitly depends on another ETL script (e.g. id_mapping.R); “analysis_input” when an analysis project explicitly depends on a specific database table produced by another pillar. | character | VARCHAR(50) | datasource;script;analysis_input |  |
| external_id |  | The target of this dependency. For “datasource”: the datasource_id from table_datasource. For “script”: the script_id from table_script that this script depends on. For “analysis_input”: the project_id from table_project that supplies the data (the external pillar). | character | VARCHAR(255) |  |  |
| external_hash |  | Snapshot of the dependency hash at the time this row was last written. For “datasource”: table_datasource.file_hash; for “script”: table_script.script_hash. Used to detect whether the dependency has changed since the script last ran. NULL for “analysis_input” (staleness is tracked via resolved_script_id and queued_for_update instead). | character | VARCHAR(255) |  |  |
| codebook_name |  | The name of the database table (codebook) that the analysis depends on, as declared in meta.yaml (e.g. “participant”, “cytofpanel”). Populated for dependency_type “analysis_input”; NULL for other types. | character | VARCHAR(255) |  |  |
| resolved_script_id |  | The script_id in table_script that writes to codebook_name for the given external_id (external pillar). Resolved automatically by looking up the ETL script at \<pillar\>/\<project_name\>/scripts/\<codebook_name\>.R. NULL when the script has not yet been registered in table_script, or for dependency_type “datasource” and “script”. | character | VARCHAR(255) |  |  |
| created_at |  | ISO 8601 date (YYYY-MM-DD) when this dependency row was first inserted into table_dependency. | character | VARCHAR(255) |  |  |
| updated_at |  | ISO 8601 date (YYYY-MM-DD) of the last update to this dependency row (e.g. when external_hash or resolved_script_id was refreshed). | character | VARCHAR(255) |  |  |

### `table_project`

**Version:** 1

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| project_id | PK | Unique identifier of the pillar, equal to its short ID in meta.yaml. For studies this is the 5-character study_id (e.g. “CHSI1”). For experiments and analyses this is the 6-character hex ID (e.g. “cd881d”). | character | VARCHAR(255) |  |  |
| project_name |  | The folder name of the pillar, equal to the directory name under studies/, experiments/, or analyses/ (e.g. “CoHSI1”, “CoHSI1_CyTOF_exvivo”). | character | VARCHAR(255) |  |  |
| pillar |  | The pillar category this project belongs to. | character | VARCHAR(50) | studies;experiments;analyses |  |
| folder_hash |  | MD5 hash of the sorted concatenation of individual MD5 hashes for all .R files in the pillar’s scripts/ subdirectory. Changes whenever any script is added, removed, or modified. NULL when the scripts/ folder is empty or does not exist. | character | VARCHAR(255) |  |  |
| up_to_date |  | Flag indicating whether this pillar is considered up-to-date with the current state of the database (1) or requires review (0). Set to 0 automatically when the folder_hash changes or when any declared dependency script has queued_for_update = 1 in table_script. Set back to 1 manually by a data steward after review. | numeric | INT |  |  |
| created_at |  | ISO 8601 date (YYYY-MM-DD) when this project row was first inserted into table_project. | character | VARCHAR(255) |  |  |
| updated_at |  | ISO 8601 date (YYYY-MM-DD) of the last update to this project row, refreshed on every databasePrepareProjects() run. | character | VARCHAR(255) |  |  |

### `table_script`

**Version:** 5

| Variable | Role | Description | Type | SQL Type | Categories | Labels |
|:---|:---|:---|:---|:---|:---|:---|
| script_id | PK | Unique identifier of the script, equal to its path relative to the FAIRground (e.g. “.R”). | character | VARCHAR(255) |  |  |
| script_hash |  | MD5 hash of the script file. Read-in with `readLines`, used to check if the script had any changes compared to the `table_script in the database. </td> <td style="text-align:left;"> character </td> <td style="text-align:left;"> VARCHAR(255) </td> <td style="text-align:left;"> </td> <td style="text-align:left;"> </td> </tr> <tr> <td style="text-align:left;"> codebook_name </td> <td style="text-align:left;"> </td> <td style="text-align:left;"> Name of the codebook that the ETL script is related to. In most scenarios this is equal the name of the script file and table name in the database. </td> <td style="text-align:left;"> character </td> <td style="text-align:left;"> VARCHAR(255) </td> <td style="text-align:left;"> </td> <td style="text-align:left;"> </td> </tr> <tr> <td style="text-align:left;"> codebook_version </td> <td style="text-align:left;"> </td> <td style="text-align:left;"> Current version of the codebook that the ETL script is related to. major and minor annotation (e.g. 2.1, 3.0). During`database_update`, if the ETL script is behind a major version, the ETL script will be queued for updating. </td> <td style="text-align:left;"> character </td> <td style="text-align:left;"> VARCHAR(255) </td> <td style="text-align:left;"> </td> <td style="text-align:left;"> </td> </tr> <tr> <td style="text-align:left;"> created_at </td> <td style="text-align:left;"> </td> <td style="text-align:left;"> Date and time of creation for ETL script in ISO 8601 format(YYYY-MM-DD). The date corresponds with the first time the script is added to the 'table_script' table. </td> <td style="text-align:left;"> character </td> <td style="text-align:left;"> VARCHAR(255) </td> <td style="text-align:left;"> </td> <td style="text-align:left;"> </td> </tr> <tr> <td style="text-align:left;"> updated_at </td> <td style="text-align:left;"> </td> <td style="text-align:left;"> Date and time of last modification of script in ISO 8601 format(YYYY-MM-DD). The date corresponds with the last time that the ETL succesfully ran and the matching data was added to the database. </td> <td style="text-align:left;"> character </td> <td style="text-align:left;"> VARCHAR(255) </td> <td style="text-align:left;"> </td> <td style="text-align:left;"> </td> </tr> <tr> <td style="text-align:left;"> run_time </td> <td style="text-align:left;"> </td> <td style="text-align:left;"> Time in seconds how long it took to run`sourceScript`on the given ETL script. </td> <td style="text-align:left;"> numeric </td> <td style="text-align:left;"> DECIMAL </td> <td style="text-align:left;"> </td> <td style="text-align:left;"> </td> </tr> <tr> <td style="text-align:left;"> flag_TODO </td> <td style="text-align:left;"> </td> <td style="text-align:left;"> Number of`TODO`flags that are used in the ETL-script. If this is not zero, it could be that the underlying data has some unseen underlying assumptions. </td> <td style="text-align:left;"> numeric </td> <td style="text-align:left;"> INT </td> <td style="text-align:left;"> </td> <td style="text-align:left;"> </td> </tr> <tr> <td style="text-align:left;"> flag_WARN </td> <td style="text-align:left;"> </td> <td style="text-align:left;"> Number of warnings when sourcing the ETL-script. This includes the warnings generated by pointblank validation. </td> <td style="text-align:left;"> numeric </td> <td style="text-align:left;"> INT </td> <td style="text-align:left;"> </td> <td style="text-align:left;"> </td> </tr> <tr> <td style="text-align:left;"> suspended </td> <td style="text-align:left;"> </td> <td style="text-align:left;"> Flag indicating whether the ETL script is suspended (1) or active (0). A suspended script has a filename starting with`\_\` and is skipped during databaseUpdate(). Its table_script record is kept for reference. | numeric | INT |  |  |
| entries_in_database |  | Flag indicating whether at least one row in the target data table has this script_id (1) or not (0). Updated on each databasePrepareScripts() and databaseUpdate() run. | numeric | INT |  |  |
| queued_for_update |  | Flag indicating whether databaseUpdate() should (re-)run this script (1) or skip it (0). Set to 1 when a new script is discovered, the script hash changes, or the codebook version advances. Reset to 0 after a successful run. | numeric | INT |  |  |
