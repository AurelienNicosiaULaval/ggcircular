#' Circular density layer
#'
#' Draws a circular density estimate as a line. This is a convenience wrapper
#' around [stat_circular_density()].
#'
#' @inheritParams stat_circular_density
#' @param mapping,data,position,show.legend,inherit.aes Standard ggplot2 layer
#'   arguments.
#' @param stat Statistical transformation, usually `"circular_density"`.
#'
#' @return A ggplot2 layer.
#' @export
#' @family circular density layers
#'
#' @examples
#' ggplot2::ggplot(wind_directions, ggplot2::aes(x = direction)) +
#'   geom_circular_density()
geom_circular_density <- function(
  mapping = NULL,
  data = NULL,
  stat = "circular_density",
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
    stat = stat,
    geom = "line",
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
