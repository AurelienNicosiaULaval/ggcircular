test_that("diagnostic scenario simulators return valid data", {
  scenarios <- diagnostic_scenarios()
  expect_true(all(c("space", "scenario", "expected") %in% names(scenarios)))
  expect_true(nrow(scenarios) >= 10)

  cyl <- simulate_cyl_diagnostic(n = 60, scenario = "smooth", seed = 101)
  tor <- simulate_tor_diagnostic(n = 70, scenario = "diagonal", seed = 102)

  expect_named(cyl, c("theta", "x", "scenario"))
  expect_named(tor, c("theta", "phi", "scenario"))
  expect_true(all(cyl$theta >= 0 & cyl$theta < 2 * pi))
  expect_true(all(tor$theta >= 0 & tor$theta < 2 * pi))
  expect_true(all(tor$phi >= 0 & tor$phi < 2 * pi))
  expect_true(all(is.finite(cyl$x)))
})

test_that("diagnostic atlas and classical comparisons build", {
  cyl <- simulate_cyl_diagnostic(n = 50, scenario = "independent", seed = 201)
  tor <- simulate_tor_diagnostic(n = 50, scenario = "independent_concentrated", seed = 202)

  atlas_cyl <- diagnostic_atlas_data("cylindrical", n = 35, seed = 203)
  atlas_tor <- diagnostic_atlas_data("toroidal", n = 35, seed = 204)

  expect_s3_class(atlas_cyl, "diagnostic_atlas_data")
  expect_s3_class(atlas_tor, "diagnostic_atlas_data")
  expect_true(all(c("theta", "theta_plot", "scenario_label", "space") %in% names(atlas_cyl)))
  expect_true(all(c("theta", "phi", "theta_plot", "phi_plot", "scenario_label", "space") %in% names(atlas_tor)))
  expect_s3_class(ggplot2::autoplot(atlas_cyl), "ggplot")
  expect_s3_class(ggplot2::autoplot(atlas_tor), "ggplot")
  expect_s3_class(plot_diagnostic_atlas("cylindrical", n = 35, seed = 203), "ggplot")
  expect_s3_class(plot_diagnostic_atlas("toroidal", n = 35, seed = 204), "ggplot")
  expect_s3_class(plot_classical_comparison(cyl, "cylindrical"), "ggplot")
  expect_s3_class(plot_classical_comparison(tor, "toroidal"), "ggplot")
})

test_that("bootstrap and sensitivity helpers return finite summaries", {
  cyl <- simulate_cyl_diagnostic(n = 70, scenario = "smooth", seed = 301)
  tor <- simulate_tor_diagnostic(n = 80, scenario = "diagonal", seed = 302)

  orbit_boot <- bootstrap_stat_orbit(cyl$theta, cyl$x, n_boot = 5, n_theta = 12, kappa = 8, seed = 303)
  ridge_boot <- bootstrap_toroidal_ridge(
    tor$theta,
    tor$phi,
    n_boot = 5,
    n_theta = 12,
    n_phi = 12,
    kappa_theta = 8,
    kappa_phi = 8,
    seed = 304
  )
  sens_cyl <- sensitivity_bandwidth_grid(cyl$theta, cyl$x, space = "cylindrical", kappa_values = c(6, 10))
  sens_tor <- sensitivity_bandwidth_grid(tor$theta, tor$phi, space = "toroidal", kappa_values = c(6, 10))

  expect_true(all(is.finite(orbit_boot$mu)))
  expect_true(all(is.finite(ridge_boot$rho)))
  expect_s3_class(orbit_boot, "bootstrap_stat_orbit")
  expect_s3_class(ridge_boot, "bootstrap_toroidal_ridge")
  expect_s3_class(ggplot2::autoplot(orbit_boot), "ggplot")
  expect_s3_class(ggplot2::autoplot(orbit_boot, quantity = "sigma"), "ggplot")
  expect_s3_class(ggplot2::autoplot(ridge_boot), "ggplot")
  expect_s3_class(ggplot2::autoplot(ridge_boot, quantity = "ridge"), "ggplot")
  expect_equal(nrow(sens_cyl), 2)
  expect_equal(nrow(sens_tor), 2)
})

test_that("cross-validated smoothing selection ranks finite candidates", {
  cyl <- simulate_cyl_diagnostic(n = 80, scenario = "smooth", seed = 305)
  tor <- simulate_tor_diagnostic(n = 90, scenario = "diagonal", seed = 306)

  cyl_selection <- select_cyl_smoothing(
    cyl$theta,
    cyl$x,
    kappa_values = c(6, 10),
    h_values = c(0.25, 0.45),
    n_folds = 3,
    seed = 307
  )
  tor_selection <- select_toroidal_smoothing(
    tor$theta,
    tor$phi,
    kappa_theta_values = c(6, 10),
    kappa_phi_values = c(6, 10),
    n_folds = 3,
    seed = 308
  )

  expect_s3_class(cyl_selection, "directional_smoothing_selection")
  expect_s3_class(tor_selection, "directional_smoothing_selection")
  expect_true(all(is.finite(cyl_selection$mean_log_score)))
  expect_true(all(is.finite(tor_selection$mean_log_score)))
  expect_equal(cyl_selection$rank, seq_len(nrow(cyl_selection)))
  expect_equal(tor_selection$rank, seq_len(nrow(tor_selection)))
  expect_true(cyl_selection$mean_log_score[1] >= cyl_selection$mean_log_score[nrow(cyl_selection)])
  expect_true(tor_selection$mean_log_score[1] >= tor_selection$mean_log_score[nrow(tor_selection)])
})

test_that("marginal support flags sparse angular regions", {
  theta <- c(stats::runif(80, 0, pi / 3), stats::runif(80, pi, 4 * pi / 3))
  support <- marginal_support_data(theta, n_theta = 40, kappa = 12, relative_threshold = 0.35)

  expect_equal(nrow(support), 40)
  expect_true(all(c("theta", "support", "relative_support", "low_support") %in% names(support)))
  expect_true(all(support$relative_support >= 0 & support$relative_support <= 1))
  expect_true(any(support$low_support))
  expect_s3_class(plot_marginal_support(theta, n_theta = 40, kappa = 12), "ggplot")
})

test_that("independence lineups keep one true panel and m plots", {
  cyl <- simulate_cyl_diagnostic(n = 40, scenario = "smooth", seed = 401)
  lineup <- simulate_independence_lineup(
    cyl,
    plot_fun = function(d) {
      ggplot2::ggplot(d, ggplot2::aes(theta, x)) + ggplot2::geom_point()
    },
    m = 5,
    seed = 402,
    space = "cylindrical"
  )

  expect_s3_class(lineup, "directional_lineup")
  expect_equal(length(lineup$plots), 5)
  expect_true(lineup$true_position >= 1 && lineup$true_position <= 5)
  expect_true(all(vapply(lineup$plots, inherits, logical(1), "ggplot")))
})
