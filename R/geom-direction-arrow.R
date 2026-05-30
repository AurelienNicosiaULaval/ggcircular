#' Direction arrows
#'
#' Draws directional arrows from Cartesian coordinates and an angle.
#'
#' @param mapping,data,show.legend,inherit.aes Standard ggplot2 layer
#'   arguments.
#' @param ... Additional arguments passed to `ggplot2::geom_segment()`.
#' @param length Default arrow length when no `length` aesthetic is supplied.
#' @param arrow_length Grid unit controlling the arrow head length.
#' @param angle_convention Angle convention. `"mathematical"` means zero is east
#'   and angles increase counterclockwise. `"bearing"` means zero is north and
#'   angles increase clockwise.
#' @param na.rm Should missing values be silently removed?
#'
#' @return A ggplot2 layer.
#' @export
#' @family movement helpers
#'
#' @examples
#' ggplot2::ggplot(animal_steps, ggplot2::aes(x = x, y = y, angle = bearing)) +
#'   geom_direction_arrow()
geom_direction_arrow <- function(
  mapping = NULL,
  data = NULL,
  ...,
  length = 1,
  arrow_length = grid::unit(0.15, "cm"),
  angle_convention = c("mathematical", "bearing"),
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
) {
  angle_convention <- match.arg(angle_convention)
  ggplot2::layer(
    stat = StatDirectionArrow,
    geom = "segment",
    mapping = mapping,
    data = data,
    position = "identity",
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      length = length,
      angle_convention = angle_convention,
      arrow = grid::arrow(length = arrow_length),
      na.rm = na.rm,
      ...
    )
  )
}

StatDirectionArrow <- ggplot2::ggproto(
  "StatDirectionArrow",
  ggplot2::Stat,
  required_aes = c("x", "y", "angle"),
  optional_aes = "length",
  dropped_aes = c("angle", "length"),
  compute_group = function(data, scales, length = 1, angle_convention = "mathematical", na.rm = FALSE) {
    keep <- !is.na(data$x) & !is.na(data$y) & !is.na(data$angle)
    if ("length" %in% names(data)) {
      keep <- keep & !is.na(data$length)
    }
    if (!isTRUE(na.rm) && any(!keep)) {
      rlang::warn("Removed missing values from `geom_direction_arrow()`.")
    }
    data <- data[keep, , drop = FALSE]
    if (nrow(data) == 0L) {
      return(data.frame())
    }
    segment_length <- if ("length" %in% names(data)) data$length else rep(length, nrow(data))
    angle <- if (identical(angle_convention, "bearing")) {
      pi / 2 - data$angle
    } else {
      data$angle
    }
    out <- data[, setdiff(names(data), c("angle", "length")), drop = FALSE]
    out$xend <- data$x + segment_length * cos(angle)
    out$yend <- data$y + segment_length * sin(angle)
    out
  }
)

#' Circular point and rug helpers
#'
#' Convenience layers for plotting angular observations at a fixed radius.
#'
#' @inheritParams geom_direction_arrow
#' @param mapping,data,show.legend,inherit.aes Standard ggplot2 layer
#'   arguments.
#' @param radius Radius at which points or rugs are drawn.
#' @param rug_length Radial length of rug marks.
#'
#' @return A ggplot2 layer.
#' @export
#' @family movement helpers
geom_circular_point <- function(
  mapping = NULL,
  data = NULL,
  ...,
  radius = 1,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
) {
  ggplot2::layer(
    stat = StatCircularPoint,
    geom = "point",
    mapping = mapping,
    data = data,
    position = "identity",
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(radius = radius, na.rm = na.rm, ...)
  )
}

#' @rdname geom_circular_point
#' @export
geom_circular_rug <- function(
  mapping = NULL,
  data = NULL,
  ...,
  radius = 1,
  rug_length = 0.05,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
) {
  ggplot2::layer(
    stat = StatCircularRug,
    geom = "segment",
    mapping = mapping,
    data = data,
    position = "identity",
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(radius = radius, rug_length = rug_length, na.rm = na.rm, ...)
  )
}

StatCircularPoint <- ggplot2::ggproto(
  "StatCircularPoint",
  ggplot2::Stat,
  required_aes = "x",
  compute_group = function(data, scales, radius = 1, na.rm = FALSE) {
    keep <- !is.na(data$x)
    if (!isTRUE(na.rm) && any(!keep)) {
      rlang::warn("Removed missing values from `geom_circular_point()`.")
    }
    data <- data[keep, , drop = FALSE]
    if (!"y" %in% names(data)) {
      data$y <- radius
    }
    data
  }
)

StatCircularRug <- ggplot2::ggproto(
  "StatCircularRug",
  ggplot2::Stat,
  required_aes = "x",
  compute_group = function(data, scales, radius = 1, rug_length = 0.05, na.rm = FALSE) {
    keep <- !is.na(data$x)
    if (!isTRUE(na.rm) && any(!keep)) {
      rlang::warn("Removed missing values from `geom_circular_rug()`.")
    }
    data <- data[keep, , drop = FALSE]
    data$xend <- data$x
    data$y <- radius
    data$yend <- radius - rug_length
    data
  }
)
