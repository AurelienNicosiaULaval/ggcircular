test_that("stat_vonmises is positive and integrates to one", {
  built <- ggplot2::ggplot_build(
    ggplot2::ggplot() +
      stat_vonmises(mu = 0, kappa = 2, n = 256)
  )$data[[1]]
  expect_true(all(built$density > 0))
  expect_equal(trapz(built$x, built$density), 1, tolerance = 0.05)
})

test_that("kappa zero gives a uniform density", {
  built <- ggplot2::ggplot_build(
    ggplot2::ggplot() +
      stat_vonmises(mu = 0, kappa = 0, n = 32)
  )$data[[1]]
  expect_equal(unique(built$density), 1 / (2 * pi), tolerance = 1e-12)
})

test_that("stat_vonmises_fit estimates a coherent density", {
  df <- tibble::tibble(theta = rnorm(100, mean = pi / 2, sd = 0.2))
  built <- ggplot2::ggplot_build(
    ggplot2::ggplot(df, ggplot2::aes(x = theta)) +
      stat_vonmises_fit(n = 128)
  )$data[[1]]
  expect_equal(nrow(built), 128)
  expect_true(all(built$density >= 0))
  expect_true(abs(normalize_angle(built$mu[1]) - pi / 2) < 0.2)
})
