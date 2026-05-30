#' Autoplot circular data
#'
#' Creates a quick diagnostic plot for a numeric vector of circular angles.
#'
#' @param theta Numeric vector of angles in radians.
#' @param bins Number of rose diagram bins.
#' @param density Should a circular density estimate be added?
#' @param mean Should the mean direction be added?
#' @param axial Should the data be treated as axial, modulo `pi`?
#' @param ... Additional arguments currently ignored.
#'
#' @return A ggplot object.
#' @export
#' @family autoplot helpers
#' @importFrom ggplot2 autoplot
#'
#' @examples
#' autoplot_circular(wind_directions$direction)
autoplot_circular <- function(theta, bins = 24, density = TRUE, mean = TRUE, axial = FALSE, ...) {
  data <- tibble::tibble(theta = theta)
  p <- ggplot2::ggplot(data, ggplot2::aes(x = .data$theta)) +
    geom_rose(bins = bins, axial = axial)
  if (isTRUE(density)) {
    p <- p + geom_circular_density(axial = axial, linewidth = 0.8)
  }
  if (isTRUE(mean)) {
    p <- p + geom_mean_direction(axial = axial)
  }
  p +
    scale_x_circular_radians(limits = c(0, angle_period(axial))) +
    coord_circular() +
    theme_circular()
}

#' @method autoplot circular
#' @export
autoplot.circular <- function(object, ...) {
  autoplot_circular(as.numeric(object), ...)
}

#' @method autoplot ggcircular_summary
#' @export
autoplot.ggcircular_summary <- function(object, ...) {
  ggplot2::ggplot(object, ggplot2::aes(x = .data$mean, y = .data$Rbar)) +
    ggplot2::geom_point() +
    scale_x_circular_radians() +
    coord_circular() +
    theme_circular()
}

#' @method autoplot ggcircular_density
#' @export
autoplot.ggcircular_density <- function(object, ...) {
  ggplot2::ggplot(object, ggplot2::aes(x = .data$x, y = .data$density)) +
    ggplot2::geom_line() +
    scale_x_circular_radians() +
    coord_circular() +
    theme_circular()
}

autoplot_circular_model <- function(
  object,
  type = c("residuals_rose", "residuals_density", "fitted_observed", "residuals_index"),
  bins = 24,
  ...
) {
  type <- match.arg(type)
  diag <- circular_residuals(object)
  diag$.resid_plot <- normalize_angle(diag$.resid)

  if (identical(type, "residuals_rose")) {
    return(
      ggplot2::ggplot(diag, ggplot2::aes(x = .data$.resid_plot)) +
        geom_rose(bins = bins) +
        scale_x_circular_radians() +
        coord_circular() +
        theme_circular()
    )
  }

  if (identical(type, "residuals_density")) {
    return(
      ggplot2::ggplot(diag, ggplot2::aes(x = .data$.resid_plot)) +
        geom_circular_density(linewidth = 1) +
        geom_mean_direction() +
        scale_x_circular_radians() +
        coord_circular() +
        theme_circular()
    )
  }

  if (identical(type, "fitted_observed")) {
    return(
      ggplot2::ggplot(diag, ggplot2::aes(x = .data$.fitted, y = .data$.observed)) +
        ggplot2::geom_point(alpha = 0.7) +
        ggplot2::geom_abline(slope = 1, intercept = 0, linetype = 2) +
        scale_x_circular_radians() +
        ggplot2::scale_y_continuous(limits = c(0, 2 * pi), breaks = c(0, pi, 2 * pi)) +
        theme_circular()
    )
  }

  ggplot2::ggplot(diag, ggplot2::aes(x = .data$.index, y = .data$.resid)) +
    ggplot2::geom_hline(yintercept = 0, linetype = 2) +
    ggplot2::geom_point(alpha = 0.7) +
    ggplot2::labs(x = "Index", y = "Circular residual") +
    ggplot2::theme_minimal()
}

#' @method autoplot angular
#' @export
autoplot.angular <- function(object, ...) {
  autoplot_circular_model(object, ...)
}

#' @method autoplot consensus
#' @export
autoplot.consensus <- function(object, ...) {
  autoplot_circular_model(object, ...)
}

#' @method autoplot angular_two_step
#' @export
autoplot.angular_two_step <- function(object, ...) {
  autoplot_circular_model(object, ...)
}
