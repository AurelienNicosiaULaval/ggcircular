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

test_that("signed toroidal wrappers retain the full angular sample", {
  dat <- simulate_tor_diagnostic(n = 240, scenario = "doubling", seed = 709)
  expect_true(any(dat$theta > pi))
  expect_true(any(dat$phi > pi))

  plot <- plot_toroidal_topography(
    dat$theta,
    dat$phi,
    conditional = TRUE,
    n_theta = 24,
    n_phi = 24,
    kappa_theta = 14,
    kappa_phi = 14
  )
  built <- expect_warning(ggplot2::ggplot_build(plot), NA)
  layer <- built$data[[1]][order(built$data[[1]]$theta, built$data[[1]]$phi), ]
  direct <- toroidal_topography_data(
    dat$theta,
    dat$phi,
    conditional = TRUE,
    n_theta = 24,
    n_phi = 24,
    kappa_theta = 14,
    kappa_phi = 14
  )
  direct <- direct[order(direct$theta, direct$phi), ]
  contour <- plot$layers[[2]]$data
  contour <- contour[order(contour$theta, contour$phi), ]

  expect_equal(nrow(layer), 24 * 24)
  expect_equal(layer$density, direct$density, tolerance = 1e-12)
  expect_equal(layer$density, contour$density, tolerance = 1e-12)
})

test_that("cylindrical fill and contours use the same conditional density", {
  dat <- simulate_cyl_diagnostic(n = 180, scenario = "smooth", seed = 712)
  plot <- plot_circular_topography(
    dat$theta,
    dat$x,
    conditional = TRUE,
    n_theta = 24,
    n_x = 30,
    kappa = 14
  )
  built <- expect_warning(ggplot2::ggplot_build(plot), NA)
  fill <- built$data[[1]][order(built$data[[1]]$theta, built$data[[1]]$x), ]
  contour <- plot$layers[[2]]$data
  contour <- contour[order(contour$theta, contour$x), ]

  expect_equal(nrow(fill), 24 * 30)
  expect_equal(fill$density, contour$density, tolerance = 1e-12)
})

test_that("ridge near-tie diagnostics preserve first-maximum selection", {
  theta <- rep(seq(0, 2 * pi, length.out = 33)[-33], each = 2)
  phi <- c(rbind(theta[seq(1, length(theta), by = 2)], theta[seq(1, length(theta), by = 2)] + pi))
  phi <- normalize_angle(phi)

  ridge <- toroidal_ridge_data(
    theta,
    phi,
    n_theta = 24,
    n_phi = 32,
    kappa_theta = 18,
    kappa_phi = 24,
    tie_tolerance = 0.01
  )

  expect_true(all(c("n_local_modes", "secondary_mode_ratio", "ridge_ambiguous") %in% names(ridge)))
  expect_true(mean(ridge$ridge_ambiguous) > 0.80)
  expect_true(all(ridge$secondary_mode_ratio[ridge$ridge_ambiguous] >= 0.99))

  legacy_choice <- max.col(
    estimate_toroidal_density(
      theta,
      phi,
      n_theta = 24,
      n_phi = 32,
      kappa_theta = 18,
      kappa_phi = 24,
      conditional = TRUE
    )$density,
    ties.method = "first"
  )
  phi_grid <- directional_angle_grid(32)
  expect_equal(ridge$phi, phi_grid[legacy_choice])
})

test_that("toroidal bootstrap intervals use circular radii", {
  dat <- simulate_tor_diagnostic(n = 180, scenario = "diagonal", seed = 710)
  boot <- bootstrap_toroidal_ridge(
    dat$theta,
    dat$phi,
    n_boot = 30,
    n_theta = 24,
    n_phi = 32,
    kappa_theta = 14,
    kappa_phi = 14,
    level = 0.95,
    seed = 711
  )

  expect_true(all(is.finite(boot$phi_center)))
  expect_true(all(boot$phi_center >= 0 & boot$phi_center < 2 * pi))
  expect_true(all(boot$phi_radius >= 0 & boot$phi_radius <= pi))
  expect_true(all(boot$level == 0.95))
  expect_s3_class(ggplot2::autoplot(boot, quantity = "ridge"), "ggplot")
  expect_warning(ggplot2::ggplot_build(ggplot2::autoplot(boot, quantity = "ridge")), NA)
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
