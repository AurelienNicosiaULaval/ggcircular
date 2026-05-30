#' Rose diagram layer
#'
#' `geom_rose()` is a convenience wrapper around [stat_rose()] using a bar
#' geometry. It is designed to be used with [coord_circular()] or
#' `ggplot2::coord_polar()`.
#'
#' @inheritParams stat_rose
#' @param mapping,data,position,show.legend,inherit.aes Standard ggplot2 layer
#'   arguments.
#' @param stat Statistical transformation, usually `"rose"`.
#'
#' @return A ggplot2 layer.
#' @export
#' @family rose diagram layers
#'
#' @examples
#' ggplot2::ggplot(wind_directions, ggplot2::aes(x = direction)) +
#'   geom_rose(bins = 16) +
#'   coord_circular()
geom_rose <- function(
  mapping = NULL,
  data = NULL,
  stat = "rose",
  position = "identity",
  ...,
  bins = 30,
  binwidth = NULL,
  boundary = 0,
  closed = TRUE,
  area = FALSE,
  normalize = c("count", "density", "proportion"),
  axial = FALSE,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
) {
  normalize <- match.arg(normalize)
  ggplot2::layer(
    stat = stat,
    geom = "col",
    mapping = mapping,
    data = data,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      bins = bins,
      binwidth = binwidth,
      boundary = boundary,
      closed = closed,
      area = area,
      normalize = normalize,
      axial = axial,
      na.rm = na.rm,
      ...
    )
  )
}
