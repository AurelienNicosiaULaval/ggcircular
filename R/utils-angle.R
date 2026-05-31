#' Normalize angles to a periodic interval
#'
#' `normalize_angle()` maps numeric angles to `[origin, origin + period)`.
#' The default period is `2 * pi`, which is appropriate for directional
#' circular data measured in radians.
#'
#' @param x Numeric vector of angles.
#' @param period Positive numeric period. Use `2 * pi` for directional data and
#'   `pi` for axial data.
#' @param origin Lower bound of the target interval.
#'
#' @return A numeric vector with the same length as `x`.
#' @export
#' @family angle utilities
#'
#' @examples
#' normalize_angle(c(-pi, 0, 3 * pi))
normalize_angle <- function(x, period = 2 * pi, origin = 0) {
  check_angle(x)
  if (!is.numeric(period) || length(period) != 1L || is.na(period) || period <= 0) {
    rlang::abort("`period` must be a single positive number.")
  }
  if (!is.numeric(origin) || length(origin) != 1L || is.na(origin)) {
    rlang::abort("`origin` must be a single non-missing number.")
  }

  out <- ((x - origin) %% period) + origin
  tol <- 100 * .Machine$double.eps * max(1, abs(period), abs(origin))
  out[!is.na(out) & abs(out - (origin + period)) <= tol] <- origin
  out[!is.na(out) & abs(out - origin) <= tol] <- origin
  out
}

#' Signed angular difference
#'
#' Computes the signed difference `x - y` on a periodic scale. With the default
#' period, values are returned in `[-pi, pi)`.
#'
#' @param x,y Numeric vectors of angles.
#' @param period Positive numeric period.
#'
#' @return A numeric vector following R recycling rules.
#' @export
#' @family angle utilities
#'
#' @examples
#' angular_difference(0, 3 * pi / 2)
angular_difference <- function(x, y, period = 2 * pi) {
  check_angle(x)
  check_angle(y)
  normalize_angle(x - y, period = period, origin = -period / 2)
}

#' Circular angular distance
#'
#' Computes the non-negative angular distance between `x` and `y`. With the
#' default period, values are returned in `[0, pi]`.
#'
#' @param x,y Numeric vectors of angles.
#' @param period Positive numeric period.
#'
#' @return A non-negative numeric vector.
#' @export
#' @family angle utilities
#'
#' @examples
#' angular_distance(0, 3 * pi / 2)
angular_distance <- function(x, y, period = 2 * pi) {
  abs(angular_difference(x, y, period = period))
}

#' Convert degrees to radians
#'
#' @param x Numeric vector in degrees.
#'
#' @return Numeric vector in radians.
#' @export
#' @family angle utilities
deg_to_rad <- function(x) {
  check_angle(x)
  x * pi / 180
}

#' Convert radians to degrees
#'
#' @param x Numeric vector in radians.
#'
#' @return Numeric vector in degrees.
#' @export
#' @family angle utilities
rad_to_deg <- function(x) {
  check_angle(x)
  x * 180 / pi
}

#' Convert hours to radians
#'
#' @param x Numeric vector in hours on a 24-hour clock.
#'
#' @return Numeric vector in radians.
#' @export
#' @family angle utilities
hour_to_rad <- function(x) {
  check_angle(x)
  x * 2 * pi / 24
}

#' Convert radians to hours
#'
#' @param x Numeric vector in radians.
#'
#' @return Numeric vector in hours on a 24-hour clock.
#' @export
#' @family angle utilities
rad_to_hour <- function(x) {
  check_angle(x)
  normalize_angle(x) * 24 / (2 * pi)
}

#' Convert compass labels to radians
#'
#' Converts the eight standard compass labels `N`, `NE`, `E`, `SE`, `S`, `SW`,
#' `W` and `NW` to bearing angles in radians, where zero is north and angles
#' increase clockwise.
#'
#' @param x Character vector of compass labels.
#'
#' @return Numeric vector of bearing angles in radians.
#' @export
#' @family angle utilities
#'
#' @examples
#' compass_to_rad(c("N", "E", "S", "W"))
compass_to_rad <- function(x) {
  if (!is.character(x)) {
    rlang::abort("`x` must be a character vector of compass labels.")
  }

  key <- c(
    N = 0,
    NE = pi / 4,
    E = pi / 2,
    SE = 3 * pi / 4,
    S = pi,
    SW = 5 * pi / 4,
    W = 3 * pi / 2,
    NW = 7 * pi / 4
  )
  x_clean <- toupper(trimws(x))
  out <- unname(key[x_clean])
  out[is.na(x)] <- NA_real_
  if (any(is.na(out) & !is.na(x))) {
    bad <- unique(x[is.na(out) & !is.na(x)])
    rlang::abort(
      paste0(
        "Unknown compass label",
        if (length(bad) > 1L) "s" else "",
        ": ",
        paste(bad, collapse = ", "),
        "."
      )
    )
  }
  out
}

#' Convert radians to compass labels
#'
#' Converts angles to the nearest label among `labels`. Angles are interpreted
#' as bearings by default: zero is north and angles increase clockwise.
#'
#' @param x Numeric vector of angles in radians.
#' @param labels Character vector of equally spaced labels.
#'
#' @return Character vector of labels.
#' @export
#' @family angle utilities
#'
#' @examples
#' rad_to_compass(c(0, pi / 2, pi))
rad_to_compass <- function(
  x,
  labels = c("N", "NE", "E", "SE", "S", "SW", "W", "NW")
) {
  check_angle(x)
  if (!is.character(labels) || length(labels) < 1L) {
    rlang::abort("`labels` must be a non-empty character vector.")
  }

  n_labels <- length(labels)
  step <- 2 * pi / n_labels
  x_norm <- normalize_angle(x + step / 2)
  index <- floor(x_norm / step) + 1L
  index[index > n_labels] <- 1L
  out <- labels[index]
  out[is.na(x)] <- NA_character_
  out
}

#' Test whether an object can represent angles
#'
#' @param x Object to test.
#'
#' @return `TRUE` when `x` is numeric and contains only finite values or `NA`.
#' @export
#' @family angle utilities
is_angle <- function(x) {
  is.numeric(x) && all(is.finite(x) | is.na(x))
}

#' Check an angle vector
#'
#' @param x Object to check.
#' @param allow_na Should missing values be allowed?
#'
#' @return Invisibly returns `x` if the check succeeds.
#' @export
#' @family angle utilities
check_angle <- function(x, allow_na = TRUE) {
  if (!is.numeric(x)) {
    rlang::abort("Angles must be numeric.")
  }
  vctrs::vec_size(x)
  if (!allow_na && anyNA(x)) {
    rlang::abort("Angles must not contain missing values.")
  }
  if (any(!is.finite(x) & !is.na(x))) {
    rlang::abort("Angles must be finite or missing.")
  }
  invisible(x)
}

angle_period <- function(axial = FALSE) {
  if (isTRUE(axial)) pi else 2 * pi
}

directionalize_angle <- function(x, axial = FALSE) {
  if (isTRUE(axial)) 2 * x else x
}

undirectionalize_angle <- function(x, axial = FALSE) {
  if (isTRUE(axial)) x / 2 else x
}
