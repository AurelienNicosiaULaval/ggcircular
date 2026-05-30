dvonmises_density <- function(theta, mu = 0, kappa = 1) {
  if (!is.numeric(kappa) || length(kappa) != 1L || is.na(kappa) || kappa < 0) {
    rlang::abort("`kappa` must be a single non-negative number.")
  }
  if (!is.finite(kappa)) {
    kappa <- 1e6
  }
  if (kappa == 0) {
    return(rep(1 / (2 * pi), length(theta)))
  }
  exp(kappa * (cos(theta - mu) - 1)) /
    (2 * pi * base::besselI(kappa, 0, expon.scaled = TRUE))
}

theoretical_grid <- function(n = 512, axial = FALSE) {
  period <- angle_period(axial)
  seq(0, period, length.out = n)
}

#' Theoretical von Mises density
#'
#' Adds a theoretical von Mises density to a circular plot.
#'
#' @param mapping,data,geom,position,show.legend,inherit.aes Standard ggplot2
#'   layer arguments.
#' @param ... Additional arguments passed to the layer.
#' @param mu Mean direction in radians.
#' @param kappa Non-negative concentration parameter.
#' @param n Number of grid points.
#' @param axial Should the density be drawn over an axial period of `pi`?
#' @param na.rm Included for ggplot2 layer compatibility.
#'
#' @return A ggplot2 layer.
#' @export
#' @family circular distributions
#'
#' @examples
#' ggplot2::ggplot(wind_directions, ggplot2::aes(x = direction)) +
#'   geom_rose(ggplot2::aes(y = ggplot2::after_stat(density))) +
#'   stat_vonmises(mu = pi / 2, kappa = 3)
stat_vonmises <- function(
  mapping = NULL,
  data = NULL,
  geom = "line",
  position = "identity",
  ...,
  mu = 0,
  kappa = 1,
  n = 512,
  axial = FALSE,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = FALSE
) {
  data <- data %||% data.frame(.ggcircular = 1)
  ggplot2::layer(
    stat = StatVonmises,
    geom = geom,
    mapping = mapping,
    data = data,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(mu = mu, kappa = kappa, n = n, axial = axial, na.rm = na.rm, ...)
  )
}

StatVonmises <- ggplot2::ggproto(
  "StatVonmises",
  ggplot2::Stat,
  required_aes = character(0),
  default_aes = ggplot2::aes(y = ggplot2::after_stat(density)),
  compute_group = function(data, scales, mu = 0, kappa = 1, n = 512, axial = FALSE, na.rm = FALSE) {
    x <- theoretical_grid(n = n, axial = axial)
    density <- if (isTRUE(axial)) {
      2 * dvonmises_density(2 * x, mu = 2 * mu, kappa = kappa)
    } else {
      dvonmises_density(x, mu = mu, kappa = kappa)
    }
    tibble::tibble(x = x, density = density, mu = mu, kappa = kappa)
  }
)

#' @rdname stat_vonmises
#' @param sigma Standard deviation of the wrapped normal distribution.
#' @param terms Number of wrapping terms on each side of the origin.
#' @export
stat_wrapped_normal <- function(
  mapping = NULL,
  data = NULL,
  geom = "line",
  position = "identity",
  ...,
  mu = 0,
  sigma = 1,
  terms = 5,
  n = 512,
  axial = FALSE,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = FALSE
) {
  data <- data %||% data.frame(.ggcircular = 1)
  ggplot2::layer(
    stat = StatWrappedNormal,
    geom = geom,
    mapping = mapping,
    data = data,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      mu = mu,
      sigma = sigma,
      terms = terms,
      n = n,
      axial = axial,
      na.rm = na.rm,
      ...
    )
  )
}

StatWrappedNormal <- ggplot2::ggproto(
  "StatWrappedNormal",
  ggplot2::Stat,
  required_aes = character(0),
  default_aes = ggplot2::aes(y = ggplot2::after_stat(density)),
  compute_group = function(data, scales, mu = 0, sigma = 1, terms = 5, n = 512, axial = FALSE, na.rm = FALSE) {
    if (!is.numeric(sigma) || length(sigma) != 1L || is.na(sigma) || sigma <= 0) {
      rlang::abort("`sigma` must be a single positive number.")
    }
    period <- angle_period(axial)
    x <- theoretical_grid(n = n, axial = axial)
    shifts <- seq.int(-terms, terms) * period
    density <- rowSums(vapply(shifts, function(shift) {
      stats::dnorm(x + shift, mean = mu, sd = sigma)
    }, numeric(length(x))))
    tibble::tibble(x = x, density = density, mu = mu, sigma = sigma)
  }
)

#' @rdname stat_vonmises
#' @export
stat_uniform_circular <- function(
  mapping = NULL,
  data = NULL,
  geom = "line",
  position = "identity",
  ...,
  n = 512,
  axial = FALSE,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = FALSE
) {
  data <- data %||% data.frame(.ggcircular = 1)
  ggplot2::layer(
    stat = StatUniformCircular,
    geom = geom,
    mapping = mapping,
    data = data,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(n = n, axial = axial, na.rm = na.rm, ...)
  )
}

StatUniformCircular <- ggplot2::ggproto(
  "StatUniformCircular",
  ggplot2::Stat,
  required_aes = character(0),
  default_aes = ggplot2::aes(y = ggplot2::after_stat(density)),
  compute_group = function(data, scales, n = 512, axial = FALSE, na.rm = FALSE) {
    period <- angle_period(axial)
    x <- theoretical_grid(n = n, axial = axial)
    tibble::tibble(x = x, density = rep(1 / period, length(x)))
  }
)
