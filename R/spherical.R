#' Convert spherical coordinates to Cartesian coordinates
#'
#' @param theta Azimuth angle in radians.
#' @param phi Colatitude or elevation angle in radians.
#' @param radius Radius.
#' @param convention Interpretation of `phi`.
#'
#' @return A tibble with `x`, `y` and `z`.
#' @export
#' @family spherical helpers
spherical_to_cartesian <- function(
  theta,
  phi,
  radius = 1,
  convention = c("azimuth_colatitude", "azimuth_elevation")
) {
  convention <- match.arg(convention)
  check_angle(theta)
  check_angle(phi)
  if (!is.numeric(radius)) {
    rlang::abort("`radius` must be numeric.")
  }
  common <- vctrs::vec_recycle_common(theta = theta, phi = phi, radius = radius)
  theta <- common$theta
  phi <- common$phi
  radius <- common$radius

  if (identical(convention, "azimuth_colatitude")) {
    xy <- radius * sin(phi)
    z <- radius * cos(phi)
  } else {
    xy <- radius * cos(phi)
    z <- radius * sin(phi)
  }
  tibble::tibble(
    x = xy * cos(theta),
    y = xy * sin(theta),
    z = z
  )
}

#' Convert Cartesian coordinates to spherical coordinates
#'
#' @param x,y,z Cartesian coordinates.
#' @param convention Output convention for `phi`.
#'
#' @return A tibble with `theta`, `phi` and `radius`.
#' @export
#' @family spherical helpers
cartesian_to_spherical <- function(
  x,
  y,
  z,
  convention = c("azimuth_colatitude", "azimuth_elevation")
) {
  convention <- match.arg(convention)
  if (!is.numeric(x) || !is.numeric(y) || !is.numeric(z)) {
    rlang::abort("`x`, `y` and `z` must be numeric.")
  }
  common <- vctrs::vec_recycle_common(x = x, y = y, z = z)
  x <- common$x
  y <- common$y
  z <- common$z
  radius <- sqrt(x^2 + y^2 + z^2)
  theta <- normalize_angle(atan2(y, x))
  ratio <- z / pmax(radius, .Machine$double.eps)
  ratio <- pmin(1, pmax(-1, ratio))
  phi <- if (identical(convention, "azimuth_colatitude")) {
    acos(ratio)
  } else {
    asin(ratio)
  }
  tibble::tibble(theta = theta, phi = phi, radius = radius)
}

#' Summarize spherical directions
#'
#' Computes the mean direction vector and mean spherical coordinates.
#'
#' @param theta Azimuth angle in radians.
#' @param phi Colatitude or elevation angle in radians.
#' @param weights Optional non-negative weights.
#' @param convention Interpretation of `phi`.
#' @param na.rm Should missing values be removed?
#'
#' @return A tibble with sample size, mean spherical coordinates and resultant
#'   length.
#' @export
#' @family spherical helpers
spherical_summary <- function(
  theta,
  phi,
  weights = NULL,
  convention = c("azimuth_colatitude", "azimuth_elevation"),
  na.rm = TRUE
) {
  convention <- match.arg(convention)
  coords <- spherical_to_cartesian(theta, phi, convention = convention)
  weights <- weights %||% rep(1, nrow(coords))
  if (!is.numeric(weights) || length(weights) != nrow(coords) || any(weights < 0, na.rm = TRUE)) {
    rlang::abort("`weights` must be a non-negative numeric vector with the same length as `theta`.")
  }
  keep <- stats::complete.cases(coords) & !is.na(weights) & weights > 0
  if (!isTRUE(na.rm) && any(!keep)) {
    rlang::abort("Missing values are not allowed when `na.rm = FALSE`.")
  }
  coords <- coords[keep, , drop = FALSE]
  weights <- weights[keep]
  if (nrow(coords) == 0L) {
    return(tibble::tibble(n = 0L, mean_theta = NA_real_, mean_phi = NA_real_, R = NA_real_, Rbar = NA_real_, x = NA_real_, y = NA_real_, z = NA_real_))
  }
  mx <- stats::weighted.mean(coords$x, weights)
  my <- stats::weighted.mean(coords$y, weights)
  mz <- stats::weighted.mean(coords$z, weights)
  R <- sqrt(sum((colSums(as.matrix(coords) * weights))^2))
  Rbar <- sqrt(mx^2 + my^2 + mz^2)
  sph <- cartesian_to_spherical(mx, my, mz, convention = convention)
  tibble::tibble(
    n = nrow(coords),
    mean_theta = sph$theta,
    mean_phi = sph$phi,
    R = R,
    Rbar = Rbar,
    x = mx,
    y = my,
    z = mz
  )
}
