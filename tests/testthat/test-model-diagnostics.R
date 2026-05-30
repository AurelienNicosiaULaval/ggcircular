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
