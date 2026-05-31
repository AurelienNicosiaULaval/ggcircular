circular_components <- function(x, axial = FALSE, na.rm = TRUE) {
  check_angle(x)
  if (isTRUE(na.rm)) {
    x <- x[!is.na(x)]
  }
  if (!isTRUE(na.rm) && anyNA(x)) {
    return(list(n = length(x), C = NA_real_, S = NA_real_, R = NA_real_))
  }

  theta <- directionalize_angle(x, axial = axial)
  n <- length(theta)
  if (n == 0L) {
    return(list(n = 0L, C = 0, S = 0, R = 0))
  }

  C <- sum(cos(theta))
  S <- sum(sin(theta))
  R <- sqrt(C^2 + S^2)
  list(n = n, C = C, S = S, R = R)
}

#' Circular mean direction
#'
#' Computes the sample mean direction. For axial data, angles are doubled before
#' computing the mean and the result is transformed back to the axial scale.
#'
#' @param x Numeric vector of angles in radians.
#' @param axial Should the data be treated as axial, modulo `pi`?
#' @param na.rm Should missing values be removed?
#'
#' @return A single angle in radians, or `NA_real_` when the mean is undefined.
#' @export
#' @family circular summaries
#'
#' @examples
#' mean_direction(c(0, pi / 4, pi / 2))
mean_direction <- function(x, axial = FALSE, na.rm = TRUE) {
  comp <- circular_components(x, axial = axial, na.rm = na.rm)
  if (comp$n == 0L || is.na(comp$R) || comp$R < sqrt(.Machine$double.eps)) {
    return(NA_real_)
  }

  mean_raw <- atan2(comp$S, comp$C)
  period <- angle_period(axial)
  normalize_angle(undirectionalize_angle(mean_raw, axial = axial), period = period)
}

#' Resultant length
#'
#' @inheritParams mean_direction
#'
#' @return The sample resultant length `R`.
#' @export
#' @family circular summaries
resultant_length <- function(x, axial = FALSE, na.rm = TRUE) {
  circular_components(x, axial = axial, na.rm = na.rm)$R
}

#' Mean resultant length
#'
#' @inheritParams mean_direction
#'
#' @return The mean resultant length `Rbar`, between 0 and 1 when defined.
#' @export
#' @family circular summaries
mean_resultant_length <- function(x, axial = FALSE, na.rm = TRUE) {
  comp <- circular_components(x, axial = axial, na.rm = na.rm)
  if (comp$n == 0L || is.na(comp$R)) {
    return(NA_real_)
  }
  min(1, max(0, comp$R / comp$n))
}

#' Circular variance
#'
#' @inheritParams mean_direction
#'
#' @return The circular variance `1 - Rbar`.
#' @export
#' @family circular summaries
circular_variance <- function(x, axial = FALSE, na.rm = TRUE) {
  Rbar <- mean_resultant_length(x, axial = axial, na.rm = na.rm)
  if (is.na(Rbar)) {
    return(NA_real_)
  }
  1 - Rbar
}

#' Circular standard deviation
#'
#' Uses the common descriptive statistic `sqrt(-2 * log(Rbar))`.
#'
#' @inheritParams mean_direction
#'
#' @return Circular standard deviation in radians.
#' @export
#' @family circular summaries
circular_sd <- function(x, axial = FALSE, na.rm = TRUE) {
  Rbar <- mean_resultant_length(x, axial = axial, na.rm = na.rm)
  if (is.na(Rbar)) {
    return(NA_real_)
  }
  if (Rbar <= 0) {
    return(Inf)
  }
  sqrt(-2 * log(Rbar))
}

#' Estimate von Mises concentration
#'
#' Estimates the von Mises concentration parameter from the mean resultant
#' length using the standard piecewise approximation described by Fisher (1993).
#' This is a descriptive approximation and does not apply small-sample bias
#' corrections or uncertainty quantification.
#'
#' @inheritParams mean_direction
#'
#' @return Estimated concentration parameter `kappa`.
#' @references Fisher, N. I. (1993). *Statistical Analysis of Circular Data*.
#'   Cambridge University Press.
#' @export
#' @family circular summaries
estimate_kappa <- function(x, axial = FALSE, na.rm = TRUE) {
  Rbar <- mean_resultant_length(x, axial = axial, na.rm = na.rm)
  kappa_from_Rbar(Rbar)
}

kappa_from_Rbar <- function(Rbar) {
  if (is.na(Rbar)) {
    return(NA_real_)
  }
  Rbar <- min(1, max(0, Rbar))
  if (Rbar < 1e-8) {
    return(0)
  }
  if (Rbar >= 1 - 1e-8) {
    return(Inf)
  }
  if (Rbar < 0.53) {
    return(2 * Rbar + Rbar^3 + 5 * Rbar^5 / 6)
  }
  if (Rbar < 0.85) {
    return(-0.4 + 1.39 * Rbar + 0.43 / (1 - Rbar))
  }
  1 / (Rbar^3 - 4 * Rbar^2 + 3 * Rbar)
}

#' Summarize circular data
#'
#' Computes grouped circular summaries for an angle column. Existing dplyr
#' groups are respected, and additional grouping variables can be supplied in
#' `...`.
#'
#' @param data A data frame or tibble.
#' @param angle Angle column, in radians.
#' @param ... Optional grouping variables.
#' @param axial Should the data be treated as axial, modulo `pi`?
#' @param na.rm Should missing values be removed?
#'
#' @return A tibble with columns `n`, `mean`, `R`, `Rbar`, `variance`, `sd` and
#'   `kappa`. The returned object also has class `ggcircular_summary`.
#' @export
#' @family circular summaries
#'
#' @examples
#' tibble::tibble(group = c("a", "a", "b"), theta = c(0, pi / 2, pi)) |>
#'   dplyr::group_by(group) |>
#'   circular_summary(theta)
circular_summary <- function(data, angle, ..., axial = FALSE, na.rm = TRUE) {
  angle <- rlang::enquo(angle)
  groups <- rlang::enquos(...)
  if (!inherits(data, "data.frame")) {
    data <- tibble::as_tibble(data)
  }
  if (length(groups) > 0L) {
    data <- dplyr::group_by(data, !!!groups, .add = TRUE)
  }

  out <- dplyr::summarise(
    data,
    n = sum(!is.na(!!angle)),
    mean = mean_direction(!!angle, axial = axial, na.rm = na.rm),
    R = resultant_length(!!angle, axial = axial, na.rm = na.rm),
    Rbar = mean_resultant_length(!!angle, axial = axial, na.rm = na.rm),
    variance = circular_variance(!!angle, axial = axial, na.rm = na.rm),
    sd = circular_sd(!!angle, axial = axial, na.rm = na.rm),
    kappa = estimate_kappa(!!angle, axial = axial, na.rm = na.rm),
    .groups = "drop"
  )

  class(out) <- c("ggcircular_summary", class(out))
  out
}
