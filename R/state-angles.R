#' Plot angular distributions by state
#'
#' Convenience function for visualizing angles by observed or inferred states.
#'
#' @param data A data frame.
#' @param angle Angle column.
#' @param state State or group column.
#' @param type Plot type.
#' @param bins Number of bins for rose diagrams.
#' @param axial Should data be treated as axial, modulo `pi`?
#'
#' @return A ggplot object.
#' @export
#' @family movement helpers
plot_state_angles <- function(
  data,
  angle,
  state,
  type = c("rose", "density", "mean"),
  bins = 24,
  axial = FALSE
) {
  type <- match.arg(type)
  angle <- rlang::enquo(angle)
  state <- rlang::enquo(state)

  if (identical(type, "rose")) {
    return(
      ggplot2::ggplot(data, ggplot2::aes(x = !!angle, fill = !!state)) +
        geom_rose(bins = bins, axial = axial, alpha = 0.75) +
        ggplot2::facet_wrap(ggplot2::vars(!!state)) +
        scale_x_circular_radians(limits = c(0, angle_period(axial))) +
        coord_circular() +
        theme_circular()
    )
  }

  if (identical(type, "density")) {
    return(
      ggplot2::ggplot(data, ggplot2::aes(x = !!angle, colour = !!state)) +
        geom_circular_density(axial = axial, linewidth = 1) +
        scale_x_circular_radians(limits = c(0, angle_period(axial))) +
        coord_circular() +
        theme_circular()
    )
  }

  ggplot2::ggplot(data, ggplot2::aes(x = !!angle, colour = !!state)) +
    geom_mean_direction(axial = axial) +
    scale_x_circular_radians(limits = c(0, angle_period(axial))) +
    coord_circular() +
    theme_circular()
}

