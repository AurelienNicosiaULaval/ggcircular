#' Compute step lengths
#'
#' @param x,y Numeric coordinate vectors.
#'
#' @return Numeric vector of Euclidean step lengths. The first value is `NA`.
#' @export
#' @family movement helpers
compute_step_length <- function(x, y) {
  if (!is.numeric(x) || !is.numeric(y)) {
    rlang::abort("`x` and `y` must be numeric vectors.")
  }
  sqrt(c(NA_real_, diff(x))^2 + c(NA_real_, diff(y))^2)
}

#' Compute bearings
#'
#' @param x,y Numeric coordinate vectors.
#' @param angle_convention Angle convention. `"mathematical"` means zero is east
#'   and angles increase counterclockwise. `"bearing"` means zero is north and
#'   angles increase clockwise.
#'
#' @return Numeric vector of bearings in radians. The first value is `NA`.
#' @export
#' @family movement helpers
compute_bearing <- function(
  x,
  y,
  angle_convention = c("mathematical", "bearing")
) {
  if (!is.numeric(x) || !is.numeric(y)) {
    rlang::abort("`x` and `y` must be numeric vectors.")
  }
  angle_convention <- match.arg(angle_convention)
  dx <- c(NA_real_, diff(x))
  dy <- c(NA_real_, diff(y))
  angle <- if (identical(angle_convention, "bearing")) {
    atan2(dx, dy)
  } else {
    atan2(dy, dx)
  }
  normalize_angle(angle)
}

#' Compute turn angles
#'
#' @param bearing Numeric vector of bearings in radians.
#' @param period Angular period.
#'
#' @return Numeric vector of signed turn angles. The first value is `NA`.
#' @export
#' @family movement helpers
compute_turn_angle <- function(bearing, period = 2 * pi) {
  check_angle(bearing)
  if (length(bearing) == 0L) {
    return(numeric())
  }
  c(NA_real_, angular_difference(bearing[-1], bearing[-length(bearing)], period = period))
}

#' Add directional movement features
#'
#' Computes step length, bearing and turn angle from track coordinates. When
#' `id` and `time` are supplied, records are sorted by individual and time before
#' features are computed.
#'
#' @param data A data frame.
#' @param x,y Coordinate columns.
#' @param id Optional individual identifier column.
#' @param time Optional time column used for sorting within individual.
#' @param angle_convention Angle convention passed to [compute_bearing()].
#'
#' @return A tibble with added `step_length`, `bearing` and `turn_angle`.
#' @export
#' @family movement helpers
#'
#' @examples
#' tibble::tibble(id = 1, time = 1:3, x = 0:2, y = 0) |>
#'   mutate_directional_features(x = x, y = y, id = id, time = time)
mutate_directional_features <- function(
  data,
  x,
  y,
  id = NULL,
  time = NULL,
  angle_convention = c("mathematical", "bearing")
) {
  angle_convention <- match.arg(angle_convention)
  x <- rlang::enquo(x)
  y <- rlang::enquo(y)
  id <- rlang::enquo(id)
  time <- rlang::enquo(time)

  out <- tibble::as_tibble(data)
  arrange_quos <- list()
  if (!rlang::quo_is_null(id)) {
    arrange_quos <- c(arrange_quos, list(id))
  }
  if (!rlang::quo_is_null(time)) {
    arrange_quos <- c(arrange_quos, list(time))
  }
  if (length(arrange_quos) > 0L) {
    out <- dplyr::arrange(out, !!!arrange_quos)
  }
  if (!rlang::quo_is_null(id)) {
    out <- dplyr::group_by(out, !!id)
  }

  out <- dplyr::mutate(
    out,
    .dx = !!x - dplyr::lag(!!x),
    .dy = !!y - dplyr::lag(!!y),
    step_length = sqrt(.data$.dx^2 + .data$.dy^2),
    bearing = normalize_angle(
      if (identical(angle_convention, "bearing")) {
        atan2(.data$.dx, .data$.dy)
      } else {
        atan2(.data$.dy, .data$.dx)
      }
    ),
    turn_angle = angular_difference(.data$bearing, dplyr::lag(.data$bearing))
  )
  out |>
    dplyr::ungroup() |>
    dplyr::select(-dplyr::all_of(c(".dx", ".dy")))
}

#' Coerce to step data
#'
#' Thin wrapper around [mutate_directional_features()] for pipelines where a
#' more explicit movement-data verb is useful.
#'
#' @inheritParams mutate_directional_features
#'
#' @return A tibble with movement features.
#' @export
#' @family movement helpers
as_step_data <- function(
  data,
  x,
  y,
  id = NULL,
  time = NULL,
  angle_convention = c("mathematical", "bearing")
) {
  mutate_directional_features(
    data = data,
    x = {{ x }},
    y = {{ y }},
    id = {{ id }},
    time = {{ time }},
    angle_convention = angle_convention
  )
}
