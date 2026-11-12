# Package index

## Database

Connect to and manage the FAIRground database.

- [`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
  : Connect to a FAIRground database

- [`FAIRgroundConnection()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnection.md)
  : Get the active FAIRground database connection

- [`FAIRgroundDisconnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundDisconnect.md)
  : Disconnect the default FAIRground database connection

- [`databaseInitialize()`](https://koenastam.github.io/beFAIR/reference/databaseInitialize.md)
  : Initialize FAIRground database

- [`databaseUpdate()`](https://koenastam.github.io/beFAIR/reference/databaseUpdate.md)
  : Update the FAIRground database

- [`databasePrepareProjects()`](https://koenastam.github.io/beFAIR/reference/databasePrepareProjects.md)
  : Prepare the pillar project registry

- [`databasePrepareDatasources()`](https://koenastam.github.io/beFAIR/reference/databasePrepareDatasources.md)
  : Prepare data source registry

- [`databasePrepareDependencies()`](https://koenastam.github.io/beFAIR/reference/databasePrepareDependencies.md)
  : Prepare dependency registry for an ETL script

- [`databasePrepareCodebooks()`](https://koenastam.github.io/beFAIR/reference/databasePrepareCodebooks.md)
  : Prepare and synchronize beFAIR codebooks with the database

- [`databasePrepareScripts()`](https://koenastam.github.io/beFAIR/reference/databasePrepareScripts.md)
  : Prepare ETL scripts prior to updating the database

- [`databasePrepareData()`](https://koenastam.github.io/beFAIR/reference/databasePrepareData.md)
  :

  Prepare data from a `databook` for uploading to database

- [`databaseExport()`](https://koenastam.github.io/beFAIR/reference/databaseExport.md)
  : Export all database tables to R

- [`databaseUpdateOverview()`](https://koenastam.github.io/beFAIR/reference/databaseUpdateOverview.md)
  : Update the overview tables in the database

- [`databaseUpdatePublications()`](https://koenastam.github.io/beFAIR/reference/databaseUpdatePublications.md)
  : Update the publications table in the database

- [`getDatabase()`](https://koenastam.github.io/beFAIR/reference/getDatabase.md)
  : Load database tables into R (cache-first)

- [`initTable()`](https://koenastam.github.io/beFAIR/reference/initTable.md)
  : Create or recreate a single database table from its codebook

- [`sourceScript()`](https://koenastam.github.io/beFAIR/reference/sourceScript.md)
  : Source an ETL script and return its databook

## Codebooks

Read, inspect, and validate codebook schemas.

- [`codebookToEntries()`](https://koenastam.github.io/beFAIR/reference/codebookToEntries.md)
  : Create an empty databook from a codebook
- [`codebookToDraft()`](https://koenastam.github.io/beFAIR/reference/codebookToDraft.md)
  : Generate R code for initializing codebook entries
- [`codebookToSummary()`](https://koenastam.github.io/beFAIR/reference/codebookToSummary.md)
  : Summarise a codebook or one of its variables
- [`codebookToTable()`](https://koenastam.github.io/beFAIR/reference/codebookToTable.md)
  : Compile all codebooks into a data frame
- [`codebookRead()`](https://koenastam.github.io/beFAIR/reference/codebookRead.md)
  : Read a codebook by name
- [`getCodebookDescription()`](https://koenastam.github.io/beFAIR/reference/getCodebookDescription.md)
  : Get the description of a codebook
- [`viewCodebookMap()`](https://koenastam.github.io/beFAIR/reference/viewCodebookMap.md)
  : View Codebook Relationship Map (ERD Style)
- [`validateDatabook()`](https://koenastam.github.io/beFAIR/reference/validateDatabook.md)
  : Validate a databook against its codebook rules

## ETL Scripting

Set up projects and draft ETL scripts.

- [`startProject()`](https://koenastam.github.io/beFAIR/reference/startProject.md)
  : Create a FAIRground folder
- [`addStudy()`](https://koenastam.github.io/beFAIR/reference/addStudy.md)
  : Add a study to the FAIRground
- [`addExperiment()`](https://koenastam.github.io/beFAIR/reference/addExperiment.md)
  : Add an experiment to the FAIRground
- [`addAnalysis()`](https://koenastam.github.io/beFAIR/reference/addAnalysis.md)
  : Add an analysis to the FAIRground
- [`draftScript()`](https://koenastam.github.io/beFAIR/reference/draftScript.md)
  : Draft an ETL script for a study, experiment, or analysis

## Utilities

Helper functions for data retrieval, participant IDs, and harmonization.

- [`collectTable()`](https://koenastam.github.io/beFAIR/reference/collectTable.md)
  : Collect data table from database, optionally filtered by script_id

- [`collectTablesById()`](https://koenastam.github.io/beFAIR/reference/collectTablesById.md)
  : Collect all database tables linked to a study, experiment, or
  analysis ID

- [`entriesInDatabase()`](https://koenastam.github.io/beFAIR/reference/entriesInDatabase.md)
  : Check whether at least one row for a script_id exists in a data
  table

- [`getProjectInfo()`](https://koenastam.github.io/beFAIR/reference/getProjectInfo.md)
  : Retrieve all registry information for a project

- [`filterTableList()`](https://koenastam.github.io/beFAIR/reference/filterTableList.md)
  : Filter a table list by study IDs

- [`validateSourceId()`](https://koenastam.github.io/beFAIR/reference/validateSourceId.md)
  : Check whether source IDs exist in the ID mapping table

- [`FAIRgroundOverview()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundOverview.md)
  [`overviewFAIRground()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundOverview.md)
  : Generate an overview of beFAIR meta.yaml files

- [`plotDependencies()`](https://koenastam.github.io/beFAIR/reference/plotDependencies.md)
  : Plot the dependency graph for a table produced by an analysis

- [`getRelativeTimepoint()`](https://koenastam.github.io/beFAIR/reference/getRelativeTimepoint.md)
  : Convert timepoint descriptions to relative timepoints in days

- [`validateCytofExperiment()`](https://koenastam.github.io/beFAIR/reference/validateCytofExperiment.md)
  : Validate a CyTOF experiment

- [`tableSummary()`](https://koenastam.github.io/beFAIR/reference/tableSummary.md)
  :

  Summarise all variables in a codebook as a `gt` table

- [`tableVariableByStudy()`](https://koenastam.github.io/beFAIR/reference/tableVariableByStudy.md)
  :

  Summarise a codebook variable by study as a `gt` table

- [`harmonizeDate()`](https://koenastam.github.io/beFAIR/reference/harmonizeDate.md)
  : Convert a date string to ISO 8601 format

- [`harmonizeGates()`](https://koenastam.github.io/beFAIR/reference/harmonizeGates.md)
  :

  Takes a vector of gate strings, splits them into components,
  harmonizes the marker names, and reconstructs the gate strings with
  standardized marker names using `harmonizeMarkers`.

- [`harmonizeMarkers()`](https://koenastam.github.io/beFAIR/reference/harmonizeMarkers.md)
  : Harmonize cellular marker labels

- [`searchId()`](https://koenastam.github.io/beFAIR/reference/searchId.md)
  : Search for studies, experiments, or analyses by ID or name

## Data

External datasets used in the package

- [`HGNC`](https://koenastam.github.io/beFAIR/reference/HGNC.md) : HUGO
  Gene Nomenclature Committee (HGNC) data
- [`LUNC`](https://koenastam.github.io/beFAIR/reference/LUNC.md) : LUCID
  Nomenclature (LUNC) data
