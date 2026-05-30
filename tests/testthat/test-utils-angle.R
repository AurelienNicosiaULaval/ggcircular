test_that("normalize_angle returns angles in the requested interval", {
  x <- normalize_angle(c(-pi, 0, 3 * pi))
  expect_true(all(x >= 0))
  expect_true(all(x < 2 * pi))
  expect_equal(x, c(pi, 0, pi), tolerance = 1e-12)
})

test_that("angular_difference is signed in [-pi, pi)", {
  d <- angular_difference(seq(-4 * pi, 4 * pi, length.out = 25), 0)
  expect_true(all(d >= -pi))
  expect_true(all(d < pi))
})

test_that("angular_distance is non-negative in [0, pi]", {
  d <- angular_distance(seq(-4 * pi, 4 * pi, length.out = 25), 0)
  expect_true(all(d >= 0))
  expect_true(all(d <= pi))
})

test_that("degree and hour conversions are correct", {
  expect_equal(deg_to_rad(180), pi)
  expect_equal(rad_to_deg(pi / 2), 90)
  expect_equal(hour_to_rad(6), pi / 2)
  expect_equal(rad_to_hour(pi), 12)
})

test_that("compass conversions are consistent", {
  expect_equal(compass_to_rad(c("N", "E", "S", "W")), c(0, pi / 2, pi, 3 * pi / 2))
  expect_equal(rad_to_compass(c(0, pi / 2, pi, 3 * pi / 2)), c("N", "E", "S", "W"))
})
