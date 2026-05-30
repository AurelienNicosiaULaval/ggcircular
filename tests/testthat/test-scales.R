test_that("degree scale labels are correct", {
  scale <- scale_x_circular_degrees()
  expect_equal(
    scale$labels(seq(0, 7 * pi / 4, by = pi / 4)),
    c("0\u00b0", "45\u00b0", "90\u00b0", "135\u00b0", "180\u00b0", "225\u00b0", "270\u00b0", "315\u00b0")
  )
})

test_that("hour and compass labels are correct", {
  expect_equal(scale_x_circular_hours()$labels(seq(0, 7 * pi / 4, by = pi / 4))[1:4], c("00:00", "03:00", "06:00", "09:00"))
  expect_equal(scale_x_circular_compass()$labels(seq(0, 7 * pi / 4, by = pi / 4)), c("N", "NE", "E", "SE", "S", "SW", "W", "NW"))
})

test_that("custom breaks are accepted", {
  scale <- scale_x_circular_radians(breaks = c(0, pi), labels = c("zero", "pi"))
  expect_equal(scale$breaks, c(0, pi))
  expect_equal(scale$labels, c("zero", "pi"))
})
