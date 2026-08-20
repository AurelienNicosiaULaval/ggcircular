test_that("directional visualization functions return ggplot objects", {
  cyl <- simulate_cylindrical(n = 120, scenario = "nonlinear", seed = 20)
  tor <- simulate_toroidal(n = 140, scenario = "multimodal", seed = 21)

  expect_s3_class(plot_phase_loom(cyl$theta, cyl$x), "ggplot")
  expect_s3_class(plot_circular_topography(cyl$theta, cyl$x, n_theta = 32, n_x = 50), "ggplot")
  expect_s3_class(plot_stat_orbit(cyl$theta, cyl$x, n_theta = 32), "ggplot")

  expect_s3_class(plot_toroidal_flow(tor$theta, tor$phi, n_sectors = 20), "ggplot")
  expect_s3_class(plot_toroidal_topography(tor$theta, tor$phi, n_theta = 32, n_phi = 32), "ggplot")
  expect_s3_class(plot_toroidal_ridge(tor$theta, tor$phi, n_theta = 32, n_phi = 32), "ggplot")
})

test_that("directional ggplot2 layer API builds", {
  cyl <- simulate_cylindrical(n = 80, scenario = "nonlinear", seed = 30)
  tor <- simulate_toroidal(n = 90, scenario = "multimodal", seed = 31)

  p1 <- ggplot2::ggplot(cyl, ggplot2::aes(x = theta, y = x)) +
    geom_phase_loom(n_sectors = 12, n_x_bins = 10, min_mass = 0, max_flows = 40)
  expect_s3_class(ggplot2::ggplot_build(p1), "ggplot_built")

  p2 <- ggplot2::ggplot(cyl, ggplot2::aes(x = theta, y = x)) +
    stat_circular_topography(n_theta = 16, n_x = 20)
  expect_s3_class(ggplot2::ggplot_build(p2), "ggplot_built")

  p3 <- ggplot2::ggplot(cyl, ggplot2::aes(x = theta, y = x)) +
    stat_statistical_orbit_ribbon(n_theta = 20, alpha = 0.2) +
    stat_statistical_orbit(n_theta = 20)
  expect_s3_class(ggplot2::ggplot_build(p3), "ggplot_built")

  p4 <- ggplot2::ggplot(tor, ggplot2::aes(x = theta, y = phi)) +
    geom_toroidal_flow(n_sectors = 12, min_mass = 0)
  expect_s3_class(ggplot2::ggplot_build(p4), "ggplot_built")

  p5 <- ggplot2::ggplot(tor, ggplot2::aes(x = theta, y = phi)) +
    stat_toroidal_topography(n_theta = 16, n_phi = 16, conditional = TRUE)
  expect_s3_class(ggplot2::ggplot_build(p5), "ggplot_built")

  p6 <- ggplot2::ggplot(tor, ggplot2::aes(x = theta, y = phi)) +
    stat_toroidal_ridge(n_theta = 20, n_phi = 20)
  expect_s3_class(ggplot2::ggplot_build(p6), "ggplot_built")
})

test_that("experimental 3D directional displays use plotly when available", {
  cyl <- simulate_cylindrical(n = 80, scenario = "nonlinear", seed = 320)
  tor <- simulate_toroidal(n = 90, scenario = "diagonal", seed = 321)
  cyl_before <- cyl
  tor_before <- tor

  if (!requireNamespace("plotly", quietly = TRUE)) {
    expect_error(
      plot_circular_topography_3d(cyl$theta, cyl$x, n_theta = 16, n_x = 18),
      "plotly"
    )
    expect_error(
      plot_toroidal_topography_3d(tor$theta, tor$phi, n_theta = 16, n_phi = 16),
      "plotly"
    )
  } else {
    expect_s3_class(
      plot_circular_topography_3d(cyl$theta, cyl$x, n_theta = 16, n_x = 18),
      "plotly"
    )
    expect_s3_class(
      plot_toroidal_topography_3d(tor$theta, tor$phi, n_theta = 16, n_phi = 16),
      "plotly"
    )
  }

  expect_equal(cyl, cyl_before)
  expect_equal(tor, tor_before)
})
