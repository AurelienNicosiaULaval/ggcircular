draw_variable_names <- function(draws) {
  setdiff(names(draws), c(".chain", ".iteration", ".draw"))
}

#' Convert posterior draws to circular draws
#'
#' Converts objects supported by `posterior::as_draws_df()` into a long tibble
#' of normalized angular draws.
#'
#' @param draws Posterior draws object.
#' @param variables Optional variables to keep.
#' @param period Angular period.
#' @param origin Lower bound of the normalized interval.
#'
#' @return A tibble with draw identifiers, `.variable` and `.angle`.
#' @export
#' @family posterior helpers
as_circular_draws <- function(draws, variables = NULL, period = 2 * pi, origin = 0) {
  if (!requireNamespace("posterior", quietly = TRUE)) {
    rlang::abort("Package `posterior` is required for `as_circular_draws()`.")
  }
  draws_df <- tibble::as_tibble(posterior::as_draws_df(draws))
  variables <- variables %||% draw_variable_names(draws_df)
  missing <- setdiff(variables, names(draws_df))
  if (length(missing) > 0L) {
    rlang::abort(paste0("Unknown draw variable(s): ", paste(missing, collapse = ", "), "."))
  }

  id_cols <- intersect(c(".chain", ".iteration", ".draw"), names(draws_df))
  out <- dplyr::bind_rows(lapply(variables, function(var) {
    tibble::tibble(
      !!!draws_df[id_cols],
      .variable = var,
      .angle = normalize_angle(draws_df[[var]], period = period, origin = origin)
    )
  }))
  class(out) <- c("ggcircular_draws", class(out))
  out
}

#' Summarize circular posterior draws
#'
#' @param draws Circular draws from [as_circular_draws()] or any object accepted
#'   by `posterior::as_draws_df()`.
#' @param variables Optional variables to summarize.
#' @param level Credible interval level.
#' @param axial Should draws be treated as axial, modulo `pi`?
#' @param ... Additional arguments passed to [as_circular_draws()] when needed.
#'
#' @return A tibble with posterior circular summaries.
#' @export
#' @family posterior helpers
summarise_circular_draws <- function(draws, variables = NULL, level = 0.95, axial = FALSE, ...) {
  if (!inherits(draws, "ggcircular_draws")) {
    draws <- as_circular_draws(draws, variables = variables, period = angle_period(axial), ...)
  }
  if (!is.null(variables)) {
    draws <- dplyr::filter(draws, .data$.variable %in% variables)
  }
  pieces <- split(draws$.angle, draws$.variable)
  dplyr::bind_rows(lapply(names(pieces), function(variable) {
    angle <- pieces[[variable]]
    mean <- mean_direction(angle, axial = axial)
    delta <- angular_difference(angle, mean, period = angle_period(axial))
    alpha <- 1 - level
    q <- stats::quantile(delta, probs = c(alpha / 2, 1 - alpha / 2), na.rm = TRUE, names = FALSE)
    tibble::tibble(
      .variable = variable,
      n = length(angle),
      mean = mean,
      Rbar = mean_resultant_length(angle, axial = axial),
      lower = normalize_angle(mean + q[1], period = angle_period(axial)),
      upper = normalize_angle(mean + q[2], period = angle_period(axial)),
      level = level
    )
  }))
}

#' Autoplot circular posterior draws
#'
#' @param draws Circular draws or posterior draws.
#' @param variables Optional variables to plot.
#' @param type Plot type.
#' @param axial Should draws be treated as axial, modulo `pi`?
#' @param ... Additional arguments passed to [as_circular_draws()] when needed.
#'
#' @return A ggplot object.
#' @export
#' @family posterior helpers
autoplot_circular_draws <- function(
  draws,
  variables = NULL,
  type = c("density", "interval"),
  axial = FALSE,
  ...
) {
  type <- match.arg(type)
  if (!inherits(draws, "ggcircular_draws")) {
    draws <- as_circular_draws(draws, variables = variables, period = angle_period(axial), ...)
  }
  if (!is.null(variables)) {
    draws <- dplyr::filter(draws, .data$.variable %in% variables)
  }
  if (identical(type, "density")) {
    return(
      ggplot2::ggplot(draws, ggplot2::aes(x = .data$.angle, colour = .data$.variable)) +
        geom_circular_density(axial = axial, linewidth = 1) +
        scale_x_circular_radians(limits = c(0, angle_period(axial))) +
        coord_circular() +
        theme_circular()
    )
  }
  summaries <- summarise_circular_draws(draws, variables = variables, axial = axial)
  ggplot2::ggplot(summaries, ggplot2::aes(x = .data$.variable, y = .data$mean)) +
    ggplot2::geom_point() +
    ggplot2::geom_errorbar(ggplot2::aes(ymin = .data$lower, ymax = .data$upper), width = 0.1) +
    ggplot2::scale_y_continuous(limits = c(0, angle_period(axial))) +
    ggplot2::labs(x = NULL, y = "Circular mean") +
    ggplot2::theme_minimal()
}

#' @method autoplot ggcircular_draws
#' @export
autoplot.ggcircular_draws <- function(object, ...) {
  autoplot_circular_draws(object, ...)
}
