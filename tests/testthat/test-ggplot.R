test_that("main geoms return ggplot layers", {
  expect_s3_class(geom_rose(), "LayerInstance")
  expect_s3_class(geom_circular_density(), "LayerInstance")
  expect_s3_class(geom_mean_direction(), "LayerInstance")
  expect_s3_class(geom_direction_arrow(), "LayerInstance")
})

test_that("main examples build without error", {
  expect_no_error(
    ggplot2::ggplot(wind_directions, ggplot2::aes(x = direction)) +
      geom_rose(bins = 16) +
      scale_x_circular_degrees() +
      coord_circular() +
      theme_circular()
  )
  expect_no_error(
    ggplot2::ggplot(wind_directions, ggplot2::aes(x = direction)) +
      geom_rose(ggplot2::aes(y = ggplot2::after_stat(density)), bins = 24, alpha = 0.5) +
      geom_circular_density(linewidth = 1) +
      geom_mean_direction() +
      scale_x_circular_degrees() +
      coord_circular() +
      theme_circular()
  )
})

test_that("autoplot_circular returns a ggplot", {
  expect_s3_class(autoplot_circular(wind_directions$direction), "ggplot")
})
