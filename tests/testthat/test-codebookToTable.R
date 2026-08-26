test_that("codebookToTable returns a data frame with codebook_origin column", {
  result <- codebookToTable()

  expect_s3_class(result, "data.frame")
  expect_true("codebook_origin" %in% names(result),
              info = "codebook_origin column must be present")
})

test_that("codebookToTable sets codebook_origin to 'beFAIR' for all built-in codebooks", {
  result <- codebookToTable()

  expect_true(nrow(result) > 0, info = "Should have at least one codebook row")
  expect_true(all(result$codebook_origin == "beFAIR"),
              info = "All built-in codebook rows must have codebook_origin = 'beFAIR'")
})

test_that("codebookToTable detects custom codebooks in codebooks/custom/ and sets codebook_origin", {
  tmp <- tempfile("fp_custom_test")
  dir.create(file.path(tmp, "codebooks", "custom"), recursive = TRUE)

  # Write a minimal valid codebook YAML
  yaml_content <- c(
    "version: 1.0",
    "name: test_custom_assay",
    "authors: Test Author",
    "created_at: 2026-01-01",
    "updated_at: 2026-01-01",
    "variables:",
    "  source_id:",
    "    description: Sample ID",
    "    type: character",
    "    type_sql: VARCHAR(255)"
  )
  writeLines(yaml_content,
             file.path(tmp, "codebooks", "custom", "test_custom_assay.yaml"))

  old_wd <- getwd()
  on.exit(setwd(old_wd), add = TRUE)
  setwd(tmp)

  result <- codebookToTable()

  custom_rows <- result[result$codebook_origin != "beFAIR", , drop = FALSE]
  expect_equal(nrow(custom_rows), 1L)
  expect_equal(custom_rows$codebook_name, "test_custom_assay")
  expect_equal(custom_rows$codebook_origin, basename(tmp))
  expect_equal(custom_rows$codebook_id, "custom/test_custom_assay",
               info = "Custom codebook_id should be 'custom/<name>'")
})

test_that("codebookToTable warns when deprecated pillar subdirectories exist", {
  tmp <- tempfile("fp_deprecated_test")
  dir.create(file.path(tmp, "codebooks", "experiment"), recursive = TRUE)

  old_wd <- getwd()
  on.exit(setwd(old_wd), add = TRUE)
  setwd(tmp)

  expect_warning(codebookToTable(), "Deprecated")
})

test_that("codebookToTable stops when a custom codebook conflicts with a built-in one", {
  tmp <- tempfile("fp_conflict_test")
  dir.create(file.path(tmp, "codebooks", "custom"), recursive = TRUE)

  # 'participant' is a built-in codebook — placing it in codebooks/custom/ should error
  yaml_content <- c(
    "version: 1.0",
    "name: participant",
    "authors: Conflict Test",
    "created_at: 2026-01-01",
    "updated_at: 2026-01-01",
    "variables:",
    "  source_id:",
    "    description: Sample ID",
    "    type: character",
    "    type_sql: VARCHAR(255)"
  )
  writeLines(yaml_content,
             file.path(tmp, "codebooks", "custom", "participant.yaml"))

  old_wd <- getwd()
  on.exit(setwd(old_wd), add = TRUE)
  setwd(tmp)

  expect_error(codebookToTable(), "conflict")
})
