test_that("circular_mean_ci supports large-sample and bootstrap methods", {
  x <- c(0, 0.1, -0.1, 0.05, -0.05)
  large <- circular_mean_ci(x, method = "large_sample")
  boot <- circular_mean_ci(x, method = "bootstrap", R = 30, seed = 1)

  expect_s3_class(large, "tbl_df")
  expect_s3_class(boot, "tbl_df")
  expect_equal(large$n, length(x))
  expect_equal(boot$n, length(x))
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
