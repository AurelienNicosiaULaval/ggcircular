test_that("fit_vonmises_mixture returns coherent components", {
  set.seed(1)
  x <- c(rnorm(80, 0, 0.2), rnorm(80, pi, 0.2))
  fit <- fit_vonmises_mixture(x, k = 2, nstart = 2, seed = 1, max_iter = 300)

  expect_s3_class(fit, "ggcircular_vonmises_mixture")
  expect_equal(sum(fit$proportions), 1, tolerance = 1e-10)
  expect_true(all(fit$kappa >= 0))
  expect_equal(ncol(fit$responsibilities), 2)
  expect_s3_class(tidy_circular(fit), "tbl_df")
  expect_s3_class(augment_circular(fit), "tbl_df")
  expect_s3_class(glance_circular(fit), "tbl_df")
  expect_s3_class(ggplot2::autoplot(fit), "ggplot")
})

test_that("fit_vonmises_mixture is reproducible with seed and nstart", {
  x <- c(rnorm(60, 0, 0.2), rnorm(60, pi, 0.2))
  one <- fit_vonmises_mixture(x, k = 2, nstart = 3, seed = 42, max_iter = 300)
  two <- fit_vonmises_mixture(x, k = 2, nstart = 3, seed = 42, max_iter = 300)

  expect_equal(tidy_circular(one), tidy_circular(two), tolerance = 1e-12)
  expect_equal(one$start_id, two$start_id)
})

test_that("fit_vonmises_mixture validates advanced controls", {
  x <- c(rnorm(20, 0, 0.2), rnorm(20, pi, 0.2))

  expect_error(fit_vonmises_mixture(x, k = 0), "`k`")
  expect_error(fit_vonmises_mixture(x, nstart = 0), "`nstart`")
  expect_error(fit_vonmises_mixture(x, kappa_max = 0), "`kappa_max`")
  expect_error(fit_vonmises_mixture(x, seed = NA_real_), "`seed`")
  expect_error(
    fit_vonmises_mixture(x, k = 2, init_params = list(mu = c(0, 1, 2))),
    "`init_params\\$mu`"
  )
})

test_that("fit_vonmises_mixture respects init_params and kappa_max", {
  x <- rnorm(50, 0, 0.001)
  fit <- fit_vonmises_mixture(
    x,
    k = 1,
    init_params = list(proportions = 1, mu = 0, kappa = 100),
    kappa_max = 5,
    seed = 1
  )

  expect_lte(max(fit$kappa), 5)
  expect_equal(fit$start_id, 1)
})

test_that("fit_vonmises_mixture protects quasi-empty components", {
  x <- c(rnorm(40, 0, 0.05), rnorm(40, pi, 0.05))
  fit <- suppressWarnings(fit_vonmises_mixture(
    x,
    k = 3,
    init_params = list(
      proportions = c(0.49, 0.49, 0.02),
      mu = c(0, pi, pi / 2),
      kappa = c(20, 20, 200)
    ),
    min_component_weight = 0.1,
    max_iter = 3,
    seed = 1
  ))

  expect_gte(fit$empty_components, 1)
  expect_equal(length(fit$proportions), 3)
})

test_that("fit_vonmises_mixture warns on non-convergence", {
  x <- c(rnorm(30, 0, 0.3), rnorm(30, pi, 0.3))

  expect_warning(
    fit <- fit_vonmises_mixture(x, k = 2, max_iter = 1, seed = 1),
    "did not converge"
  )
  expect_false(fit$converged)
})

test_that("fit_vonmises_mixture handles uniform, close and weighted data", {
  uniform <- seq(0, 2 * pi, length.out = 80)[-80]
  close <- c(rnorm(50, 0.2, 0.04), rnorm(50, 0.5, 0.04))
  weighted <- c(rnorm(40, 0, 0.15), rnorm(40, pi, 0.15))
  weights <- c(rep(10, 40), rep(1, 40))

  fit_uniform <- fit_vonmises_mixture(uniform, k = 1, seed = 1)
  fit_close <- fit_vonmises_mixture(close, k = 2, nstart = 3, seed = 1, max_iter = 300)
  fit_weighted <- fit_vonmises_mixture(weighted, k = 2, weights = weights, seed = 1, max_iter = 300)

  expect_lt(fit_uniform$kappa, 0.1)
  expect_true(all(is.finite(fit_close$mu)))
  expect_equal(sum(fit_weighted$weights), sum(weights))
})

test_that("stat_vonmises_mixture builds from data and fitted objects", {
  set.seed(1)
  df <- tibble::tibble(theta = c(rnorm(40, 0, 0.2), rnorm(40, pi, 0.2)))
  fit <- fit_vonmises_mixture(df$theta, k = 2, nstart = 2, seed = 1, max_iter = 300)

  built_data <- ggplot2::ggplot_build(
    ggplot2::ggplot(df, ggplot2::aes(x = theta)) +
      stat_vonmises_mixture(k = 2, nstart = 2, seed = 1, kappa_max = 100, n = 64)
  )$data[[1]]
  built_fit <- ggplot2::ggplot_build(
    ggplot2::ggplot() +
      stat_vonmises_mixture(fit = fit, n = 64)
  )$data[[1]]

  expect_equal(nrow(built_data), 64)
  expect_equal(nrow(built_fit), 64)
  expect_true(all(built_data$density >= 0))
  expect_true(all(built_fit$density >= 0))
})
