#' Simulate circular-linear data
#'
#' Simulates examples on the cylinder, where `theta` is an angle in radians and
#' `x` is a real-valued response.
#'
#' @param n Number of observations.
#' @param scenario Dependence pattern to simulate.
#' @param seed Optional random seed.
#'
#' @return A data frame with columns `theta`, `x` and `scenario`.
#' @export
#' @family directional simulation helpers
#'
#' @examples
#' simulate_cylindrical(n = 30, scenario = "nonlinear", seed = 1)
simulate_cylindrical <- function(
  n = 500,
  scenario = c("nonlinear", "independent", "unimodal", "heteroscedastic", "multimodal"),
  seed = NULL
) {
  scenario <- match.arg(scenario)
  n <- directional_count(n, "n", minimum = 1L)
  if (!is.null(seed)) {
    set.seed(seed)
  }

  theta <- stats::runif(n, 0, 2 * pi)

  if (scenario == "independent") {
    x <- stats::rnorm(n, mean = 5, sd = 1)
  }
  if (scenario == "unimodal") {
    mu <- 5 + 1.5 * cos(theta - 0.6)
    x <- mu + stats::rnorm(n, sd = 0.6)
  }
  if (scenario == "nonlinear") {
    mu <- 5 + 1.4 * cos(theta - 0.5) - 0.9 * sin(2 * theta + 0.2) + 0.45 * cos(4 * theta)
    x <- mu + stats::rnorm(n, sd = 0.65)
  }
  if (scenario == "heteroscedastic") {
    mu <- 5 + 1.2 * cos(theta - 0.5) - 0.8 * sin(2 * theta)
    sig <- 0.35 + 0.9 * (1 + sin(theta - 1.1)) / 2
    x <- mu + stats::rnorm(n, sd = sig)
  }
  if (scenario == "multimodal") {
    mu1 <- 4.5 + 1.2 * cos(theta - 0.4)
    mu2 <- 6.2 - 1.1 * sin(theta + 0.8)
    p <- 0.5 + 0.25 * sin(theta)
    branch <- stats::runif(n) < p
    x <- ifelse(branch, mu1, mu2) + stats::rnorm(n, sd = 0.35)
  }

  data.frame(theta = directional_wrap(theta), x = x, scenario = scenario)
}

#' Simulate circular-circular data
#'
#' Simulates examples on the torus, where both `theta` and `phi` are angles in
#' radians.
#'
#' @param n Number of observations.
#' @param scenario Dependence pattern to simulate.
#' @param seed Optional random seed.
#'
#' @return A data frame with columns `theta`, `phi` and `scenario`.
#' @export
#' @family directional simulation helpers
#'
#' @examples
#' simulate_toroidal(n = 30, scenario = "diagonal", seed = 1)
simulate_toroidal <- function(
  n = 500,
  scenario = c("nonlinear", "diagonal", "anti_diagonal", "multimodal", "independent"),
  seed = NULL
) {
  scenario <- match.arg(scenario)
  n <- directional_count(n, "n", minimum = 1L)
  if (!is.null(seed)) {
    set.seed(seed)
  }

  theta <- stats::runif(n, 0, 2 * pi)

  if (scenario == "independent") {
    phi <- stats::runif(n, 0, 2 * pi)
  }
  if (scenario == "diagonal") {
    phi <- directional_rvonmises(n, mu = theta, kappa = 8)
  }
  if (scenario == "anti_diagonal") {
    phi <- directional_rvonmises(n, mu = -theta, kappa = 8)
  }
  if (scenario == "nonlinear") {
    mu <- theta + 0.9 * sin(theta - 0.5) + 0.4 * sin(2 * theta + 0.7)
    phi <- directional_rvonmises(n, mu = mu, kappa = 9)
  }
  if (scenario == "multimodal") {
    mu1 <- theta + 0.8 * sin(theta - 0.4)
    mu2 <- mu1 + pi * 0.7
    branch <- stats::runif(n) < 0.35
    mu <- ifelse(branch, mu2, mu1)
    phi <- directional_rvonmises(n, mu = mu, kappa = 10)
  }

  data.frame(theta = directional_wrap(theta), phi = directional_wrap(phi), scenario = scenario)
}
