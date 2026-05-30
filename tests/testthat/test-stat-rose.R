test_that("stat_rose counts and proportions are coherent", {
  df <- tibble::tibble(theta = c(0, pi / 4, pi / 2, pi, 2 * pi - 1e-8))
  built <- ggplot2::ggplot_build(
    ggplot2::ggplot(df, ggplot2::aes(x = theta)) +
      geom_rose(bins = 4)
  )$data[[1]]
  expect_equal(sum(built$count), nrow(df))
  expect_equal(sum(built$proportion), 1, tolerance = 1e-12)
  expect_equal(nrow(built), 4)
  expect_equal(min(built$xmin), 0, tolerance = 1e-12)
  expect_equal(max(built$xmax), 2 * pi, tolerance = 1e-12)
})

test_that("stat_rose handles axial data", {
  df <- tibble::tibble(theta = c(0, pi / 4, pi / 2, pi - 1e-8))
  built <- ggplot2::ggplot_build(
    ggplot2::ggplot(df, ggplot2::aes(x = theta)) +
      geom_rose(bins = 4, axial = TRUE)
  )$data[[1]]
  expect_equal(sum(built$count), nrow(df))
  expect_equal(max(built$xmax), pi, tolerance = 1e-12)
})

test_that("stat_rose treats groups separately", {
  df <- tibble::tibble(theta = rep(c(0, pi / 2), 2), group = rep(c("a", "b"), each = 2))
  built <- ggplot2::ggplot_build(
    ggplot2::ggplot(df, ggplot2::aes(x = theta, fill = group)) +
      geom_rose(bins = 4)
  )$data[[1]]
  expect_equal(sum(built$count), nrow(df))
  expect_equal(length(unique(built$group)), 2)
})
