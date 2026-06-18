make_cv_folds <- function(n, n_folds, seed = NULL) {
  n_folds <- directional_count(n_folds, "n_folds", minimum = 2L)
  if (n_folds > n) {
    rlang::abort("`n_folds` cannot exceed the sample size.")
  }
  if (!is.null(seed)) {
    set.seed(seed)
  }
  sample(rep(seq_len(n_folds), length.out = n))
}

cyl_conditional_log_score <- function(theta_train, x_train, theta_valid, x_valid, kappa, h) {
  angular_weights <- outer(
    theta_valid,
    theta_train,
    function(valid_value, train_value) {
      stable_vm_weight(directional_signed_difference(valid_value, train_value), kappa)
    }
  )
  linear_weights <- outer(
    x_valid,
    x_train,
    function(valid_value, train_value) {
      gaussian_kernel(valid_value - train_value, h)
    }
  )
  denom <- rowSums(angular_weights)
  density <- rowSums(angular_weights * linear_weights) / pmax(denom, .Machine$double.eps)
  mean(log(pmax(density, .Machine$double.eps)))
}

tor_conditional_log_score <- function(theta_train, phi_train, theta_valid, phi_valid, kappa_theta, kappa_phi) {
  theta_weights <- outer(
    theta_valid,
    theta_train,
    function(valid_value, train_value) {
      stable_vm_weight(directional_signed_difference(valid_value, train_value), kappa_theta)
    }
  )
  phi_weights <- outer(
    phi_valid,
    phi_train,
    function(valid_value, train_value) {
      stable_vm_weight(directional_signed_difference(valid_value, train_value), kappa_phi)
    }
  )
  denom <- rowSums(theta_weights)
  density <- exp(log_vm_stable_normalizing_constant(kappa_phi)) *
    rowSums(theta_weights * phi_weights) / pmax(denom, .Machine$double.eps)
  mean(log(pmax(density, .Machine$double.eps)))
}

#' Select smoothing parameters for circular-linear conditional density
#'
#' Ranks candidate smoothing parameters by K-fold conditional log-likelihood.
#'
#' @param theta Conditioning angles in radians.
#' @param x Linear response.
#' @param kappa_values Candidate circular concentration values.
#' @param h_values Candidate linear bandwidth values. If `NULL`, a small grid is
#'   built around the rule-of-thumb bandwidth used by [estimate_cyl_density()].
#' @param n_folds Number of cross-validation folds.
#' @param seed Optional random seed for fold assignment.
#'
#' @return A data frame ranked by decreasing mean held-out log score. The
#'   returned object has class `directional_smoothing_selection`.
#' @export
#' @family directional smoothing helpers
#'
#' @examples
#' dat <- simulate_cylindrical(n = 80, seed = 1)
#' select_cyl_smoothing(
#'   dat$theta, dat$x,
#'   kappa_values = c(8, 12),
#'   h_values = c(0.3, 0.5),
#'   n_folds = 2,
#'   seed = 1
#' )
select_cyl_smoothing <- function(
  theta,
  x,
  kappa_values = c(6, 8, 12, 16, 24, 36),
  h_values = NULL,
  n_folds = 5,
  seed = NULL
) {
  theta <- directional_wrap(directional_numeric(theta, "theta"))
  x <- directional_numeric(x, "x")
  directional_check_pair(theta, x, "theta", "x")
  kappa_values <- directional_numeric(kappa_values, "kappa_values")
  if (any(kappa_values <= 0)) {
    rlang::abort("`kappa_values` must be positive.")
  }
  if (is.null(h_values)) {
    h0 <- default_linear_bandwidth(x)
    h_values <- h0 * c(0.6, 0.8, 1.0, 1.3, 1.7)
  }
  h_values <- directional_numeric(h_values, "h_values")
  if (any(h_values <= 0)) {
    rlang::abort("`h_values` must be positive.")
  }

  folds <- make_cv_folds(length(theta), n_folds = n_folds, seed = seed)
  candidates <- expand.grid(kappa = kappa_values, h = h_values, stringsAsFactors = FALSE)
  candidates$mean_log_score <- NA_real_
  candidates$se_log_score <- NA_real_

  for (candidate_id in seq_len(nrow(candidates))) {
    fold_scores <- numeric(max(folds))
    for (fold_id in seq_len(max(folds))) {
      valid <- folds == fold_id
      fold_scores[fold_id] <- cyl_conditional_log_score(
        theta_train = theta[!valid],
        x_train = x[!valid],
        theta_valid = theta[valid],
        x_valid = x[valid],
        kappa = candidates$kappa[candidate_id],
        h = candidates$h[candidate_id]
      )
    }
    candidates$mean_log_score[candidate_id] <- mean(fold_scores)
    candidates$se_log_score[candidate_id] <- stats::sd(fold_scores) / sqrt(length(fold_scores))
  }

  candidates <- candidates[order(candidates$mean_log_score, decreasing = TRUE), , drop = FALSE]
  candidates$rank <- seq_len(nrow(candidates))
  row.names(candidates) <- NULL
  class(candidates) <- c("directional_smoothing_selection", class(candidates))
  candidates
}

#' Select smoothing parameters for toroidal conditional density
#'
#' Ranks candidate smoothing parameters by K-fold conditional log-likelihood for
#' `f(phi | theta)`.
#'
#' @param theta Conditioning angles in radians.
#' @param phi Response angles in radians.
#' @param kappa_theta_values Candidate concentrations for the conditioning
#'   angle.
#' @param kappa_phi_values Candidate concentrations for the response angle.
#' @param n_folds Number of cross-validation folds.
#' @param seed Optional random seed for fold assignment.
#'
#' @return A data frame ranked by decreasing mean held-out log score. The
#'   returned object has class `directional_smoothing_selection`.
#' @export
#' @family directional smoothing helpers
#'
#' @examples
#' dat <- simulate_toroidal(n = 80, scenario = "diagonal", seed = 1)
#' select_toroidal_smoothing(
#'   dat$theta, dat$phi,
#'   kappa_theta_values = c(8, 12),
#'   kappa_phi_values = c(8, 12),
#'   n_folds = 2,
#'   seed = 1
#' )
select_toroidal_smoothing <- function(
  theta,
  phi,
  kappa_theta_values = c(6, 8, 12, 16, 24, 36),
  kappa_phi_values = kappa_theta_values,
  n_folds = 5,
  seed = NULL
) {
  theta <- directional_wrap(directional_numeric(theta, "theta"))
  phi <- directional_wrap(directional_numeric(phi, "phi"))
  directional_check_pair(theta, phi, "theta", "phi")
  kappa_theta_values <- directional_numeric(kappa_theta_values, "kappa_theta_values")
  kappa_phi_values <- directional_numeric(kappa_phi_values, "kappa_phi_values")
  if (any(kappa_theta_values <= 0)) {
    rlang::abort("`kappa_theta_values` must be positive.")
  }
  if (any(kappa_phi_values <= 0)) {
    rlang::abort("`kappa_phi_values` must be positive.")
  }

  folds <- make_cv_folds(length(theta), n_folds = n_folds, seed = seed)
  candidates <- expand.grid(
    kappa_theta = kappa_theta_values,
    kappa_phi = kappa_phi_values,
    stringsAsFactors = FALSE
  )
  candidates$mean_log_score <- NA_real_
  candidates$se_log_score <- NA_real_

  for (candidate_id in seq_len(nrow(candidates))) {
    fold_scores <- numeric(max(folds))
    for (fold_id in seq_len(max(folds))) {
      valid <- folds == fold_id
      fold_scores[fold_id] <- tor_conditional_log_score(
        theta_train = theta[!valid],
        phi_train = phi[!valid],
        theta_valid = theta[valid],
        phi_valid = phi[valid],
        kappa_theta = candidates$kappa_theta[candidate_id],
        kappa_phi = candidates$kappa_phi[candidate_id]
      )
    }
    candidates$mean_log_score[candidate_id] <- mean(fold_scores)
    candidates$se_log_score[candidate_id] <- stats::sd(fold_scores) / sqrt(length(fold_scores))
  }

  candidates <- candidates[order(candidates$mean_log_score, decreasing = TRUE), , drop = FALSE]
  candidates$rank <- seq_len(nrow(candidates))
  row.names(candidates) <- NULL
  class(candidates) <- c("directional_smoothing_selection", class(candidates))
  candidates
}
