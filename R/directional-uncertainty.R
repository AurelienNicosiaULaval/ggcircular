#' Bootstrap a statistical orbit
#'
#' @param theta Angles in radians.
#' @param x Real-valued response.
#' @param n_boot Number of bootstrap resamples.
#' @param n_theta Number of angular grid points.
#' @param kappa Circular concentration for local weighting.
#' @param seed Optional random seed.
#'
#' @return A data frame with point estimates and bootstrap intervals. The
#'   returned object has class `bootstrap_stat_orbit`.
#' @export
#' @family directional uncertainty helpers
#'
#' @examples
#' dat <- simulate_cylindrical(n = 60, seed = 1)
#' bootstrap_stat_orbit(dat$theta, dat$x, n_boot = 5, n_theta = 12, seed = 1)
bootstrap_stat_orbit <- function(theta, x, n_boot = 100, n_theta = 181, kappa = 20, seed = NULL) {
  theta <- directional_wrap(directional_numeric(theta, "theta"))
  x <- directional_numeric(x, "x")
  directional_check_pair(theta, x, "theta", "x")
  n_boot <- directional_count(n_boot, "n_boot", minimum = 1L)
  if (!is.null(seed)) {
    set.seed(seed)
  }

  base <- stat_orbit_data(theta, x, n_theta = n_theta, kappa = kappa)
  n <- length(theta)
  boot_mu <- matrix(NA_real_, nrow = nrow(base), ncol = n_boot)
  boot_width <- matrix(NA_real_, nrow = nrow(base), ncol = n_boot)

  for (b in seq_len(n_boot)) {
    idx <- sample.int(n, n, replace = TRUE)
    boot <- stat_orbit_data(theta[idx], x[idx], n_theta = n_theta, kappa = kappa)
    boot_mu[, b] <- boot$mu
    boot_width[, b] <- (boot$upper - boot$lower) / 2
  }

  out <- data.frame(
    theta = base$theta,
    mu = base$mu,
    mu_lower = apply(boot_mu, 1, stats::quantile, probs = 0.025, na.rm = TRUE),
    mu_upper = apply(boot_mu, 1, stats::quantile, probs = 0.975, na.rm = TRUE),
    sigma = (base$upper - base$lower) / 2,
    sigma_lower = apply(boot_width, 1, stats::quantile, probs = 0.025, na.rm = TRUE),
    sigma_upper = apply(boot_width, 1, stats::quantile, probs = 0.975, na.rm = TRUE)
  )
  class(out) <- c("bootstrap_stat_orbit", class(out))
  out
}

#' Plot bootstrap uncertainty for a statistical orbit
#'
#' @param object Object returned by [bootstrap_stat_orbit()].
#' @param ... Reserved for future extensions.
#' @param quantity Either `"mu"` or `"sigma"`.
#' @param base_size Base font size.
#' @param ribbon_fill Ribbon fill colour.
#' @param line_colour Line colour.
#'
#' @return A ggplot object.
#' @method autoplot bootstrap_stat_orbit
#' @export
#' @family directional uncertainty helpers
#'
#' @examples
#' dat <- simulate_cylindrical(n = 60, seed = 1)
#' boot <- bootstrap_stat_orbit(dat$theta, dat$x, n_boot = 5, n_theta = 12, seed = 1)
#' ggplot2::autoplot(boot)
autoplot.bootstrap_stat_orbit <- function(
  object,
  ...,
  quantity = c("mu", "sigma"),
  base_size = 11,
  ribbon_fill = "#8fb4ff",
  line_colour = "#123f9b"
) {
  quantity <- match.arg(quantity)
  data <- object
  data$theta_signed <- directional_signed_angle(data$theta)
  br <- signed_angle_breaks_labels()

  if (quantity == "mu") {
    ggplot2::ggplot(data, ggplot2::aes(theta_signed, mu)) +
      ggplot2::geom_ribbon(ggplot2::aes(ymin = mu_lower, ymax = mu_upper), fill = ribbon_fill, alpha = 0.32) +
      ggplot2::geom_line(linewidth = 1.05, colour = line_colour) +
      ggplot2::scale_x_continuous(breaks = br$breaks, labels = br$labels) +
      theme_directional_dependence(base_size = base_size, legend_position = "none") +
      ggplot2::labs(title = "Bootstrap statistical orbit", x = "theta", y = "mu(theta)")
  } else {
    ggplot2::ggplot(data, ggplot2::aes(theta_signed, sigma)) +
      ggplot2::geom_ribbon(ggplot2::aes(ymin = sigma_lower, ymax = sigma_upper), fill = ribbon_fill, alpha = 0.32) +
      ggplot2::geom_line(linewidth = 1.05, colour = line_colour) +
      ggplot2::scale_x_continuous(breaks = br$breaks, labels = br$labels) +
      theme_directional_dependence(base_size = base_size, legend_position = "none") +
      ggplot2::labs(title = "Bootstrap statistical orbit", x = "theta", y = "sigma(theta)")
  }
}

#' Bootstrap a toroidal conditional ridge
#'
#' @param theta First angle in radians.
#' @param phi Second angle in radians.
#' @param n_boot Number of bootstrap resamples.
#' @param n_theta Number of theta grid points.
#' @param n_phi Number of phi grid points.
#' @param kappa_theta Kernel concentration for `theta`.
#' @param kappa_phi Kernel concentration for `phi`.
#' @param level Coverage level for the pointwise circular bootstrap interval.
#' @param seed Optional random seed.
#'
#' @return A data frame with ridge and local concentration intervals. The
#'   returned object has class `bootstrap_toroidal_ridge`.
#' @export
#' @family directional uncertainty helpers
#'
#' @examples
#' dat <- simulate_toroidal(n = 60, scenario = "diagonal", seed = 1)
#' bootstrap_toroidal_ridge(dat$theta, dat$phi, n_boot = 5, n_theta = 12, n_phi = 12, seed = 1)
bootstrap_toroidal_ridge <- function(
  theta,
  phi,
  n_boot = 100,
  n_theta = 181,
  n_phi = 181,
  kappa_theta = 20,
  kappa_phi = 20,
  level = 0.95,
  seed = NULL
) {
  theta <- directional_wrap(directional_numeric(theta, "theta"))
  phi <- directional_wrap(directional_numeric(phi, "phi"))
  directional_check_pair(theta, phi, "theta", "phi")
  n_boot <- directional_count(n_boot, "n_boot", minimum = 1L)
  level <- directional_probability_scalar(level, "level")
  if (level <= 0) {
    rlang::abort("`level` must be greater than zero.")
  }
  if (!is.null(seed)) {
    set.seed(seed)
  }

  base <- toroidal_ridge_data(
    theta,
    phi,
    n_theta = n_theta,
    n_phi = n_phi,
    kappa_theta = kappa_theta,
    kappa_phi = kappa_phi
  )
  n <- length(theta)
  boot_phi <- matrix(NA_real_, nrow = nrow(base), ncol = n_boot)
  boot_rho <- matrix(NA_real_, nrow = nrow(base), ncol = n_boot)

  for (b in seq_len(n_boot)) {
    idx <- sample.int(n, n, replace = TRUE)
    boot <- toroidal_ridge_data(
      theta[idx],
      phi[idx],
      n_theta = n_theta,
      n_phi = n_phi,
      kappa_theta = kappa_theta,
      kappa_phi = kappa_phi
    )
    boot_phi[, b] <- boot$phi
    boot_rho[, b] <- boot$rho
  }

  phi_center <- apply(
    boot_phi,
    1,
    function(values) directional_wrap(Arg(mean(exp(1i * values), na.rm = TRUE)))
  )
  phi_radius <- vapply(
    seq_len(nrow(boot_phi)),
    function(row_id) {
      deviations <- abs(directional_signed_difference(boot_phi[row_id, ], phi_center[row_id]))
      as.numeric(stats::quantile(deviations, probs = level, na.rm = TRUE, names = FALSE))
    },
    numeric(1)
  )
  lower_unwrapped <- directional_signed_angle(phi_center) - phi_radius
  upper_unwrapped <- directional_signed_angle(phi_center) + phi_radius

  out <- data.frame(
    theta = base$theta,
    phi = base$phi,
    phi_signed = directional_signed_angle(base$phi),
    phi_center = phi_center,
    phi_center_signed = directional_signed_angle(phi_center),
    phi_radius = phi_radius,
    phi_lower = directional_signed_angle(lower_unwrapped),
    phi_upper = directional_signed_angle(upper_unwrapped),
    phi_crosses_seam = lower_unwrapped < -pi | upper_unwrapped > pi,
    rho = base$rho,
    rho_lower = apply(boot_rho, 1, stats::quantile, probs = 0.025, na.rm = TRUE),
    rho_upper = apply(boot_rho, 1, stats::quantile, probs = 0.975, na.rm = TRUE),
    level = level
  )
  class(out) <- c("bootstrap_toroidal_ridge", class(out))
  out
}

#' Plot bootstrap uncertainty for a toroidal ridge
#'
#' @param object Object returned by [bootstrap_toroidal_ridge()].
#' @param ... Reserved for future extensions.
#' @param quantity Either `"rho"` or `"ridge"`.
#' @param base_size Base font size.
#' @param ribbon_fill Ribbon fill colour.
#' @param line_colour Line colour.
#'
#' @return A ggplot object.
#' @method autoplot bootstrap_toroidal_ridge
#' @export
#' @family directional uncertainty helpers
#'
#' @examples
#' dat <- simulate_toroidal(n = 60, scenario = "diagonal", seed = 1)
#' boot <- bootstrap_toroidal_ridge(dat$theta, dat$phi, n_boot = 5, n_theta = 12, n_phi = 12, seed = 1)
#' ggplot2::autoplot(boot)
autoplot.bootstrap_toroidal_ridge <- function(
  object,
  ...,
  quantity = c("rho", "ridge"),
  base_size = 11,
  ribbon_fill = "#99d9d0",
  line_colour = "#0f766e"
) {
  quantity <- match.arg(quantity)
  data <- object
  data$theta_signed <- directional_signed_angle(data$theta)
  br <- signed_angle_breaks_labels()

  if (quantity == "rho") {
    ggplot2::ggplot(data, ggplot2::aes(theta_signed, rho)) +
      ggplot2::geom_ribbon(ggplot2::aes(ymin = rho_lower, ymax = rho_upper), fill = ribbon_fill, alpha = 0.35) +
      ggplot2::geom_line(linewidth = 1.05, colour = line_colour) +
      ggplot2::scale_x_continuous(breaks = br$breaks, labels = br$labels) +
      ggplot2::coord_cartesian(ylim = c(0, 1)) +
      theme_directional_dependence(base_size = base_size, legend_position = "none") +
      ggplot2::labs(title = "Bootstrap toroidal ridge", x = "theta", y = "rho(theta)")
  } else {
    regular <- data[!data$phi_crosses_seam, c("theta_signed", "phi_lower", "phi_upper"), drop = FALSE]
    crossing <- data[data$phi_crosses_seam, , drop = FALSE]
    seam_intervals <- if (nrow(crossing)) {
      rbind(
        data.frame(
          theta_signed = crossing$theta_signed,
          phi_lower = rep(-pi, nrow(crossing)),
          phi_upper = crossing$phi_upper
        ),
        data.frame(
          theta_signed = crossing$theta_signed,
          phi_lower = crossing$phi_lower,
          phi_upper = rep(pi, nrow(crossing))
        )
      )
    } else {
      regular[FALSE, , drop = FALSE]
    }
    intervals <- rbind(regular, seam_intervals)
    line_data <- data[order(data$theta_signed), , drop = FALSE]
    line_data$ridge_group <- cumsum(
      c(FALSE, abs(diff(line_data$phi_center_signed)) > pi / 2)
    ) + 1L

    ggplot2::ggplot(data, ggplot2::aes(theta_signed, phi_center_signed)) +
      ggplot2::geom_linerange(
        data = intervals,
        ggplot2::aes(x = theta_signed, ymin = phi_lower, ymax = phi_upper),
        inherit.aes = FALSE,
        colour = ribbon_fill,
        linewidth = 1.8,
        alpha = 0.35
      ) +
      ggplot2::geom_line(
        data = line_data,
        ggplot2::aes(group = ridge_group),
        linewidth = 1.05,
        colour = line_colour
      ) +
      ggplot2::scale_x_continuous(breaks = br$breaks, labels = br$labels) +
      ggplot2::scale_y_continuous(breaks = br$breaks, labels = br$labels) +
      ggplot2::coord_cartesian(ylim = c(-pi, pi)) +
      theme_directional_dependence(base_size = base_size, legend_position = "none") +
      ggplot2::labs(title = "Bootstrap toroidal ridge", x = "theta", y = "ridge(theta)")
  }
}

#' Evaluate sensitivity to smoothing concentration
#'
#' @param theta Conditioning angle in radians.
#' @param target Real-valued response or second angle.
#' @param space Either `"cylindrical"` or `"toroidal"`.
#' @param kappa_values Numeric vector of candidate concentrations.
#'
#' @return A data frame of compact sensitivity summaries.
#' @export
#' @family directional uncertainty helpers
#'
#' @examples
#' dat <- simulate_cylindrical(n = 60, seed = 1)
#' sensitivity_bandwidth_grid(dat$theta, dat$x, space = "cylindrical", kappa_values = c(8, 12))
sensitivity_bandwidth_grid <- function(
  theta,
  target,
  space = c("cylindrical", "toroidal"),
  kappa_values = c(8, 12, 20, 32)
) {
  space <- match.arg(space)
  theta <- directional_wrap(directional_numeric(theta, "theta"))
  target <- directional_numeric(target, "target")
  directional_check_pair(theta, target, "theta", "target")
  kappa_values <- directional_numeric(kappa_values, "kappa_values")
  if (any(kappa_values <= 0)) {
    rlang::abort("`kappa_values` must be positive.")
  }

  out <- lapply(kappa_values, function(kappa) {
    if (space == "cylindrical") {
      orbit <- stat_orbit_data(theta, target, n_theta = 91, kappa = kappa)
      data.frame(
        space = space,
        kappa = kappa,
        mean_range = diff(range(orbit$mu, na.rm = TRUE)),
        mean_sigma = mean((orbit$upper - orbit$lower) / 2, na.rm = TRUE),
        mean_rho = NA_real_
      )
    } else {
      ridge <- toroidal_ridge_data(theta, target, n_theta = 91, n_phi = 91, kappa_theta = kappa, kappa_phi = kappa)
      data.frame(
        space = space,
        kappa = kappa,
        mean_range = diff(range(directional_signed_angle(ridge$phi), na.rm = TRUE)),
        mean_sigma = NA_real_,
        mean_rho = mean(ridge$rho, na.rm = TRUE)
      )
    }
  })
  do.call(rbind, out)
}

#' Estimate angular marginal support
#'
#' Computes a kernel-weighted marginal support score along the conditioning
#' angle. Low relative support marks angular regions where conditional displays
#' should be interpreted cautiously.
#'
#' @param theta Conditioning angles in radians.
#' @param grid Optional angular grid in radians.
#' @param n_theta Number of grid points used when `grid` is `NULL`.
#' @param kappa Circular concentration for local kernel weights.
#' @param relative_threshold Relative support threshold used to flag low-support
#'   regions. With other ingredients fixed, the local standard error is
#'   approximately inflated by `1 / sqrt(relative_support)`. The default 0.15
#'   corresponds to an inflation of about 2.58 relative to the best-supported
#'   direction; 0.25 is a more conservative threshold corresponding to about
#'   twofold inflation.
#'
#' @return A data frame with grid values, support, relative support and flags.
#' @export
#' @family directional uncertainty helpers
#'
#' @examples
#' dat <- simulate_cylindrical(n = 60, seed = 1)
#' marginal_support_data(dat$theta, n_theta = 12)
marginal_support_data <- function(
  theta,
  grid = NULL,
  n_theta = 181,
  kappa = 20,
  relative_threshold = 0.15
) {
  theta <- directional_wrap(directional_numeric(theta, "theta"))
  kappa <- directional_positive_scalar(kappa, "kappa")
  relative_threshold <- directional_probability_scalar(relative_threshold, "relative_threshold")
  if (is.null(grid)) {
    grid <- directional_angle_grid(n_theta)
  } else {
    grid <- directional_wrap(directional_numeric(grid, "grid"))
  }

  support <- vapply(
    grid,
    function(g) sum(stable_vm_weight(directional_signed_difference(g, theta), kappa)),
    numeric(1)
  )
  max_support <- max(support, na.rm = TRUE)
  relative_support <- if (max_support > 0) support / max_support else rep(NA_real_, length(support))

  data.frame(
    theta = grid,
    support = support,
    relative_support = relative_support,
    low_support = relative_support < relative_threshold,
    kappa = kappa,
    relative_threshold = relative_threshold
  )
}

#' Plot angular marginal support
#'
#' @param theta Conditioning angles in radians.
#' @param grid Optional angular grid in radians.
#' @param n_theta Number of grid points used when `grid` is `NULL`.
#' @param kappa Circular concentration for local kernel weights.
#' @param relative_threshold Relative support threshold used to flag low-support
#'   regions.
#' @param base_size Base font size.
#'
#' @return A ggplot object.
#' @export
#' @family directional uncertainty helpers
#'
#' @examples
#' dat <- simulate_cylindrical(n = 60, seed = 1)
#' plot_marginal_support(dat$theta, n_theta = 12)
plot_marginal_support <- function(
  theta,
  grid = NULL,
  n_theta = 181,
  kappa = 20,
  relative_threshold = 0.15,
  base_size = 11
) {
  support <- marginal_support_data(
    theta = theta,
    grid = grid,
    n_theta = n_theta,
    kappa = kappa,
    relative_threshold = relative_threshold
  )
  support$theta_signed <- directional_signed_angle(support$theta)
  br <- signed_angle_breaks_labels()

  ggplot2::ggplot(support, ggplot2::aes(theta_signed, relative_support)) +
    ggplot2::geom_hline(yintercept = relative_threshold, colour = "#b91c1c", linewidth = 0.35, linetype = "dashed") +
    ggplot2::geom_ribbon(
      data = support[support$low_support, , drop = FALSE],
      ggplot2::aes(ymin = 0, ymax = relative_support),
      fill = "#fca5a5",
      alpha = 0.42
    ) +
    ggplot2::geom_line(colour = "#1f4e79", linewidth = 0.8) +
    ggplot2::scale_x_continuous(breaks = br$breaks, labels = br$labels) +
    ggplot2::coord_cartesian(ylim = c(0, 1.02)) +
    theme_directional_dependence(base_size = base_size, legend_position = "none") +
    ggplot2::labs(title = "Angular marginal support", x = "theta", y = "relative support")
}

#' Simulate a visual-inference lineup under independence
#'
#' @param data Data frame containing `theta` and either `x` or `phi`.
#' @param plot_fun Optional function taking one data frame and returning a
#'   ggplot object.
#' @param m Number of lineup panels.
#' @param seed Optional random seed.
#' @param space Either `"cylindrical"` or `"toroidal"`.
#' @param ... Passed to the default plot function when `plot_fun` is `NULL`.
#'
#' @return A list with plots, true position and metadata. The returned object has
#'   class `directional_lineup`.
#' @export
#' @family directional uncertainty helpers
#'
#' @examples
#' dat <- simulate_cyl_diagnostic(n = 40, scenario = "smooth", seed = 1)
#' lineup <- simulate_independence_lineup(
#'   dat,
#'   plot_fun = function(d) ggplot2::ggplot(d, ggplot2::aes(theta, x)) + ggplot2::geom_point(),
#'   m = 4,
#'   seed = 1,
#'   space = "cylindrical"
#' )
#' length(lineup$plots)
simulate_independence_lineup <- function(
  data,
  plot_fun = NULL,
  m = 20,
  seed = NULL,
  space = c("cylindrical", "toroidal"),
  ...
) {
  space <- match.arg(space)
  if (!is.data.frame(data)) {
    rlang::abort("`data` must be a data frame.")
  }
  m <- directional_count(m, "m", minimum = 2L)
  if (!is.null(seed)) {
    set.seed(seed)
  }

  if (space == "cylindrical" && !all(c("theta", "x") %in% names(data))) {
    rlang::abort("Cylindrical data must contain `theta` and `x`.")
  }
  if (space == "toroidal" && !all(c("theta", "phi") %in% names(data))) {
    rlang::abort("Toroidal data must contain `theta` and `phi`.")
  }

  true_position <- sample.int(m, 1)
  panels <- vector("list", m)
  plot_args <- list(...)

  for (j in seq_len(m)) {
    panel <- data
    if (j != true_position) {
      if (space == "cylindrical") {
        panel$x <- sample(panel$x, replace = FALSE)
      } else {
        panel$phi <- sample(panel$phi, replace = FALSE)
      }
    }
    panels[[j]] <- panel
  }

  if (is.null(plot_fun)) {
    plot_fun <- if (space == "cylindrical") {
      function(d) {
        do.call(plot_circular_topography, c(list(theta = d$theta, x = d$x, conditional = TRUE), plot_args))
      }
    } else {
      function(d) {
        do.call(plot_toroidal_topography, c(list(theta = d$theta, phi = d$phi, conditional = TRUE), plot_args))
      }
    }
  }

  plots <- lapply(seq_len(m), function(j) {
    plot_fun(panels[[j]]) + ggplot2::labs(title = paste("Panel", j))
  })

  out <- list(
    plots = plots,
    true_position = true_position,
    metadata = data.frame(
      m = m,
      true_position = true_position,
      space = space,
      null = "permutation preserving observed marginals",
      stringsAsFactors = FALSE
    )
  )
  class(out) <- "directional_lineup"
  out
}
