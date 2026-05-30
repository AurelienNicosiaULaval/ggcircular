test_that("spherical coordinate conversions round-trip", {
  theta <- c(0, pi / 2, pi)
  phi <- c(pi / 2, pi / 3, pi / 4)
  cart <- spherical_to_cartesian(theta, phi)
  sph <- cartesian_to_spherical(cart$x, cart$y, cart$z)

  expect_equal(sph$theta, normalize_angle(theta), tolerance = 1e-10)
  expect_equal(sph$phi, phi, tolerance = 1e-10)
  expect_s3_class(spherical_summary(theta, phi), "tbl_df")
})

test_that("posterior draw helpers work when posterior is available", {
  testthat::skip_if_not_installed("posterior")
  set.seed(1)
  draws <- posterior::draws_df(theta = rnorm(40, 1, 0.1), phi = rnorm(40, 2, 0.2))
  circular_draws <- as_circular_draws(draws, variables = c("theta", "phi"))
  summaries <- summarise_circular_draws(circular_draws)

  expect_s3_class(circular_draws, "ggcircular_draws")
  expect_equal(length(unique(circular_draws$.variable)), 2)
  expect_equal(nrow(summaries), 2)
  expect_s3_class(autoplot_circular_draws(circular_draws), "ggplot")
  expect_s3_class(ggplot2::autoplot(circular_draws), "ggplot")
})

test_that("plot_state_angles returns ggplot objects", {
  expect_s3_class(plot_state_angles(animal_steps, angle = turn_angle, state = state), "ggplot")
  expect_s3_class(plot_state_angles(animal_steps, angle = turn_angle, state = state, type = "density"), "ggplot")
})
