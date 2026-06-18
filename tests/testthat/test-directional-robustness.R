test_that("seam-near angles are treated as neighbors", {
  left <- 0.02
  right <- 2 * pi - 0.02

  expect_equal(abs(angular_difference(left, right)), 0.04, tolerance = 1e-12)

  theta <- c(stats::runif(80, 0, 0.08), stats::runif(80, 2 * pi - 0.08, 2 * pi))
  x <- stats::rnorm(length(theta))
  support <- marginal_support_data(theta, n_theta = 40, kappa = 20)

  near_zero <- support$theta < 0.20 | support$theta > 2 * pi - 0.20
  expect_true(mean(support$relative_support[near_zero]) > 0.50)
  expect_length(x, length(theta))
})

test_that("toroidal ridge recovers a diagonal relation with circular error", {
  dat <- simulate_tor_diagnostic(n = 260, scenario = "diagonal", seed = 701)
  ridge <- toroidal_ridge_data(
    dat$theta,
    dat$phi,
    n_theta = 60,
    n_phi = 72,
    kappa_theta = 24,
    kappa_phi = 24
  )

  rmse <- sqrt(mean(angular_difference(ridge$phi, ridge$theta)^2))
  expect_lt(rmse, 0.25)
})

test_that("non-finite inputs fail predictably", {
  dat <- simulate_cyl_diagnostic(n = 80, scenario = "smooth", seed = 702)
  dat$x[3] <- NA_real_

  expect_error(
    estimate_cyl_density(dat$theta, dat$x, n_theta = 20, n_x = 20),
    "finite"
  )
  expect_error(
    plot_circular_topography(dat$theta, dat$x, n_theta = 20, n_x = 20),
    "finite"
  )
})

test_that("smoothing selection is reproducible with a fixed seed", {
  cyl <- simulate_cyl_diagnostic(n = 90, scenario = "smooth", seed = 703)
  tor <- simulate_tor_diagnostic(n = 90, scenario = "diagonal", seed = 704)

  cyl_a <- select_cyl_smoothing(
    cyl$theta,
    cyl$x,
    kappa_values = c(8, 14),
    h_values = c(0.25, 0.45),
    n_folds = 3,
    seed = 705
  )
  cyl_b <- select_cyl_smoothing(
    cyl$theta,
    cyl$x,
    kappa_values = c(8, 14),
    h_values = c(0.25, 0.45),
    n_folds = 3,
    seed = 705
  )
  expect_equal(cyl_a, cyl_b)

  tor_a <- select_toroidal_smoothing(
    tor$theta,
    tor$phi,
    kappa_theta_values = c(8, 14),
    kappa_phi_values = c(8, 14),
    n_folds = 3,
    seed = 706
  )
  tor_b <- select_toroidal_smoothing(
    tor$theta,
    tor$phi,
    kappa_theta_values = c(8, 14),
    kappa_phi_values = c(8, 14),
    n_folds = 3,
    seed = 706
  )
  expect_equal(tor_a, tor_b)
})

test_that("density estimators stay finite under concentrated smoothing", {
  cyl <- simulate_cyl_diagnostic(n = 90, scenario = "seam", seed = 707)
  tor <- simulate_tor_diagnostic(n = 90, scenario = "doubling", seed = 708)

  cyl_est <- estimate_cyl_density(
    cyl$theta,
    cyl$x,
    n_theta = 24,
    n_x = 30,
    kappa = 60,
    h = 0.20,
    conditional = TRUE
  )
  tor_est <- estimate_toroidal_density(
    tor$theta,
    tor$phi,
    n_theta = 24,
    n_phi = 24,
    kappa_theta = 60,
    kappa_phi = 60,
    conditional = TRUE
  )

  expect_true(all(is.finite(cyl_est$density)))
  expect_true(all(is.finite(tor_est$density)))
})
