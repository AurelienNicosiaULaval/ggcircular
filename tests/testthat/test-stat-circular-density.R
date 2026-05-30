trapz <- function(x, y) {
  sum(diff(x) * (head(y, -1) + tail(y, -1)) / 2)
}

test_that("stat_circular_density is positive and integrates to one", {
  df <- tibble::tibble(theta = c(0, pi / 3, pi / 2, pi, 5 * pi / 3))
  built <- ggplot2::ggplot_build(
    ggplot2::ggplot(df, ggplot2::aes(x = theta)) +
      stat_circular_density(n = 256)
  )$data[[1]]
  expect_true(all(built$density > 0))
  expect_equal(nrow(built), 256)
  expect_equal(trapz(built$x, built$density), 1, tolerance = 0.05)
})

test_that("stat_circular_density supports groups and axial data", {
  df <- tibble::tibble(theta = rep(c(0, pi / 4, pi / 2), 2), group = rep(c("a", "b"), each = 3))
  grouped <- ggplot2::ggplot_build(
    ggplot2::ggplot(df, ggplot2::aes(x = theta, colour = group)) +
      stat_circular_density(n = 64)
  )$data[[1]]
  expect_equal(length(unique(grouped$group)), 2)

  axial <- ggplot2::ggplot_build(
    ggplot2::ggplot(df, ggplot2::aes(x = theta)) +
      stat_circular_density(n = 128, axial = TRUE)
  )$data[[1]]
  expect_equal(max(axial$x), pi, tolerance = 1e-12)
  expect_equal(trapz(axial$x, axial$density), 1, tolerance = 0.05)
})
