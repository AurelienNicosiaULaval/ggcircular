test_that("model diagnostics work with mock angular objects", {
  object <- structure(
    list(
      y = c(0, 0.2, 0.4),
      mui = c(0.05, 0.15, 0.5),
      term_labels = c("intercept", "x")
    ),
    class = "angular"
  )
  data <- tibble::tibble(id = 1:3)

  res <- circular_residuals(object, data = data)

  expect_s3_class(tidy_circular(object), "tbl_df")
  expect_s3_class(augment_circular(object), "tbl_df")
  expect_s3_class(glance_circular(object), "tbl_df")
  expect_equal(nrow(res), 3)
  expect_equal(res$id, 1:3)
  expect_equal(res$.model_class, rep("angular", 3))
})

test_that("model diagnostics fail on incompatible extracted lengths", {
  object <- structure(
    list(y = c(0, 0.2, 0.4), mui = c(0.05, 0.15)),
    class = "angular"
  )
  object_ok <- structure(
    list(y = c(0, 0.2), mui = c(0.05, 0.15)),
    class = "angular"
  )

  expect_error(circular_residuals(object), "same length")
  expect_error(circular_residuals(object_ok, data = tibble::tibble(id = 1:3)), "same number of rows")
})

test_that("consensus class methods dispatch with mock objects", {
  fit <- structure(
    list(
      y = c(0, 0.2, 0.4),
      mui = c(0.05, 0.15, 0.5),
      term_labels = c("intercept", "x")
    ),
    class = "consensus"
  )

  expect_s3_class(tidy_circular(fit), "tbl_df")
  expect_s3_class(augment_circular(fit), "tbl_df")
  expect_s3_class(glance_circular(fit), "tbl_df")
  expect_s3_class(circular_residuals(fit), "tbl_df")
  expect_s3_class(circular_model_diagnostics(fit), "tbl_df")
  expect_s3_class(ggplot2::autoplot(fit, type = "residuals_rose"), "ggplot")
  expect_s3_class(ggplot2::autoplot(fit, type = "residuals_density"), "ggplot")
  expect_s3_class(ggplot2::autoplot(fit, type = "fitted_observed"), "ggplot")
  expect_s3_class(ggplot2::autoplot(fit, type = "residuals_index"), "ggplot")
})

test_that("angular_two_step methods dispatch with mock objects", {
  consensus_fit <- structure(
    list(y = c(0, 0.2, 0.4), mui = c(0.05, 0.15, 0.5), term_labels = "x"),
    class = "consensus"
  )
  homogeneous_fit <- structure(
    list(y = c(0, 0.2, 0.4), mui = c(0.04, 0.18, 0.45), term_labels = "x"),
    class = "angular"
  )
  fit <- structure(
    list(
      consensus_fit = consensus_fit,
      homogeneous_fit = homogeneous_fit,
      reference = "mock"
    ),
    class = "angular_two_step"
  )

  expect_s3_class(tidy_circular(fit), "tbl_df")
  expect_s3_class(augment_circular(fit), "tbl_df")
  expect_s3_class(glance_circular(fit), "tbl_df")
})
