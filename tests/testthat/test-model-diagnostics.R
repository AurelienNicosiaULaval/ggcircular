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

test_that("CircularRegression methods work when the optional package is available", {
  testthat::skip_if_not_installed("CircularRegression")
  set.seed(123)
  df <- tibble::tibble(
    y = normalize_angle(rnorm(50, mean = 1, sd = 0.4)),
    x = rnorm(50)
  )
  fit <- CircularRegression::consensus(y ~ x, data = df)

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

test_that("angular_two_step methods dispatch when available", {
  testthat::skip_if_not_installed("CircularRegression")
  set.seed(123)
  df <- tibble::tibble(
    y = normalize_angle(rnorm(40, mean = 1, sd = 0.5)),
    x = rnorm(40)
  )
  fit <- CircularRegression::angular_two_step(y ~ x, data = df)

  expect_s3_class(tidy_circular(fit), "tbl_df")
  expect_s3_class(augment_circular(fit), "tbl_df")
  expect_s3_class(glance_circular(fit), "tbl_df")
})
