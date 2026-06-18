#' Local circular moment
#'
#' Computes a kernel-weighted local circular moment of `phi` conditional on
#' `theta`.
#'
#' @param theta Conditioning angles in radians.
#' @param phi Target angles in radians.
#' @param grid Optional angular grid. If `NULL`, a default grid is used.
#' @param kappa Circular concentration for local weighting.
#'
#' @return A data frame with local real and imaginary components, mean
#'   direction `mu`, and local concentration `rho`.
#' @export
#' @family directional dependence indicators
#'
#' @examples
#' dat <- simulate_toroidal(n = 80, scenario = "diagonal", seed = 1)
#' local_circ_moment(dat$theta, dat$phi, grid = seq(0, 2 * pi, length.out = 12))
local_circ_moment <- function(theta, phi, grid = NULL, kappa = 20) {
  theta <- directional_wrap(directional_numeric(theta, "theta"))
  phi <- directional_wrap(directional_numeric(phi, "phi"))
  directional_check_pair(theta, phi, "theta", "phi")
  kappa <- directional_positive_scalar(kappa, "kappa")
  if (is.null(grid)) {
    grid <- directional_angle_grid(181)
  } else {
    grid <- directional_wrap(directional_numeric(grid, "grid"))
  }

  re <- im <- mu <- rho <- numeric(length(grid))

  for (j in seq_along(grid)) {
    w <- stable_vm_weight(directional_signed_difference(grid[j], theta), kappa)
    z <- sum(w * exp(1i * phi)) / sum(w)
    re[j] <- Re(z)
    im[j] <- Im(z)
    mu[j] <- directional_wrap(Arg(z))
    rho[j] <- min(1, max(0, Mod(z)))
  }

  data.frame(theta = grid, re = re, im = im, mu = mu, rho = rho)
}

#' Alignment index for two angular variables
#'
#' Computes `|mean(exp(i * (phi - theta)))|`, a scalar summary of circular
#' alignment between two angular variables.
#'
#' @param theta First angle in radians.
#' @param phi Second angle in radians.
#'
#' @return A numeric scalar between 0 and 1.
#' @export
#' @family directional dependence indicators
#'
#' @examples
#' dat <- simulate_toroidal(n = 80, scenario = "diagonal", seed = 1)
#' alignment_index(dat$theta, dat$phi)
alignment_index <- function(theta, phi) {
  theta <- directional_wrap(directional_numeric(theta, "theta"))
  phi <- directional_wrap(directional_numeric(phi, "phi"))
  directional_check_pair(theta, phi, "theta", "phi")
  min(1, max(0, Mod(mean(exp(1i * directional_signed_difference(phi, theta))))))
}

#' Conditional variation index
#'
#' Computes a simple squared variation summary for a matrix of conditional
#' densities across conditioning-grid rows.
#'
#' @param density_matrix Matrix with rows representing conditioning-grid values
#'   and columns representing conditional density values.
#'
#' @return A non-negative numeric scalar.
#' @export
#' @family directional dependence indicators
#'
#' @examples
#' dat <- simulate_toroidal(n = 80, seed = 1)
#' est <- estimate_toroidal_density(dat$theta, dat$phi, n_theta = 12, n_phi = 12, conditional = TRUE)
#' conditional_variation_index(est$density)
conditional_variation_index <- function(density_matrix) {
  if (!is.matrix(density_matrix)) {
    rlang::abort("`density_matrix` must be a matrix.")
  }
  avg <- colMeans(density_matrix)
  mean(rowSums((density_matrix - matrix(avg, nrow = nrow(density_matrix), ncol = ncol(density_matrix), byrow = TRUE))^2))
}
