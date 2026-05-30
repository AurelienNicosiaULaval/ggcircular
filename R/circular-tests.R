#' Confidence interval for a circular mean
#'
#' Computes an approximate confidence interval for a circular mean. The large
#' sample method uses a normal approximation on the mean direction, while the
#' bootstrap method resamples angles and forms an interval from angular
#' deviations around the sample mean.
#'
#' @param x Numeric vector of angles in radians.
#' @param level Confidence level.
#' @param method Interval method.
#' @param R Number of bootstrap resamples.
#' @param axial Should data be treated as axial, modulo `pi`?
#' @param na.rm Should missing values be removed?
#' @param seed Optional random seed for the bootstrap.
#'
#' @return A tibble with `mean`, `lower`, `upper`, `level`, `method`, `n` and
#'   `Rbar`.
#' @export
#' @family circular summaries
circular_mean_ci <- function(
  x,
  level = 0.95,
  method = c("large_sample", "bootstrap"),
  R = 999,
  axial = FALSE,
  na.rm = TRUE,
  seed = NULL
) {
  method <- match.arg(method)
  check_angle(x)
  if (isTRUE(na.rm)) {
    x <- x[!is.na(x)]
  }
  n <- length(x)
  mean <- mean_direction(x, axial = axial, na.rm = FALSE)
  Rbar <- mean_resultant_length(x, axial = axial, na.rm = FALSE)
  if (n == 0L || is.na(mean)) {
    return(tibble::tibble(mean = NA_real_, lower = NA_real_, upper = NA_real_, level = level, method = method, n = n, Rbar = Rbar))
  }

  if (identical(method, "large_sample")) {
    ci <- mean_direction_ci(x, mean = mean, Rbar = Rbar, n = n, level = level, axial = axial)
    return(tibble::tibble(mean = mean, lower = ci[["low"]], upper = ci[["high"]], level = level, method = method, n = n, Rbar = Rbar))
  }

  if (!is.null(seed)) {
    old_seed <- if (exists(".Random.seed", envir = .GlobalEnv, inherits = FALSE)) .Random.seed else NULL
    on.exit({
      if (is.null(old_seed)) {
        rm(".Random.seed", envir = .GlobalEnv)
      } else {
        assign(".Random.seed", old_seed, envir = .GlobalEnv)
      }
    }, add = TRUE)
    set.seed(seed)
  }
  boot_means <- replicate(R, mean_direction(sample(x, length(x), replace = TRUE), axial = axial, na.rm = TRUE))
  delta <- angular_difference(boot_means, mean, period = angle_period(axial))
  alpha <- 1 - level
  q <- stats::quantile(delta, probs = c(alpha / 2, 1 - alpha / 2), na.rm = TRUE, names = FALSE)
  tibble::tibble(
    mean = mean,
    lower = normalize_angle(mean + q[1], period = angle_period(axial)),
    upper = normalize_angle(mean + q[2], period = angle_period(axial)),
    level = level,
    method = method,
    n = n,
    Rbar = Rbar
  )
}

#' Rayleigh test for circular uniformity
#'
#' Performs the one-sample Rayleigh test for non-uniformity. The returned object
#' follows the base `htest` structure.
#'
#' @param x Numeric vector of angles in radians.
#' @param axial Should data be treated as axial, modulo `pi`?
#' @param na.rm Should missing values be removed?
#'
#' @return An object of class `htest`.
#' @export
#' @family circular tests
rayleigh_test <- function(x, axial = FALSE, na.rm = TRUE) {
  check_angle(x)
  if (isTRUE(na.rm)) {
    x <- x[!is.na(x)]
  }
  theta <- directionalize_angle(x, axial = axial)
  n <- length(theta)
  Rbar <- mean_resultant_length(x, axial = axial, na.rm = FALSE)
  z <- n * Rbar^2
  p <- if (n < 1L) {
    NA_real_
  } else {
    correction <- 1 + (2 * z - z^2) / (4 * n) -
      (24 * z - 132 * z^2 + 76 * z^3 - 9 * z^4) / (288 * n^2)
    min(1, max(0, exp(-z) * correction))
  }
  structure(
    list(
      statistic = c(z = z),
      parameter = c(n = n),
      p.value = p,
      method = "Rayleigh test of circular uniformity",
      data.name = deparse(substitute(x)),
      alternative = "the distribution is unimodal and non-uniform"
    ),
    class = "htest"
  )
}

#' Watson-Williams test for equal circular means
#'
#' Wrapper around `circular::watson.williams.test()` with explicit optional
#' dependency handling.
#'
#' @param x Numeric vector of angles in radians.
#' @param group Grouping variable.
#' @param ... Additional arguments passed to `circular::watson.williams.test()`.
#'
#' @return An object returned by `circular::watson.williams.test()`.
#' @export
#' @family circular tests
watson_williams_test <- function(x, group, ...) {
  if (!requireNamespace("circular", quietly = TRUE)) {
    rlang::abort("Package `circular` is required for `watson_williams_test()`.")
  }
  keep <- !is.na(x) & !is.na(group)
  circular::watson.williams.test(circular::circular(x[keep]), group[keep], ...)
}

#' Annotate circular tests
#'
#' Adds a text annotation with the p-value from a Rayleigh or Watson-Williams
#' test.
#'
#' @param mapping,data,geom,position,show.legend,inherit.aes Standard ggplot2
#'   layer arguments.
#' @param ... Additional arguments passed to the text geom.
#' @param test Test to compute.
#' @param x,y Text position.
#' @param digits Number of digits used for p-value formatting.
#' @param na.rm Should missing values be removed?
#'
#' @return A ggplot2 layer.
#' @export
#' @family circular tests
stat_circular_test <- function(
  mapping = NULL,
  data = NULL,
  geom = "text",
  position = "identity",
  ...,
  test = c("rayleigh", "watson_williams"),
  x = 0,
  y = 1,
  digits = 3,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
) {
  test <- match.arg(test)
  ggplot2::layer(
    stat = StatCircularTest,
    geom = geom,
    mapping = mapping,
    data = data,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(test = test, label_x = x, label_y = y, digits = digits, na.rm = na.rm, ...)
  )
}

StatCircularTest <- ggplot2::ggproto(
  "StatCircularTest",
  ggplot2::Stat,
  required_aes = "x",
  compute_panel = function(data, scales, test = "rayleigh", label_x = 0, label_y = 1, digits = 3, na.rm = FALSE) {
    keep <- !is.na(data$x)
    data <- data[keep, , drop = FALSE]
    result <- if (identical(test, "rayleigh")) {
      rayleigh_test(data$x)
    } else {
      if (length(unique(data$group)) < 2L) {
        rlang::abort("`stat_circular_test(test = \"watson_williams\")` requires at least two groups.")
      }
      watson_williams_test(data$x, data$group)
    }
    tibble::tibble(
      x = label_x,
      y = label_y,
      label = paste0(result$method, "\n", "p = ", format.pval(result$p.value, digits = digits))
    )
  }
)
