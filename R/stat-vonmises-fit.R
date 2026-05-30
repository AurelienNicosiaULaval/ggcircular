#' Fitted von Mises density
#'
#' Estimates `mu` with [mean_direction()] and `kappa` with [estimate_kappa()],
#' then draws the fitted von Mises density.
#'
#' @param mapping,data,geom,position,show.legend,inherit.aes Standard ggplot2
#'   layer arguments.
#' @param ... Additional arguments passed to the layer.
#' @param n Number of grid points.
#' @param axial Should the data be treated as axial, modulo `pi`?
#' @param na.rm Should missing values be silently removed?
#'
#' @return A ggplot2 layer.
#' @export
#' @family circular distributions
#'
#' @examples
#' ggplot2::ggplot(wind_directions, ggplot2::aes(x = direction)) +
#'   geom_rose(ggplot2::aes(y = ggplot2::after_stat(density))) +
#'   stat_vonmises_fit()
stat_vonmises_fit <- function(
  mapping = NULL,
  data = NULL,
  geom = "line",
  position = "identity",
  ...,
  n = 512,
  axial = FALSE,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
) {
  ggplot2::layer(
    stat = StatVonmisesFit,
    geom = geom,
    mapping = mapping,
    data = data,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(n = n, axial = axial, na.rm = na.rm, ...)
  )
}

StatVonmisesFit <- ggplot2::ggproto(
  "StatVonmisesFit",
  ggplot2::Stat,
  required_aes = "x",
  default_aes = ggplot2::aes(y = ggplot2::after_stat(density)),
  compute_group = function(data, scales, n = 512, axial = FALSE, na.rm = FALSE) {
    x_data <- data$x
    keep <- !is.na(x_data)
    if (!isTRUE(na.rm) && any(!keep)) {
      rlang::warn("Removed missing values from `stat_vonmises_fit()`.")
    }
    x_data <- x_data[keep]
    mu <- mean_direction(x_data, axial = axial, na.rm = TRUE)
    kappa <- estimate_kappa(x_data, axial = axial, na.rm = TRUE)
    if (is.na(mu)) {
      mu <- 0
    }
    if (is.na(kappa) || !is.finite(kappa)) {
      kappa <- 0
    }
    x <- theoretical_grid(n = n, axial = axial)
    density <- if (isTRUE(axial)) {
      2 * dvonmises_density(2 * x, mu = 2 * mu, kappa = kappa)
    } else {
      dvonmises_density(x, mu = mu, kappa = kappa)
    }
    tibble::tibble(x = x, density = density, mu = mu, kappa = kappa)
  }
)
