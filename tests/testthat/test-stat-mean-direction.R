test_that("stat_mean_direction computes simple means", {
  df <- tibble::tibble(theta = c(0, 0, 0))
  built <- ggplot2::ggplot_build(
    ggplot2::ggplot(df, ggplot2::aes(x = theta)) +
      stat_mean_direction()
  )$data[[1]]
  expect_equal(built$mean, 0, tolerance = 1e-12)
  expect_true(built$Rbar >= 0)
  expect_true(built$Rbar <= 1)
})

test_that("stat_mean_direction handles groups and axial data", {
  df <- tibble::tibble(theta = c(0, 0, pi / 2, pi / 2), group = c("a", "a", "b", "b"))
  built <- ggplot2::ggplot_build(
    ggplot2::ggplot(df, ggplot2::aes(x = theta, colour = group)) +
      stat_mean_direction()
  )$data[[1]]
  expect_equal(nrow(built), 2)

  axial <- ggplot2::ggplot_build(
    ggplot2::ggplot(tibble::tibble(theta = c(0, pi)), ggplot2::aes(x = theta)) +
      stat_mean_direction(axial = TRUE)
  )$data[[1]]
  expect_equal(axial$Rbar, 1, tolerance = 1e-12)
})
