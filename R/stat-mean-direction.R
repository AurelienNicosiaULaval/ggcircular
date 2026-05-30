mean_direction_ci <- function(x, mean, Rbar, n, level = 0.95, axial = FALSE) {
  if (n < 2L || is.na(mean) || is.na(Rbar) || Rbar < sqrt(.Machine$double.eps)) {
    return(c(low = NA_real_, high = NA_real_))
  }
  alpha <- 1 - level
  z <- stats::qnorm(1 - alpha / 2)
  half_width <- z * sqrt((1 - Rbar) / (n * max(Rbar, sqrt(.Machine$double.eps))))
  if (isTRUE(axial)) {
    half_width <- half_width / 2
  }
  period <- angle_period(axial)
  c(
    low = normalize_angle(mean - half_width, period = period),
    high = normalize_angle(mean + half_width, period = period)
  )
}

#' Mean direction statistic
#'
#' Computes one mean direction per group, with resultant length and an optional
#' approximate confidence arc.
#'
#' @param mapping,data,geom,position,show.legend,inherit.aes Standard ggplot2
#'   layer arguments.
#' @param ... Additional arguments passed to the layer.
#' @param length Should the displayed segment length be proportional to the mean
#'   resultant length (`"resultant"`) or fixed (`"fixed"`)?
#' @param radius Optional maximum displayed radius.
#' @param conf.int Should approximate confidence limits be computed?
#' @param level Confidence level used when `conf.int = TRUE`.
#' @param axial Should the data be treated as axial, modulo `pi`?
#' @param na.rm Should missing values be silently removed?
#'
#' @return A ggplot2 layer. Computed variables include `x`, `xend`, `y`, `yend`,
#'   `mean`, `R`, `Rbar`, `n`, `kappa`, `ci_low` and `ci_high`.
#' @export
#' @family mean direction layers
#'
#' @examples
#' ggplot2::ggplot(wind_directions, ggplot2::aes(x = direction)) +
#'   stat_mean_direction()
stat_mean_direction <- function(
  mapping = NULL,
  data = NULL,
  geom = "segment",
  position = "identity",
  ...,
  length = c("resultant", "fixed"),
  radius = NULL,
  conf.int = FALSE,
  level = 0.95,
  axial = FALSE,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
) {
  length <- match.arg(length)
  ggplot2::layer(
    stat = StatMeanDirection,
    geom = geom,
    mapping = mapping,
    data = data,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      length = length,
      radius = radius,
      conf.int = conf.int,
      level = level,
      axial = axial,
      na.rm = na.rm,
      ...
    )
  )
}

StatMeanDirection <- ggplot2::ggproto(
  "StatMeanDirection",
  ggplot2::Stat,
  required_aes = "x",
  compute_group = function(
    data,
    scales,
    length = "resultant",
    radius = NULL,
    conf.int = FALSE,
    level = 0.95,
    axial = FALSE,
    na.rm = FALSE
  ) {
    x <- data$x
    keep <- !is.na(x)
    if (!isTRUE(na.rm) && any(!keep)) {
      rlang::warn("Removed missing values from `stat_mean_direction()`.")
    }
    x <- x[keep]

    mean <- mean_direction(x, axial = axial, na.rm = TRUE)
    R <- resultant_length(x, axial = axial, na.rm = TRUE)
    Rbar <- mean_resultant_length(x, axial = axial, na.rm = TRUE)
    kappa <- estimate_kappa(x, axial = axial, na.rm = TRUE)
    n <- length(x)
    radius <- radius %||% if ("y" %in% names(data)) max(data$y, na.rm = TRUE) else 1
    if (!is.finite(radius) || radius <= 0) {
      radius <- 1
    }
    displayed <- if (identical(length, "resultant")) radius * Rbar else radius
    ci <- if (isTRUE(conf.int)) {
      mean_direction_ci(x, mean, Rbar, n, level = level, axial = axial)
    } else {
      c(low = NA_real_, high = NA_real_)
    }

    tibble::tibble(
      x = mean,
      xend = mean,
      y = 0,
      yend = displayed,
      mean = mean,
      R = R,
      Rbar = Rbar,
      n = n,
      kappa = kappa,
      ci_low = ci[["low"]],
      ci_high = ci[["high"]]
    )
  }
)

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}
