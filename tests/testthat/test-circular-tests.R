test_that("circular_mean_ci supports large-sample and bootstrap methods", {
  x <- c(0, 0.1, -0.1, 0.05, -0.05)
  large <- circular_mean_ci(x, method = "large_sample")
  boot <- circular_mean_ci(x, method = "bootstrap", R = 30, seed = 1)

  expect_s3_class(large, "tbl_df")
  expect_s3_class(boot, "tbl_df")
  expect_equal(large$n, length(x))
  expect_equal(boot$n, length(x))
})

test_that("circular_mean_ci validates scalar inputs", {
  x <- c(0, 0.1, -0.1)

  expect_error(circular_mean_ci(x, level = 1), "`level`")
  expect_error(circular_mean_ci(x, level = NA_real_), "`level`")
  expect_error(circular_mean_ci(x, R = 0), "`R`")
  expect_error(circular_mean_ci(x, R = 1.5), "`R`")
  expect_error(circular_mean_ci(x, seed = NA_real_), "`seed`")
  expect_error(circular_mean_ci(x, axial = NA), "`axial`")
})

test_that("circular_mean_ci handles axial, weak and wrapped intervals", {
  axial <- circular_mean_ci(c(0, pi - 0.05, 0.02, pi - 0.02), axial = TRUE)
  weak <- circular_mean_ci(c(0, pi / 2, pi, 3 * pi / 2), method = "large_sample")
  wrapped <- circular_mean_ci(c(-0.03, 0, 0.03), method = "large_sample")

  expect_true(axial$mean >= 0)
  expect_true(axial$mean < pi)
  expect_true(is.na(weak$mean))
  expect_true(is.na(weak$lower))
  expect_true(is.na(weak$upper))
  expect_gt(wrapped$lower, wrapped$upper)
})

test_that("circular_mean_ci bootstrap is reproducible with seed", {
  x <- c(rnorm(30, 0, 0.1), rnorm(30, 0.2, 0.1))
  one <- circular_mean_ci(x, method = "bootstrap", R = 50, seed = 123)
  two <- circular_mean_ci(x, method = "bootstrap", R = 50, seed = 123)

  expect_equal(one, two)
})

test_that("rayleigh_test returns htest and stat_circular_test builds", {
  x <- c(0, 0.1, -0.1, 0.05, -0.05)
  expect_s3_class(rayleigh_test(x), "htest")

  built <- ggplot2::ggplot_build(
    ggplot2::ggplot(tibble::tibble(theta = x), ggplot2::aes(x = theta)) +
      stat_circular_test(test = "rayleigh")
  )$data[[1]]
  expect_equal(nrow(built), 1)
  expect_match(built$label, "p =")
})

test_that("watson_williams_test delegates to circular when available", {
  testthat::skip_if_not_installed("circular")
  x <- c(0, 0.1, -0.1, 0.3, 0.4, 0.2)
  group <- rep(c("a", "b"), each = 3)
  expect_s3_class(watson_williams_test(x, group), "htest")
})
