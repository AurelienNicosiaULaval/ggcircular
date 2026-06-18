#' List built-in directional diagnostic scenarios
#'
#' @return A data frame describing the built-in diagnostic scenarios.
#' @export
#' @family directional diagnostics
#'
#' @examples
#' diagnostic_scenarios()
diagnostic_scenarios <- function() {
  data.frame(
    space = c(rep("cylindrical", 5), rep("toroidal", 5)),
    scenario = c(
      "independent", "smooth", "heteroscedastic", "multimodal", "seam",
      "independent_concentrated", "diagonal", "doubling", "bifurcation",
      "uniform_marginal_dependence"
    ),
    expected = c(
      "Same conditional distribution of x for all theta.",
      "Narrow conditional band following a smooth function of theta.",
      "Conditional spread changes with theta while the mean is stable.",
      "Several conditional modes may make the local mean misleading.",
      "Structure crosses the 0/2pi seam and should remain continuous.",
      "Same conditional distribution of phi for all theta.",
      "Diagonal ridge: phi follows theta modulo 2pi.",
      "Wrapped nonlinear ridge: phi follows 2theta modulo 2pi.",
      "Two conditional branches create ridge bifurcations.",
      "Marginals can be near uniform while conditional dependence remains."
    ),
    stringsAsFactors = FALSE
  )
}

#' Simulate diagnostic circular-linear data
#'
#' @param n Number of observations.
#' @param scenario Diagnostic scenario.
#' @param seed Optional random seed.
#'
#' @return A data frame with `theta`, `x` and `scenario`.
#' @export
#' @family directional diagnostics
#'
#' @examples
#' simulate_cyl_diagnostic(n = 40, scenario = "smooth", seed = 1)
simulate_cyl_diagnostic <- function(
  n = 800,
  scenario = c("independent", "smooth", "heteroscedastic", "multimodal", "seam"),
  seed = NULL
) {
  scenario <- match.arg(scenario)
  n <- directional_count(n, "n", minimum = 1L)
  if (!is.null(seed)) {
    set.seed(seed)
  }

  theta <- stats::runif(n, 0, 2 * pi)

  if (scenario == "independent") {
    x <- stats::rnorm(n, mean = 3, sd = 0.75)
  }
  if (scenario == "smooth") {
    x <- 3 + 0.95 * cos(theta - 0.35) + 0.35 * sin(2 * theta + 0.5) +
      stats::rnorm(n, sd = 0.28)
  }
  if (scenario == "heteroscedastic") {
    sig <- 0.20 + 0.95 * (1 + sin(theta - 0.8)) / 2
    x <- 3 + stats::rnorm(n, sd = sig)
  }
  if (scenario == "multimodal") {
    branch <- stats::runif(n) < 0.50
    mu1 <- 2.55 + 0.55 * cos(theta - 0.3)
    mu2 <- 3.75 - 0.60 * sin(theta + 0.6)
    x <- ifelse(branch, mu1, mu2) + stats::rnorm(n, sd = 0.18)
  }
  if (scenario == "seam") {
    x <- 3 + 1.05 * cos(theta) + stats::rnorm(n, sd = 0.25)
  }

  data.frame(theta = directional_wrap(theta), x = x, scenario = scenario)
}

#' Simulate diagnostic circular-circular data
#'
#' @param n Number of observations.
#' @param scenario Diagnostic scenario.
#' @param seed Optional random seed.
#'
#' @return A data frame with `theta`, `phi` and `scenario`.
#' @export
#' @family directional diagnostics
#'
#' @examples
#' simulate_tor_diagnostic(n = 40, scenario = "diagonal", seed = 1)
simulate_tor_diagnostic <- function(
  n = 900,
  scenario = c(
    "independent_concentrated", "diagonal", "doubling", "bifurcation",
    "uniform_marginal_dependence"
  ),
  seed = NULL
) {
  scenario <- match.arg(scenario)
  n <- directional_count(n, "n", minimum = 1L)
  if (!is.null(seed)) {
    set.seed(seed)
  }

  theta <- stats::runif(n, 0, 2 * pi)

  if (scenario == "independent_concentrated") {
    phi <- directional_rvonmises(n, mu = 1.2, kappa = 7)
  }
  if (scenario == "diagonal") {
    phi <- directional_rvonmises(n, mu = theta, kappa = 12)
  }
  if (scenario == "doubling") {
    phi <- directional_rvonmises(n, mu = 2 * theta, kappa = 12)
  }
  if (scenario == "bifurcation") {
    branch <- stats::runif(n) < 0.50
    mu <- ifelse(branch, theta + 0.65 * sin(theta), theta + pi - 0.65 * sin(theta))
    phi <- directional_rvonmises(n, mu = mu, kappa = 14)
  }
  if (scenario == "uniform_marginal_dependence") {
    branch <- stats::runif(n) < 0.50
    mu <- theta + ifelse(branch, 0, pi)
    phi <- directional_rvonmises(n, mu = mu, kappa = 18)
  }

  data.frame(theta = directional_wrap(theta), phi = directional_wrap(phi), scenario = scenario)
}

#' Build diagnostic atlas data
#'
#' @param space Either `"cylindrical"` or `"toroidal"`.
#' @param n Number of observations per scenario.
#' @param seed Optional random seed.
#'
#' @return A data frame with diagnostic scenarios and plotting columns. The
#'   returned object has class `diagnostic_atlas_data`.
#' @export
#' @family directional diagnostics
#'
#' @examples
#' diagnostic_atlas_data("cylindrical", n = 20, seed = 1)
diagnostic_atlas_data <- function(space = c("cylindrical", "toroidal"), n = 600, seed = 20260609) {
  space <- match.arg(space)
  n <- directional_count(n, "n", minimum = 1L)

  if (space == "cylindrical") {
    scenarios <- c("independent", "smooth", "heteroscedastic", "multimodal", "seam")
    labels <- c("independent", "smooth mean", "variable spread", "multiple modes", "seam crossing")
    pieces <- lapply(seq_along(scenarios), function(j) {
      scenario_seed <- if (is.null(seed)) NULL else seed + j
      simulate_cyl_diagnostic(n = n, scenario = scenarios[j], seed = scenario_seed)
    })
    data <- do.call(rbind, pieces)
    data$space <- space
    data$theta_plot <- directional_signed_angle(data$theta)
    data$scenario_label <- factor(data$scenario, levels = scenarios, labels = labels)
  } else {
    scenarios <- c(
      "independent_concentrated", "diagonal", "doubling", "bifurcation",
      "uniform_marginal_dependence"
    )
    labels <- c("independent", "diagonal", "doubling", "bifurcation", "uniform margins\nwith dependence")
    pieces <- lapply(seq_along(scenarios), function(j) {
      scenario_seed <- if (is.null(seed)) NULL else seed + j
      simulate_tor_diagnostic(n = n, scenario = scenarios[j], seed = scenario_seed)
    })
    data <- do.call(rbind, pieces)
    data$space <- space
    data$theta_plot <- directional_signed_angle(data$theta)
    data$phi_plot <- directional_signed_angle(data$phi)
    data$scenario_label <- factor(data$scenario, levels = scenarios, labels = labels)
  }

  attr(data, "space") <- space
  class(data) <- c("diagnostic_atlas_data", class(data))
  data
}

#' Plot diagnostic atlas data
#'
#' @param object Object returned by [diagnostic_atlas_data()].
#' @param ... Reserved for future extensions.
#' @param point_alpha Point transparency.
#' @param point_size Point size.
#' @param smooth Should a loess smooth be added for cylindrical data?
#' @param base_size Base font size.
#'
#' @return A ggplot object.
#' @method autoplot diagnostic_atlas_data
#' @export
#' @family directional diagnostics
#'
#' @examples
#' atlas <- diagnostic_atlas_data("cylindrical", n = 20, seed = 1)
#' ggplot2::autoplot(atlas)
autoplot.diagnostic_atlas_data <- function(
  object,
  ...,
  point_alpha = 0.20,
  point_size = 0.7,
  smooth = TRUE,
  base_size = 11
) {
  space <- attr(object, "space", exact = TRUE)
  if (is.null(space)) {
    space <- if ("phi" %in% names(object)) "toroidal" else "cylindrical"
  }
  br <- signed_angle_breaks_labels()

  if (space == "cylindrical") {
    plot <- ggplot2::ggplot(object, ggplot2::aes(theta_plot, x)) +
      ggplot2::geom_point(alpha = point_alpha, size = point_size, colour = "#2d6aa3")
    if (isTRUE(smooth)) {
      plot <- plot +
        ggplot2::geom_smooth(
          se = FALSE,
          method = "loess",
          formula = y ~ x,
          colour = "#172554",
          linewidth = 0.9
        )
    }
    plot +
      ggplot2::facet_wrap(~scenario_label, ncol = 2, scales = "free_y") +
      ggplot2::scale_x_continuous(breaks = br$breaks, labels = br$labels) +
      theme_directional_dependence(base_size = base_size, legend_position = "none") +
      ggplot2::labs(title = "Diagnostic atlas: cylindrical scenarios", x = "theta", y = "x")
  } else {
    ggplot2::ggplot(object, ggplot2::aes(theta_plot, phi_plot)) +
      ggplot2::geom_point(alpha = point_alpha, size = point_size, colour = "#1f766e") +
      ggplot2::facet_wrap(~scenario_label, ncol = 2) +
      ggplot2::scale_x_continuous(breaks = br$breaks, labels = br$labels) +
      ggplot2::scale_y_continuous(breaks = br$breaks, labels = br$labels) +
      ggplot2::coord_equal() +
      theme_directional_dependence(base_size = base_size, legend_position = "none") +
      ggplot2::labs(title = "Diagnostic atlas: toroidal scenarios", x = "theta", y = "phi")
  }
}

#' Plot a diagnostic atlas
#'
#' @param space Either `"cylindrical"` or `"toroidal"`.
#' @param n Number of observations per scenario.
#' @param seed Optional random seed.
#'
#' @return A ggplot object.
#' @export
#' @family directional diagnostics
#'
#' @examples
#' plot_diagnostic_atlas("toroidal", n = 20, seed = 1)
plot_diagnostic_atlas <- function(space = c("cylindrical", "toroidal"), n = 600, seed = 20260609) {
  ggplot2::autoplot(diagnostic_atlas_data(space = space, n = n, seed = seed))
}

#' Plot a classical unfolded comparison
#'
#' @param data Data frame containing `theta` and either `x` or `phi`.
#' @param space Either `"cylindrical"` or `"toroidal"`.
#'
#' @return A ggplot object.
#' @export
#' @family directional diagnostics
#'
#' @examples
#' dat <- simulate_cyl_diagnostic(n = 40, scenario = "smooth", seed = 1)
#' plot_classical_comparison(dat, "cylindrical")
plot_classical_comparison <- function(data, space = c("cylindrical", "toroidal")) {
  space <- match.arg(space)
  if (!is.data.frame(data)) {
    rlang::abort("`data` must be a data frame.")
  }
  br <- signed_angle_breaks_labels()

  if (space == "cylindrical") {
    if (!all(c("theta", "x") %in% names(data))) {
      rlang::abort("Cylindrical data must contain `theta` and `x`.")
    }
    data$theta_plot <- directional_signed_angle(data$theta)
    ggplot2::ggplot(data, ggplot2::aes(theta_plot, x)) +
      ggplot2::geom_point(alpha = 0.35, size = 0.9, colour = "#2d6aa3") +
      ggplot2::scale_x_continuous(breaks = br$breaks, labels = br$labels) +
      theme_directional_dependence(base_size = 11, legend_position = "none") +
      ggplot2::labs(title = "Classical unfolded circular-linear display", x = "theta", y = "x")
  } else {
    if (!all(c("theta", "phi") %in% names(data))) {
      rlang::abort("Toroidal data must contain `theta` and `phi`.")
    }
    data$theta_plot <- directional_signed_angle(data$theta)
    data$phi_plot <- directional_signed_angle(data$phi)
    ggplot2::ggplot(data, ggplot2::aes(theta_plot, phi_plot)) +
      ggplot2::geom_point(alpha = 0.35, size = 0.9, colour = "#1f766e") +
      ggplot2::scale_x_continuous(breaks = br$breaks, labels = br$labels) +
      ggplot2::scale_y_continuous(breaks = br$breaks, labels = br$labels) +
      ggplot2::coord_equal() +
      theme_directional_dependence(base_size = 11, legend_position = "none") +
      ggplot2::labs(title = "Classical unfolded circular-circular display", x = "theta", y = "phi")
  }
}
