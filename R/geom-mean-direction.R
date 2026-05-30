#' Mean direction layer
#'
#' Draws a radial segment at the circular mean direction. The segment length can
#' be fixed or proportional to the mean resultant length.
#'
#' @inheritParams stat_mean_direction
#' @param mapping,data,position,show.legend,inherit.aes Standard ggplot2 layer
#'   arguments.
#' @param stat Statistical transformation, usually `"mean_direction"`.
#' @param arrow Should a small arrow head be drawn?
#'
#' @return A ggplot2 layer.
#' @export
#' @family mean direction layers
#'
#' @examples
#' ggplot2::ggplot(wind_directions, ggplot2::aes(x = direction)) +
#'   geom_rose(bins = 16) +
#'   geom_mean_direction()
geom_mean_direction <- function(
  mapping = NULL,
  data = NULL,
  stat = "mean_direction",
  position = "identity",
  ...,
  length = c("resultant", "fixed"),
  radius = NULL,
  conf.int = FALSE,
  level = 0.95,
  axial = FALSE,
  arrow = TRUE,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
) {
  length <- match.arg(length)
  arrow_spec <- if (isTRUE(arrow)) {
    grid::arrow(length = grid::unit(0.15, "cm"))
  } else {
    NULL
  }
  ggplot2::layer(
    stat = stat,
    geom = "segment",
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
      arrow = arrow_spec,
      na.rm = na.rm,
      ...
    )
  )
}
