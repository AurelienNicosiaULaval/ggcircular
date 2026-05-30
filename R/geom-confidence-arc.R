#' Circular confidence arc
#'
#' Draws angular intervals as arcs at a fixed radius. Intervals crossing zero
#' are split into two path segments.
#'
#' @param mapping,data,show.legend,inherit.aes Standard ggplot2 layer
#'   arguments.
#' @param ... Additional arguments passed to the path geometry.
#' @param radius Default radius used when no `radius` or `y` aesthetic is
#'   supplied.
#' @param n Number of points used to discretize each interval.
#' @param na.rm Should missing interval endpoints be silently removed?
#'
#' @return A ggplot2 layer.
#' @export
#' @family circular intervals
#'
#' @examples
#' tibble::tibble(lower = 5.5, upper = 0.5) |>
#'   ggplot2::ggplot(ggplot2::aes(xmin = lower, xmax = upper)) +
#'   geom_confidence_arc()
geom_confidence_arc <- function(
  mapping = NULL,
  data = NULL,
  ...,
  radius = 1,
  n = 200,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
) {
  ggplot2::layer(
    stat = StatConfidenceArc,
    geom = "path",
    mapping = mapping,
    data = data,
    position = "identity",
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(radius = radius, n = n, na.rm = na.rm, ...)
  )
}

#' @rdname geom_confidence_arc
#' @export
geom_circular_interval <- geom_confidence_arc

StatConfidenceArc <- ggplot2::ggproto(
  "StatConfidenceArc",
  ggplot2::Stat,
  required_aes = c("xmin", "xmax"),
  compute_group = function(data, scales, radius = 1, n = 200, na.rm = FALSE) {
    if (!is.numeric(n) || length(n) != 1L || is.na(n) || n < 2) {
      rlang::abort("`n` must be a single integer greater than 1.")
    }

    pieces <- vector("list", nrow(data) * 2L)
    piece_id <- 0L
    base_group <- if ("group" %in% names(data)) data$group[1] else 1L
    for (i in seq_len(nrow(data))) {
      xmin <- data$xmin[i]
      xmax <- data$xmax[i]
      if (is.na(xmin) || is.na(xmax)) {
        if (!isTRUE(na.rm)) {
          rlang::warn("Removed missing values from `geom_confidence_arc()`.")
        }
        next
      }
      row_radius <- if ("radius" %in% names(data)) {
        data$radius[i]
      } else if ("y" %in% names(data)) {
        data$y[i]
      } else {
        radius
      }
      row_radius <- if (is.na(row_radius)) radius else row_radius

      xmin <- normalize_angle(xmin)
      xmax <- normalize_angle(xmax)
      ranges <- if (xmin <= xmax) {
        list(c(xmin, xmax))
      } else {
        list(c(xmin, 2 * pi), c(0, xmax))
      }
      for (j in seq_along(ranges)) {
        piece_id <- piece_id + 1L
        x <- seq(ranges[[j]][1], ranges[[j]][2], length.out = ceiling(n / length(ranges)))
        pieces[[piece_id]] <- tibble::tibble(
          x = x,
          y = row_radius,
          group = base_group * 100000L + i * 10L + j
        )
      }
    }
    dplyr::bind_rows(pieces[seq_len(piece_id)])
  }
)
