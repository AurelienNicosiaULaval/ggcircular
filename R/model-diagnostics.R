model_primary_fit <- function(object) {
  if (inherits(object, "angular_two_step")) {
    return(object$homogeneous_fit %||% object$consensus_fit)
  }
  object
}

model_observed <- function(object) {
  fit <- model_primary_fit(object)
  observed <- fit$y %||% fit$response %||% NULL
  if (is.null(observed)) {
    rlang::abort("Could not find observed angular responses in the model object.")
  }
  as.numeric(observed)
}

model_fitted <- function(object) {
  fit <- model_primary_fit(object)
  fitted <- fit$mui %||% tryCatch(stats::fitted(fit), error = function(e) NULL)
  if (is.null(fitted)) {
    rlang::abort("Could not find fitted angular values in the model object.")
  }
  normalize_angle(as.numeric(fitted))
}

model_residuals <- function(object) {
  residuals <- tryCatch(stats::residuals(model_primary_fit(object)), error = function(e) NULL)
  if (!is.null(residuals)) {
    return(angular_difference(as.numeric(residuals), 0))
  }
  angular_difference(model_observed(object), model_fitted(object))
}

model_terms <- function(object) {
  fit <- model_primary_fit(object)
  coef_names <- tryCatch(names(stats::coef(fit)), error = function(e) NULL)
  fit$term_labels %||% fit$paramname %||% coef_names %||% character()
}

validate_model_diagnostic_lengths <- function(observed, fitted, data = NULL) {
  if (length(observed) != length(fitted)) {
    rlang::abort(
      "`object` must provide observed and fitted angular values with the same length."
    )
  }
  if (!is.null(data) && nrow(data) != length(observed)) {
    rlang::abort(
      "`data` must have the same number of rows as the extracted model diagnostics."
    )
  }
  invisible(NULL)
}

#' Circular residuals for angular models
#'
#' Extracts observed angles, fitted angles and signed circular residuals from
#' supported angular model objects. The function currently supports objects
#' produced by the optional `CircularRegression` package when their fitted values
#' are stored in a `mui` component.
#'
#' @param object A supported angular model object.
#' @param data Optional data frame to bind to the diagnostic columns.
#' @param ... Reserved for future methods.
#'
#' @return A tibble with `.observed`, `.fitted`, `.resid`, `.abs_resid`,
#'   `.index` and `.model_class`.
#' @export
#' @family circular model helpers
#'
#' @examples
#' if (requireNamespace("CircularRegression", quietly = TRUE)) {
#'   set.seed(1)
#'   df <- tibble::tibble(y = normalize_angle(rnorm(30)), x = rnorm(30))
#'   fit <- CircularRegression::consensus(y ~ x, data = df)
#'   circular_residuals(fit)
#' }
circular_residuals <- function(object, data = NULL, ...) {
  observed <- normalize_angle(model_observed(object))
  fitted <- normalize_angle(model_fitted(object))
  if (!is.null(data)) {
    data <- tibble::as_tibble(data)
  }
  validate_model_diagnostic_lengths(observed, fitted, data = data)
  n <- length(observed)
  resid <- angular_difference(observed, fitted)

  out <- tibble::tibble(
    .observed = observed,
    .fitted = fitted,
    .resid = resid,
    .abs_resid = abs(resid),
    .index = seq_len(n),
    .model_class = class(object)[1]
  )

  if (!is.null(data)) {
    out <- dplyr::bind_cols(data, out)
  }
  out
}

#' Circular model diagnostics
#'
#' Summarizes circular residual diagnostics for supported angular model objects.
#'
#' @inheritParams circular_residuals
#'
#' @return A tibble with residual mean direction, resultant length, circular
#'   variance and maximum absolute circular residual.
#' @export
#' @family circular model helpers
circular_model_diagnostics <- function(object, data = NULL, ...) {
  res <- circular_residuals(object, data = data)
  tibble::tibble(
    model_class = class(object)[1],
    n = nrow(res),
    residual_mean = mean_direction(res$.resid),
    residual_Rbar = mean_resultant_length(res$.resid),
    residual_variance = circular_variance(res$.resid),
    max_abs_residual = max(res$.abs_resid, na.rm = TRUE)
  )
}

tidy_coefficients <- function(object, component = NULL) {
  coef <- tryCatch(stats::coef(object), error = function(e) NULL)
  if (!is.null(coef) && length(coef) > 0L) {
    out <- tibble::tibble(
      term = names(coef) %||% paste0("term", seq_along(coef)),
      estimate = as.numeric(coef)
    )
  } else if (!is.null(object$parameters) && length(object$parameters) > 0L) {
    params <- as.data.frame(object$parameters)
    term <- rownames(params)
    if (is.null(term) || any(term == "")) {
      term <- paste0("term", seq_len(nrow(params)))
    }
    estimate <- params[[1]]
    out <- tibble::tibble(term = term, estimate = as.numeric(estimate))
    extra_names <- intersect(c("se", "std.error", "statistic", "p.value"), names(params))
    if (length(extra_names) > 0L) {
      out <- dplyr::bind_cols(out, tibble::as_tibble(params[extra_names]))
    }
  } else {
    terms <- model_terms(object)
    out <- tibble::tibble(term = terms, estimate = numeric(length(terms)))
  }

  if (!is.null(component)) {
    out <- dplyr::mutate(out, component = component, .before = 1)
  }
  out
}

glance_model <- function(object) {
  fit <- model_primary_fit(object)
  log_lik <- tryCatch(as.numeric(stats::logLik(fit)), error = function(e) NA_real_)
  aic <- tryCatch(stats::AIC(fit), error = function(e) fit$AIC %||% NA_real_)
  bic <- tryCatch(stats::BIC(fit), error = function(e) fit$BIC %||% NA_real_)
  coef <- tryCatch(stats::coef(fit), error = function(e) numeric())
  tibble::tibble(
    model_class = class(object)[1],
    nobs = fit$nobs %||% length(fit$y %||% numeric()),
    npar = fit$k %||% length(coef),
    logLik = log_lik,
    AIC = as.numeric(aic),
    BIC = as.numeric(bic),
    kappa = as.numeric(fit$kappahat %||% fit$kappa[1] %||% NA_real_)
  )
}
