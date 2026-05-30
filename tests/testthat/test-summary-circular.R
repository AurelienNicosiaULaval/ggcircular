test_that("basic circular summaries are correct", {
  expect_equal(mean_direction(c(0, 0, 0)), 0)
  expect_lt(mean_resultant_length(c(0, pi)), 1e-12)
  expect_true(mean_resultant_length(c(0, pi / 2, pi)) >= 0)
  expect_true(mean_resultant_length(c(0, pi / 2, pi)) <= 1)
  expect_gt(estimate_kappa(c(0, 0.1, -0.1)), 0)
})

test_that("circular_summary works with grouped data", {
  df <- tibble::tibble(group = c("a", "a", "b", "b"), theta = c(0, 0, pi / 2, pi / 2))
  out <- df |>
    dplyr::group_by(group) |>
    circular_summary(theta)
  expect_s3_class(out, "ggcircular_summary")
  expect_equal(nrow(out), 2)
  expect_equal(out$n, c(2L, 2L))
  expect_equal(out$Rbar, c(1, 1), tolerance = 1e-12)
})

test_that("axial summaries respect modulo pi", {
  x <- c(0, pi)
  expect_equal(mean_resultant_length(x, axial = TRUE), 1, tolerance = 1e-12)
  expect_equal(mean_direction(x, axial = TRUE), 0, tolerance = 1e-12)
})
