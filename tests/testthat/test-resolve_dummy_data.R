test_that("resolves to TESTground parent when inside marker", {
  tmp <- file.path(tempdir(), "TESTground", "project", "sub", "dir")
  dir.create(tmp, recursive = TRUE, showWarnings = FALSE)
  old <- setwd(tmp)
  on.exit(setwd(old), add = TRUE)

  result <- .resolve_dummy_data("data/CoHSI1/foo.csv")
  expected <- file.path(dirname(file.path(tempdir(), "TESTground", "project")), "data/CoHSI1/foo.csv")
  expect_equal(result, expected)
})

test_that("resolves when working directory IS the marker folder", {
  tmp <- file.path(tempdir(), "TESTground", "project")
  dir.create(tmp, recursive = TRUE, showWarnings = FALSE)
  old <- setwd(tmp)
  on.exit(setwd(old), add = TRUE)

  result <- .resolve_dummy_data("data/CoHSI1/foo.csv")
  expected <- file.path(dirname(tmp), "data/CoHSI1/foo.csv")
  expect_equal(result, expected)
})

test_that("falls back to system.file when outside marker", {
  old <- setwd(tempdir())
  on.exit(setwd(old), add = TRUE)

  result <- .resolve_dummy_data("data/CoHSI1/CoHSI1_studyinfo.csv")
  expect_true(is.character(result) && length(result) == 1)
  # system.file returns "" when the file/package is absent; both are valid
  expect_true(nchar(result) == 0 || file.exists(result))
})

test_that("custom marker is respected", {
  tmp <- file.path(tempdir(), "myroot", "work")
  dir.create(tmp, recursive = TRUE, showWarnings = FALSE)
  old <- setwd(tmp)
  on.exit(setwd(old), add = TRUE)

  result <- .resolve_dummy_data("data/something.csv", marker = "myroot/work")
  expected <- file.path(dirname(tmp), "data/something.csv")
  expect_equal(result, expected)
})
