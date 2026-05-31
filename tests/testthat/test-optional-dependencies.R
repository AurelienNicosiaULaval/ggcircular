test_that("package loads with hard dependencies only", {
  expect_true(requireNamespace("ggcircular", quietly = TRUE))
})

test_that("optional dependency errors are explicit when packages are absent", {
  if (!requireNamespace("posterior", quietly = TRUE)) {
    expect_error(as_circular_draws(data.frame(theta = 0)), "posterior")
  } else {
    expect_true(TRUE)
  }

  if (!requireNamespace("momentuHMM", quietly = TRUE)) {
    expect_error(augment_momentuHMM_angles(list()), "momentuHMM")
  } else {
    expect_true(TRUE)
  }

  if (!requireNamespace("circular", quietly = TRUE)) {
    expect_error(watson_williams_test(c(0, 1), c("a", "b")), "circular")
  } else {
    expect_true(TRUE)
  }
})

test_that("default model helper methods fail explicitly", {
  expect_error(tidy_circular(list()), "No `tidy_circular\\(\\)` method")
  expect_error(augment_circular(list()), "No `augment_circular\\(\\)` method")
  expect_error(glance_circular(list()), "No `glance_circular\\(\\)` method")
})
