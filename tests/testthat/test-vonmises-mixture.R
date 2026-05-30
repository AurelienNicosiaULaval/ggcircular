test_that("fit_vonmises_mixture returns coherent components", {
  set.seed(1)
  x <- c(rnorm(80, 0, 0.2), rnorm(80, pi, 0.2))
  fit <- fit_vonmises_mixture(x, k = 2, max_iter = 100)

  expect_s3_class(fit, "ggcircular_vonmises_mixture")
  expect_equal(sum(fit$proportions), 1, tolerance = 1e-10)
  expect_true(all(fit$kappa >= 0))
  expect_equal(ncol(fit$responsibilities), 2)
  expect_s3_class(tidy_circular(fit), "tbl_df")
  expect_s3_class(augment_circular(fit), "tbl_df")
  expect_s3_class(glance_circular(fit), "tbl_df")
  expect_s3_class(ggplot2::autoplot(fit), "ggplot")
})

test_that("stat_vonmises_mixture builds from data and fitted objects", {
  set.seed(1)
  df <- tibble::tibble(theta = c(rnorm(40, 0, 0.2), rnorm(40, pi, 0.2)))
  fit <- fit_vonmises_mixture(df$theta, k = 2, max_iter = 100)

  built_data <- ggplot2::ggplot_build(
    ggplot2::ggplot(df, ggplot2::aes(x = theta)) +
      stat_vonmises_mixture(k = 2, n = 64)
  )$data[[1]]
  built_fit <- ggplot2::ggplot_build(
    ggplot2::ggplot() +
      stat_vonmises_mixture(fit = fit, n = 64)
  )$data[[1]]

  expect_equal(nrow(built_data), 64)
  expect_equal(nrow(built_fit), 64)
  expect_true(all(built_data$density >= 0))
  expect_true(all(built_fit$density >= 0))
})
