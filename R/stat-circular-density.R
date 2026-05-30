vonmises_kernel <- function(theta, mu, kappa) {
  if (!is.finite(kappa)) {
    kappa <- 1e6
  }
  exp(kappa * (cos(theta - mu) - 1)) /
    (2 * pi * base::besselI(kappa, 0, expon.scaled = TRUE))
}

circular_kernel_density <- function(x, grid, kappa) {
  if (length(x) == 0L) {
    return(rep(NA_real_, length(grid)))
  }
  kernel_matrix <- outer(grid, x, function(theta, mu) vonmises_kernel(theta, mu, kappa))
  rowMeans(kernel_matrix)
}

density_kappa <- function(x, bw = NULL, axial = FALSE) {
  if (!is.null(bw)) {
    if (!is.numeric(bw) || length(bw) != 1L || is.na(bw) || bw <= 0) {
      rlang::abort("`bw` must be a single positive number.")
    }
    return(1 / bw^2)
  }
  Rbar <- mean_resultant_length(x, axial = axial, na.rm = TRUE)
  kappa <- kappa_from_Rbar(Rbar)
  if (is.na(kappa) || !is.finite(kappa) || kappa <= 0) {
    kappa <- 1
  }
  max(0.25, kappa)
}

#' Circular density statistic
#'
#' Estimates a smooth circular density using a von Mises kernel. The density
#' wraps around the origin, avoiding the boundary artifacts of a linear kernel
#' density estimate.
#'
#' @param mapping,data,geom,position,show.legend,inherit.aes Standard ggplot2
#'   layer arguments.
#' @param ... Additional arguments passed to the layer.
#' @param method Density method. Currently `"kernel"` and `"vonmises"` both use
#'   a von Mises kernel estimator.
#' @param bw Optional circular bandwidth. It is interpreted as `1 / sqrt(kappa)`.
#' @param adjust Multiplicative adjustment applied to `bw` or to the automatic
#'   bandwidth scale.
#' @param n Number of grid points.
#' @param axial Should the data be treated as axial, modulo `pi`?
#' @param na.rm Should missing values be silently removed?
#'
#' @return A ggplot2 layer. Computed variables are `x`, `density`, `scaled`,
#'   `count`, `n`, `bw` and `kappa`.
#' @export
#' @family circular density layers
#'
#' @examples
#' ggplot2::ggplot(wind_directions, ggplot2::aes(x = direction)) +
#'   stat_circular_density()
stat_circular_density <- function(
  mapping = NULL,
  data = NULL,
  geom = "line",
  position = "identity",
  ...,
  method = c("kernel", "vonmises"),
  bw = NULL,
  adjust = 1,
  n = 512,
  axial = FALSE,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
) {
  method <- match.arg(method)
  ggplot2::layer(
    stat = StatCircularDensity,
    geom = geom,
    mapping = mapping,
    data = data,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      method = method,
      bw = bw,
      adjust = adjust,
      n = n,
      axial = axial,
      na.rm = na.rm,
      ...
    )
  )
}

StatCircularDensity <- ggplot2::ggproto(
  "StatCircularDensity",
  ggplot2::Stat,
  required_aes = "x",
  default_aes = ggplot2::aes(y = ggplot2::after_stat(density)),
  compute_group = function(
    data,
    scales,
    method = "kernel",
    bw = NULL,
    adjust = 1,
    n = 512,
    axial = FALSE,
    na.rm = FALSE
  ) {
    if (!is.numeric(n) || length(n) != 1L || is.na(n) || n < 2) {
      rlang::abort("`n` must be a single integer greater than 1.")
    }
    if (!is.numeric(adjust) || length(adjust) != 1L || is.na(adjust) || adjust <= 0) {
      rlang::abort("`adjust` must be a single positive number.")
    }

    period <- angle_period(axial)
    x <- data$x
    keep <- !is.na(x)
    x <- normalize_angle(x[keep], period = period)
    if (!isTRUE(na.rm) && any(!keep)) {
      rlang::warn("Removed missing values from `stat_circular_density()`.")
    }

    n <- as.integer(n)
    grid <- seq(0, period, length.out = n)
    kappa <- density_kappa(x, bw = bw, axial = axial)
    kappa <- kappa / adjust^2
    bw_used <- 1 / sqrt(kappa)

    if (isTRUE(axial)) {
      density <- 2 * circular_kernel_density(2 * x, 2 * grid, kappa)
    } else {
      density <- circular_kernel_density(x, grid, kappa)
    }
    scaled <- if (all(is.na(density)) || max(density, na.rm = TRUE) <= 0) {
      density
    } else {
      density / max(density, na.rm = TRUE)
    }

    tibble::tibble(
      x = grid,
      density = density,
      scaled = scaled,
      count = density * length(x),
      n = length(x),
      bw = bw_used,
      kappa = kappa
    )
  }
)
