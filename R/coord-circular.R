#' Circular coordinate system
#'
#' Convenience wrapper around `ggplot2::coord_polar()` with arguments expressed
#' in circular-data language.
#'
#' @param zero Direction corresponding to angle zero.
#' @param direction Direction in which angles increase.
#' @param start Optional start offset in radians. If supplied, it overrides
#'   `zero`.
#' @param clip Should drawing be clipped to the plot panel?
#'
#' @return A ggplot2 coordinate object.
#' @export
#' @family circular scales
#'
#' @details
#' `zero = "east"` and `direction = "counterclockwise"` gives the usual
#' mathematical convention: zero points east and positive angles rotate toward
#' north. `zero = "north"` and `direction = "clockwise"` gives the usual bearing
#' convention used for compass directions.
#'
#' @examples
#' coord_circular()
#' coord_circular(zero = "north", direction = "clockwise")
coord_circular <- function(
  zero = c("east", "north", "west", "south"),
  direction = c("counterclockwise", "clockwise"),
  start = NULL,
  clip = "on"
) {
  zero <- match.arg(zero)
  direction <- match.arg(direction)
  direction_sign <- if (identical(direction, "clockwise")) 1 else -1
  zero_theta <- c(east = pi / 2, north = 0, west = 3 * pi / 2, south = pi)[[zero]]
  if (is.null(start)) {
    start <- zero_theta / direction_sign
  }
  ggplot2::coord_polar(theta = "x", start = start, direction = direction_sign, clip = clip)
}
