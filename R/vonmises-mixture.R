mixture_density_matrix <- function(theta, mu, kappa, axial = FALSE) {
  if (isTRUE(axial)) {
    out <- vapply(seq_along(mu), function(j) {
      2 * dvonmises_density(2 * theta, mu = 2 * mu[j], kappa = kappa[j])
    }, numeric(length(theta)))
  } else {
    out <- vapply(seq_along(mu), function(j) {
      dvonmises_density(theta, mu = mu[j], kappa = kappa[j])
    }, numeric(length(theta)))
  }
  if (is.null(dim(out))) {
    out <- matrix(out, ncol = length(mu))
  }
  out
}

mixture_density <- function(theta, proportions, mu, kappa, axial = FALSE) {
  as.numeric(mixture_density_matrix(theta, mu, kappa, axial = axial) %*% proportions)
}

initial_mixture_mu <- function(theta, k, axial = FALSE, init = "kmeans") {
  period <- angle_period(axial)
  if (identical(init, "spaced") || length(theta) < k) {
    return(seq(0, period, length.out = k + 1L)[seq_len(k)])
  }
  theta_fit <- directionalize_angle(theta, axial = axial)
  km <- stats::kmeans(cbind(cos(theta_fit), sin(theta_fit)), centers = k, nstart = 10)
  mu <- atan2(km$centers[, 2], km$centers[, 1])
  normalize_angle(undirectionalize_angle(mu, axial = axial), period = period)
}

#' Fit a mixture of von Mises distributions
#'
#' Fits a finite mixture of von Mises components using an expectation
#' maximization algorithm. For axial data, the algorithm fits doubled angles and
#' returns component means on the original modulo-`pi` scale.
#'
#' @param x Numeric vector of angles in radians.
#' @param k Number of mixture components.
#' @param weights Optional non-negative observation weights.
#' @param axial Should data be treated as axial, modulo `pi`?
#' @param init Initialization method, either `"kmeans"` or `"spaced"`.
#' @param max_iter Maximum number of EM iterations.
#' @param tol Convergence tolerance on the log-likelihood.
#' @param na.rm Should missing values be removed?
#'
#' @return An object of class `ggcircular_vonmises_mixture`.
#' @export
#' @family circular distributions
#'
#' @examples
#' fit <- fit_vonmises_mixture(wind_directions$direction, k = 2)
#' tidy_circular(fit)
fit_vonmises_mixture <- function(
  x,
  k = 2,
  weights = NULL,
  axial = FALSE,
  init = c("kmeans", "spaced"),
  max_iter = 200,
  tol = 1e-8,
  na.rm = TRUE
) {
  init <- match.arg(init)
  check_angle(x)
  if (!is.numeric(k) || length(k) != 1L || is.na(k) || k < 1) {
    rlang::abort("`k` must be a single positive integer.")
  }
  k <- as.integer(k)
  if (!is.numeric(max_iter) || length(max_iter) != 1L || is.na(max_iter) || max_iter < 1) {
    rlang::abort("`max_iter` must be a single positive integer.")
  }
  if (!is.numeric(tol) || length(tol) != 1L || is.na(tol) || tol <= 0) {
    rlang::abort("`tol` must be a single positive number.")
  }

  weights <- weights %||% rep(1, length(x))
  if (!is.numeric(weights) || length(weights) != length(x) || any(weights < 0, na.rm = TRUE)) {
    rlang::abort("`weights` must be a non-negative numeric vector with the same length as `x`.")
  }

  keep <- !is.na(x) & !is.na(weights) & weights > 0
  if (!isTRUE(na.rm) && any(!keep)) {
    rlang::abort("`x` and `weights` must not contain missing or zero-weight observations when `na.rm = FALSE`.")
  }
  x <- normalize_angle(x[keep], period = angle_period(axial))
  weights <- weights[keep]
  if (length(x) < k) {
    rlang::abort("The number of non-missing observations must be at least `k`.")
  }

  proportions <- rep(1 / k, k)
  mu <- initial_mixture_mu(x, k = k, axial = axial, init = init)
  kappa <- rep(1, k)
  loglik <- -Inf
  responsibilities <- matrix(1 / k, nrow = length(x), ncol = k)
  converged <- FALSE

  for (iter in seq_len(max_iter)) {
    component_density <- mixture_density_matrix(x, mu, kappa, axial = axial)
    weighted_density <- sweep(component_density, 2, proportions, `*`)
    mixture <- rowSums(weighted_density)
    responsibilities <- weighted_density / pmax(mixture, .Machine$double.xmin)

    component_weight <- colSums(responsibilities * weights)
    proportions <- component_weight / sum(component_weight)
    for (j in seq_len(k)) {
      wj <- responsibilities[, j] * weights
      theta_j <- directionalize_angle(x, axial = axial)
      C <- sum(wj * cos(theta_j)) / sum(wj)
      S <- sum(wj * sin(theta_j)) / sum(wj)
      mu[j] <- normalize_angle(undirectionalize_angle(atan2(S, C), axial = axial), period = angle_period(axial))
      Rbar <- sqrt(C^2 + S^2)
      kappa[j] <- kappa_from_Rbar(Rbar)
      if (!is.finite(kappa[j])) {
        kappa[j] <- 1e6
      }
    }

    new_loglik <- sum(weights * log(pmax(mixture_density(x, proportions, mu, kappa, axial = axial), .Machine$double.xmin)))
    if (is.finite(loglik) && abs(new_loglik - loglik) < tol) {
      converged <- TRUE
      loglik <- new_loglik
      break
    }
    loglik <- new_loglik
  }

  order_id <- order(mu)
  proportions <- proportions[order_id]
  mu <- mu[order_id]
  kappa <- kappa[order_id]
  responsibilities <- responsibilities[, order_id, drop = FALSE]
  colnames(responsibilities) <- paste0("component_", seq_len(k))

  out <- list(
    x = x,
    weights = weights,
    k = k,
    proportions = proportions,
    mu = mu,
    kappa = kappa,
    responsibilities = responsibilities,
    axial = axial,
    logLik = loglik,
    iterations = iter,
    converged = converged
  )
  class(out) <- "ggcircular_vonmises_mixture"
  out
}

#' @export
tidy_circular.ggcircular_vonmises_mixture <- function(x, ...) {
  tibble::tibble(
    component = seq_len(x$k),
    proportion = x$proportions,
    mu = x$mu,
    kappa = x$kappa
  )
}

#' @export
augment_circular.ggcircular_vonmises_mixture <- function(x, ...) {
  resp <- tibble::as_tibble(x$responsibilities)
  best <- max.col(x$responsibilities, ties.method = "first")
  dplyr::bind_cols(
    tibble::tibble(
      .angle = x$x,
      .component = best,
      .probability = x$responsibilities[cbind(seq_along(best), best)],
      .fitted = x$mu[best]
    ),
    resp
  )
}

#' @export
glance_circular.ggcircular_vonmises_mixture <- function(x, ...) {
  npar <- 3 * x$k - 1
  tibble::tibble(
    n = length(x$x),
    components = x$k,
    logLik = x$logLik,
    AIC = -2 * x$logLik + 2 * npar,
    BIC = -2 * x$logLik + log(length(x$x)) * npar,
    iterations = x$iterations,
    converged = x$converged,
    axial = x$axial
  )
}

#' Von Mises mixture density layer
#'
#' Fits or draws a mixture of von Mises densities.
#'
#' @param mapping,data,geom,position,show.legend,inherit.aes Standard ggplot2
#'   layer arguments.
#' @param ... Additional arguments passed to the layer.
#' @param fit Optional `ggcircular_vonmises_mixture` object. If `NULL`, the
#'   mixture is fitted to the layer's `x` aesthetic.
#' @param k Number of components when fitting inside the statistic.
#' @param n Number of grid points.
#' @param axial Should data be treated as axial, modulo `pi`?
#' @param na.rm Should missing values be removed before fitting?
#'
#' @return A ggplot2 layer.
#' @export
#' @family circular distributions
stat_vonmises_mixture <- function(
  mapping = NULL,
  data = NULL,
  geom = "line",
  position = "identity",
  ...,
  fit = NULL,
  k = 2,
  n = 512,
  axial = FALSE,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
) {
  if (!is.null(fit)) {
    data <- data %||% data.frame(.ggcircular = 1)
    inherit.aes <- FALSE
  }
  ggplot2::layer(
    stat = StatVonmisesMixture,
    geom = geom,
    mapping = mapping,
    data = data,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(fit = fit, k = k, n = n, axial = axial, na.rm = na.rm, ...)
  )
}

StatVonmisesMixture <- ggplot2::ggproto(
  "StatVonmisesMixture",
  ggplot2::Stat,
  required_aes = character(0),
  default_aes = ggplot2::aes(y = ggplot2::after_stat(density)),
  compute_group = function(data, scales, fit = NULL, k = 2, n = 512, axial = FALSE, na.rm = FALSE) {
    if (is.null(fit)) {
      if (!"x" %in% names(data)) {
        rlang::abort("`stat_vonmises_mixture()` requires an `x` aesthetic when `fit` is not supplied.")
      }
      fit <- fit_vonmises_mixture(data$x, k = k, axial = axial, na.rm = TRUE)
    }
    grid <- theoretical_grid(n = n, axial = fit$axial)
    density <- mixture_density(grid, fit$proportions, fit$mu, fit$kappa, axial = fit$axial)
    tibble::tibble(
      x = grid,
      density = density,
      components = fit$k,
      logLik = fit$logLik
    )
  }
)

#' @method autoplot ggcircular_vonmises_mixture
#' @export
autoplot.ggcircular_vonmises_mixture <- function(object, n = 512, show_components = TRUE, ...) {
  grid <- theoretical_grid(n = n, axial = object$axial)
  density <- mixture_density(grid, object$proportions, object$mu, object$kappa, axial = object$axial)
  p <- ggplot2::ggplot(tibble::tibble(x = grid, density = density), ggplot2::aes(x = .data$x, y = .data$density)) +
    ggplot2::geom_line(linewidth = 1)
  if (isTRUE(show_components)) {
    components <- dplyr::bind_rows(lapply(seq_len(object$k), function(j) {
      tibble::tibble(
        x = grid,
        density = object$proportions[j] * mixture_density_matrix(grid, object$mu[j], object$kappa[j], axial = object$axial)[, 1],
        component = factor(j)
      )
    }))
    p <- p + ggplot2::geom_line(
      data = components,
      ggplot2::aes(x = .data$x, y = .data$density, colour = .data$component),
      linetype = 2
    )
  }
  p +
    scale_x_circular_radians(limits = c(0, angle_period(object$axial))) +
    coord_circular() +
    theme_circular()
}
