test_that("directional angle helpers respect circular geometry", {
  wrapped <- normalize_angle(c(-pi, 0, 2 * pi, 5 * pi))
  expect_true(all(wrapped >= 0))
  expect_true(all(wrapped < 2 * pi))
  expect_equal(angular_difference(0, 2 * pi), 0, tolerance = 1e-12)
  expect_equal(abs(angular_difference(pi / 2, 3 * pi / 2)), pi, tolerance = 1e-12)
})

test_that("directional simulators return finite data in the expected spaces", {
  cyl <- simulate_cylindrical(n = 80, scenario = "nonlinear", seed = 10)
  tor <- simulate_toroidal(n = 90, scenario = "multimodal", seed = 11)

  expect_named(cyl, c("theta", "x", "scenario"))
  expect_named(tor, c("theta", "phi", "scenario"))
  expect_true(all(cyl$theta >= 0 & cyl$theta < 2 * pi))
  expect_true(all(tor$theta >= 0 & tor$theta < 2 * pi))
  expect_true(all(tor$phi >= 0 & tor$phi < 2 * pi))
  expect_true(all(is.finite(cyl$x)))
})

test_that("conditional density estimates are row-normalized", {
  cyl <- simulate_cylindrical(n = 100, scenario = "heteroscedastic", seed = 12)
  est_cyl <- estimate_cyl_density(cyl$theta, cyl$x, n_theta = 24, n_x = 50, conditional = TRUE)
  dx <- mean(diff(est_cyl$x_grid))
  expect_equal(rowSums(est_cyl$density) * dx, rep(1, length(est_cyl$theta_grid)), tolerance = 1e-8)

  tor <- simulate_toroidal(n = 100, scenario = "diagonal", seed = 13)
  est_tor <- estimate_toroidal_density(tor$theta, tor$phi, n_theta = 24, n_phi = 36, conditional = TRUE)
  dphi <- mean(diff(est_tor$phi_grid))
  expect_equal(rowSums(est_tor$density) * dphi, rep(1, length(est_tor$theta_grid)), tolerance = 1e-8)
})

test_that("phase loom supports conditional sector masses", {
  theta <- rep(seq(0.1, 2 * pi - 0.1, length.out = 8), each = 4)
  x <- rep(c(-1, -1, 1, 1), times = 8)

  joint <- phase_loom_data(theta, x, n_sectors = 8, n_x_bins = 2, min_mass = 0, max_flows = NULL)
  conditional <- phase_loom_data(
    theta,
    x,
    n_sectors = 8,
    n_x_bins = 2,
    min_mass = 0,
    max_flows = NULL,
    mass_type = "conditional"
  )

  expect_equal(sum(joint$mass), 1, tolerance = 1e-12)
  expect_equal(as.numeric(rowsum(conditional$mass, conditional$sector)), rep(1, 8), tolerance = 1e-12)
})

test_that("toroidal flow supports conditional theta-sector masses", {
  theta <- rep(seq(0.1, 2 * pi - 0.1, length.out = 8), each = 4)
  phi <- rep(c(0.1, 0.1, pi, pi), times = 8)

  joint <- toroidal_flow_data(theta, phi, n_sectors = 8, min_mass = 0)
  conditional <- toroidal_flow_data(
    theta,
    phi,
    n_sectors = 8,
    min_mass = 0,
    mass_type = "conditional"
  )

  expect_equal(sum(joint$mass), 1, tolerance = 1e-12)
  expect_equal(as.numeric(rowsum(conditional$mass, conditional$theta_sector)), rep(1, 8), tolerance = 1e-12)
})

test_that("indicator and data helpers return usable values", {
  tor <- simulate_toroidal(n = 120, scenario = "diagonal", seed = 14)
  expect_true(alignment_index(tor$theta, tor$phi) > 0.65)

  moment <- local_circ_moment(tor$theta, tor$phi, grid = seq(0, 2 * pi, length.out = 20))
  expect_equal(nrow(moment), 20)
  expect_true(all(moment$rho >= 0 & moment$rho <= 1))

  flows <- toroidal_flow_data(tor$theta, tor$phi, n_sectors = 16, min_mass = 0)
  expect_true(all(flows$mass > 0))
  expect_equal(sum(flows$mass), 1, tolerance = 1e-12)
})
