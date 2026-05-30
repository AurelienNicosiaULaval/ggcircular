#' Circular model helper generics
#'
#' Lightweight generics reserved for future integration with angular regression
#' packages. The default methods fail with an explicit message rather than
#' silently returning incomplete output.
#'
#' @param x A model or circular object.
#' @param ... Additional arguments passed to methods.
#'
#' @return Method-dependent tibble output.
#' @export
#' @family circular model helpers
augment_circular <- function(x, ...) {
  UseMethod("augment_circular")
}

#' @export
augment_circular.default <- function(x, ...) {
  rlang::abort("No `augment_circular()` method is available for this object.")
}

#' @rdname augment_circular
#' @export
tidy_circular <- function(x, ...) {
  UseMethod("tidy_circular")
}

#' @export
tidy_circular.default <- function(x, ...) {
  rlang::abort("No `tidy_circular()` method is available for this object.")
}

#' @rdname augment_circular
#' @export
glance_circular <- function(x, ...) {
  UseMethod("glance_circular")
}

#' @export
glance_circular.default <- function(x, ...) {
  rlang::abort("No `glance_circular()` method is available for this object.")
}

#' @export
tidy_circular.angular <- function(x, ...) {
  tidy_coefficients(x)
}

#' @export
augment_circular.angular <- function(x, data = NULL, ...) {
  circular_residuals(x, data = data)
}

#' @export
glance_circular.angular <- function(x, ...) {
  glance_model(x)
}

#' @export
tidy_circular.consensus <- function(x, ...) {
  tidy_coefficients(x)
}

#' @export
augment_circular.consensus <- function(x, data = NULL, ...) {
  circular_residuals(x, data = data)
}

#' @export
glance_circular.consensus <- function(x, ...) {
  glance_model(x)
}

#' @export
tidy_circular.angular_two_step <- function(x, ...) {
  dplyr::bind_rows(
    tidy_coefficients(x$consensus_fit, component = "consensus"),
    tidy_coefficients(x$homogeneous_fit, component = "angular")
  )
}

#' @export
augment_circular.angular_two_step <- function(x, data = NULL, ...) {
  circular_residuals(x, data = data)
}

#' @export
glance_circular.angular_two_step <- function(x, ...) {
  out <- glance_model(x)
  out$reference <- x$reference %||% NA_character_
  out
}
