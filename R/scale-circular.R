is_waiver <- function(x) {
  inherits(x, "waiver")
}

default_circular_breaks <- function(limits, divisions = 8L, include_end = FALSE) {
  period <- diff(limits)
  if (isTRUE(include_end)) {
    seq(limits[1], limits[2], length.out = divisions + 1L)
  } else {
    seq(limits[1], limits[2] - period / divisions, length.out = divisions)
  }
}

label_radians <- function(x) {
  tol <- sqrt(.Machine$double.eps)
  values <- normalize_angle(x)
  labels <- character(length(values))
  known <- c(
    "0" = 0,
    "pi/4" = pi / 4,
    "pi/2" = pi / 2,
    "3*pi/4" = 3 * pi / 4,
    "pi" = pi,
    "5*pi/4" = 5 * pi / 4,
    "3*pi/2" = 3 * pi / 2,
    "7*pi/4" = 7 * pi / 4,
    "2*pi" = 0
  )
  for (i in seq_along(values)) {
    if (is.na(x[i])) {
      labels[i] <- NA_character_
      next
    }
    exact <- names(known)[abs(values[i] - known) < tol]
    if (length(exact) > 0L) {
      labels[i] <- if (abs(x[i] - 2 * pi) < tol) "2*pi" else exact[1]
    } else {
      labels[i] <- scales::label_number(accuracy = 0.001)(x[i])
    }
  }
  labels
}

#' Circular x scales
#'
#' These scales label angular x axes in radians, degrees, hours or compass
#' directions.
#'
#' @param breaks Break positions in radians.
#' @param labels Break labels.
#' @param limits Scale limits in radians.
#' @param ... Additional arguments passed to `ggplot2::scale_x_continuous()`.
#'
#' @return A ggplot2 scale.
#' @export
#' @family circular scales
#'
#' @examples
#' scale_x_circular_radians()
scale_x_circular_radians <- function(
  breaks = ggplot2::waiver(),
  labels = ggplot2::waiver(),
  limits = c(0, 2 * pi),
  ...
) {
  if (is_waiver(breaks)) {
    breaks <- if (diff(limits) <= pi + sqrt(.Machine$double.eps)) {
      seq(limits[1], limits[2], length.out = 5L)
    } else {
      c(0, pi / 2, pi, 3 * pi / 2, 2 * pi)
    }
  }
  if (is_waiver(labels)) {
    labels <- label_radians
  }
  ggplot2::scale_x_continuous(
    breaks = breaks,
    labels = labels,
    limits = limits,
    expand = c(0, 0),
    ...
  )
}

#' @rdname scale_x_circular_radians
#' @export
scale_x_circular_degrees <- function(
  breaks = ggplot2::waiver(),
  labels = ggplot2::waiver(),
  limits = c(0, 2 * pi),
  ...
) {
  if (is_waiver(breaks)) {
    breaks <- default_circular_breaks(limits, divisions = 8L)
  }
  if (is_waiver(labels)) {
    labels <- function(x) paste0(round(rad_to_deg(x)) %% 360, "\u00b0")
  }
  ggplot2::scale_x_continuous(
    breaks = breaks,
    labels = labels,
    limits = limits,
    expand = c(0, 0),
    ...
  )
}

#' @rdname scale_x_circular_radians
#' @export
scale_x_circular_hours <- function(
  breaks = ggplot2::waiver(),
  labels = ggplot2::waiver(),
  limits = c(0, 2 * pi),
  ...
) {
  if (is_waiver(breaks)) {
    breaks <- default_circular_breaks(limits, divisions = 8L)
  }
  if (is_waiver(labels)) {
    labels <- function(x) sprintf("%02d:00", round(rad_to_hour(x)) %% 24)
  }
  ggplot2::scale_x_continuous(
    breaks = breaks,
    labels = labels,
    limits = limits,
    expand = c(0, 0),
    ...
  )
}

#' @rdname scale_x_circular_radians
#' @export
scale_x_circular_compass <- function(
  breaks = ggplot2::waiver(),
  labels = ggplot2::waiver(),
  limits = c(0, 2 * pi),
  ...
) {
  if (is_waiver(breaks)) {
    breaks <- default_circular_breaks(limits, divisions = 8L)
  }
  if (is_waiver(labels)) {
    labels <- rad_to_compass
  }
  ggplot2::scale_x_continuous(
    breaks = breaks,
    labels = labels,
    limits = limits,
    expand = c(0, 0),
    ...
  )
}
