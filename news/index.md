# Changelog

## beFAIR 0.3.0

### Documentation

- Updated and expanded vignettes.
- Fixed pkgdown configuration so the online documentation site builds
  and renders correctly.

## beFAIR 0.2.3

### Bug fixes

- The
  [`startProject()`](https://koenastam.github.io/beFAIR/reference/startProject.md)
  sandbox now works correctly with SQLite backends.
- [`databaseUpdate()`](https://koenastam.github.io/beFAIR/reference/databaseUpdate.md)
  no longer exits automatically on connection failure; database and
  connection info is gathered without forcing an early return.

### Internal

- Removed leftover internal references to the old package name.

## beFAIR 0.2.0

First public release.

### Features

- Project scaffolding:
  [`startProject()`](https://koenastam.github.io/beFAIR/reference/startProject.md),
  [`addStudy()`](https://koenastam.github.io/beFAIR/reference/addStudy.md),
  [`addExperiment()`](https://koenastam.github.io/beFAIR/reference/addExperiment.md)
  and
  [`addAnalysis()`](https://koenastam.github.io/beFAIR/reference/addAnalysis.md)
  create a structured FAIRground directory layout that links clinical
  studies, laboratory experiments and downstream analyses.
- Codebook-driven schemas: data tables are defined in YAML codebooks
  ([`codebookRead()`](https://koenastam.github.io/beFAIR/reference/codebookRead.md),
  [`codebookToTable()`](https://koenastam.github.io/beFAIR/reference/codebookToTable.md),
  [`codebookToEntries()`](https://koenastam.github.io/beFAIR/reference/codebookToEntries.md),
  [`codebookToSummary()`](https://koenastam.github.io/beFAIR/reference/codebookToSummary.md)),
  and beFAIR creates and maintains the matching SQL tables.
- Database management:
  [`databaseInitialize()`](https://koenastam.github.io/beFAIR/reference/databaseInitialize.md),
  the `databasePrepare*()` family and
  [`databaseUpdate()`](https://koenastam.github.io/beFAIR/reference/databaseUpdate.md)
  build and refresh the FAIRground database, including project overviews
  ([`databaseUpdateOverview()`](https://koenastam.github.io/beFAIR/reference/databaseUpdateOverview.md))
  and linked publications
  ([`databaseUpdatePublications()`](https://koenastam.github.io/beFAIR/reference/databaseUpdatePublications.md)).
  [`databaseExport()`](https://koenastam.github.io/beFAIR/reference/databaseExport.md)
  exports its contents.
- Reproducible ETL:
  [`draftScript()`](https://koenastam.github.io/beFAIR/reference/draftScript.md)
  generates ETL script templates from codebooks
  ([`codebookToDraft()`](https://koenastam.github.io/beFAIR/reference/codebookToDraft.md)),
  and
  [`sourceScript()`](https://koenastam.github.io/beFAIR/reference/sourceScript.md)
  runs and tracks them.
  [`plotDependencies()`](https://koenastam.github.io/beFAIR/reference/plotDependencies.md)
  visualises dependencies between scripts and tables.
- Validation:
  [`validateDatabook()`](https://koenastam.github.io/beFAIR/reference/validateDatabook.md),
  [`validateSourceId()`](https://koenastam.github.io/beFAIR/reference/validateSourceId.md)
  and
  [`validateCytofExperiment()`](https://koenastam.github.io/beFAIR/reference/validateCytofExperiment.md)
  check data against codebook rules before loading, using pointblank.
- Harmonisation helpers:
  [`harmonizeDate()`](https://koenastam.github.io/beFAIR/reference/harmonizeDate.md),
  [`harmonizeGates()`](https://koenastam.github.io/beFAIR/reference/harmonizeGates.md)
  and
  [`getRelativeTimepoint()`](https://koenastam.github.io/beFAIR/reference/getRelativeTimepoint.md)
  align dates, cytometry gates and time points across studies.
  Participants get stable pseudonymised identifiers derived with
  SHA-256.
- Data access:
  [`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md),
  [`collectTable()`](https://koenastam.github.io/beFAIR/reference/collectTable.md),
  [`collectTablesById()`](https://koenastam.github.io/beFAIR/reference/collectTablesById.md),
  [`searchId()`](https://koenastam.github.io/beFAIR/reference/searchId.md),
  [`tableSummary()`](https://koenastam.github.io/beFAIR/reference/tableSummary.md)
  and
  [`tableVariableByStudy()`](https://koenastam.github.io/beFAIR/reference/tableVariableByStudy.md)
  query and join harmonised tables.
  [`FAIRgroundOverview()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundOverview.md)
  and
  [`viewCodebookMap()`](https://koenastam.github.io/beFAIR/reference/viewCodebookMap.md)
  summarise what is in the database.

### Documentation

- Vignettes covering getting started, starting a project, adding
  studies, experiments and analyses, codebook configuration and
  reference, exploring and joining data tables, database smoke tests and
  developer internals.
- pkgdown website.

### Licensing and citation

- Released under the Apache License 2.0.
- Added `CITATION.cff` for software citation and Zenodo archiving.
