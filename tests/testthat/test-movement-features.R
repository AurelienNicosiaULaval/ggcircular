test_that("movement helpers compute simple geometry", {
  expect_equal(compute_bearing(c(0, 1), c(0, 0))[2], 0)
  expect_equal(compute_bearing(c(0, 0), c(0, 1))[2], pi / 2)
  expect_equal(compute_step_length(c(0, 3), c(0, 4))[2], 5)
  expect_equal(compute_turn_angle(c(0, pi / 2))[2], pi / 2)
})

test_that("mutate_directional_features respects individuals", {
  df <- tibble::tibble(
    id = c(1, 1, 2, 2),
    time = c(1, 2, 1, 2),
    x = c(0, 1, 0, 0),
    y = c(0, 0, 0, 1)
  )
  out <- mutate_directional_features(df, x = x, y = y, id = id, time = time)
  expect_true(all(is.na(out$step_length[c(1, 3)])))
  expect_equal(out$bearing[2], 0)
  expect_equal(out$bearing[4], pi / 2)
})

test_that("momentuHMM alignment validation rejects silent truncation", {
  data <- tibble::tibble(turn_angle = c(0, 0.1, 0.2))

  expect_null(validate_momentuHMM_alignment(data, state = c(1, 2, 1)))
  expect_null(validate_momentuHMM_alignment(data, state = c(1, 2, 1), probs = matrix(1 / 2, nrow = 3, ncol = 2)))
  expect_error(validate_momentuHMM_alignment(data, state = c(1, 2)), "incompatible lengths")
  expect_error(
    validate_momentuHMM_alignment(data, state = c(1, 2, 1), probs = matrix(1 / 2, nrow = 2, ncol = 2)),
    "incompatible probabilities"
  )
})
