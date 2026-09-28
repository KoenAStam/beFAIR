# beFAIR 0.2.0

First public release.

## Features

* Project scaffolding: `startProject()`, `addStudy()`, `addExperiment()` and
  `addAnalysis()` create a structured FAIRground directory layout that links
  clinical studies, laboratory experiments and downstream analyses.
* Codebook-driven schemas: data tables are defined in YAML codebooks
  (`codebookRead()`, `codebookToTable()`, `codebookToEntries()`,
  `codebookToSummary()`), and beFAIR creates and maintains the matching SQL
  tables.
* Database management: `databaseInitialize()`, the `databasePrepare*()` family
  and `databaseUpdate()` build and refresh the FAIRground database, including
  project overviews (`databaseUpdateOverview()`) and linked publications
  (`databaseUpdatePublications()`). `databaseExport()` exports its contents.
* Reproducible ETL: `draftScript()` generates ETL script templates from
  codebooks (`codebookToDraft()`), and `sourceScript()` runs and tracks them.
  `plotDependencies()` visualises dependencies between scripts and tables.
* Validation: `validateDatabook()`, `validateSourceId()` and
  `validateCytofExperiment()` check data against codebook rules before
  loading, using pointblank.
* Harmonisation helpers: `harmonizeDate()`, `harmonizeGates()` and
  `getRelativeTimepoint()` align dates, cytometry gates and time points across
  studies. Participants get stable pseudonymised identifiers derived with
  SHA-256.
* Data access: `FAIRgroundConnect()`, `collectTable()`,
  `collectTablesById()`, `searchId()`, `tableSummary()` and
  `tableVariableByStudy()` query and join harmonised tables.
  `FAIRgroundOverview()` and `viewCodebookMap()` summarise what is in the
  database.

## Documentation

* Vignettes covering getting started, starting a project, adding studies,
  experiments and analyses, codebook configuration and reference, exploring
  and joining data tables, database smoke tests and developer internals.
* pkgdown website.

## Licensing and citation

* Released under the Apache License 2.0.
* Added `CITATION.cff` for software citation and Zenodo archiving.
