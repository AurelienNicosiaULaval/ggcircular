#' Estimate a density on the torus
#'
#' Estimates a joint or conditional kernel density for circular-circular data on
#' `S1 x S1`. Both components use von Mises weights.
#'
#' @param theta First angle in radians.
#' @param phi Second angle in radians.
#' @param n_theta Number of theta grid points.
#' @param n_phi Number of phi grid points.
#' @param kappa_theta Kernel concentration for `theta`.
#' @param kappa_phi Kernel concentration for `phi`.
#' @param conditional If `TRUE`, rows are normalized to estimate `f(phi | theta)`.
#'
#' @return A list with grids, a density matrix, a long data frame and smoothing
#'   metadata.
#' @export
#' @family toroidal dependence helpers
#'
#' @examples
#' dat <- simulate_toroidal(n = 80, seed = 1)
#' est <- estimate_toroidal_density(dat$theta, dat$phi, n_theta = 24, n_phi = 24)
#' str(est$data)
estimate_toroidal_density <- function(
  theta,
  phi,
  n_theta = 181,
  n_phi = 181,
  kappa_theta = 20,
  kappa_phi = 20,
  conditional = FALSE
) {
  theta <- directional_wrap(directional_numeric(theta, "theta"))
  phi <- directional_wrap(directional_numeric(phi, "phi"))
  directional_check_pair(theta, phi, "theta", "phi")
  n_theta <- directional_count(n_theta, "n_theta", minimum = 2L)
  n_phi <- directional_count(n_phi, "n_phi", minimum = 2L)
  kappa_theta <- directional_positive_scalar(kappa_theta, "kappa_theta")
  kappa_phi <- directional_positive_scalar(kappa_phi, "kappa_phi")

  theta_grid <- directional_angle_grid(n_theta)
  phi_grid <- directional_angle_grid(n_phi)

  theta_weights <- outer(
    theta_grid,
    theta,
    function(grid_value, observed_value) {
      stable_vm_weight(directional_signed_difference(grid_value, observed_value), kappa_theta)
    }
  )
  phi_weights <- outer(
    phi_grid,
    phi,
    function(grid_value, observed_value) {
      stable_vm_weight(directional_signed_difference(grid_value, observed_value), kappa_phi)
    }
  )

  dens <- theta_weights %*% t(phi_weights) / length(theta)

  if (isTRUE(conditional)) {
    dphi <- mean(diff(phi_grid))
    row_integral <- rowSums(dens) * dphi
    row_integral[row_integral <= 0 | !is.finite(row_integral)] <- 1
    dens <- dens / row_integral
  }

  df <- expand.grid(theta = theta_grid, phi = phi_grid)
  df$density <- as.vector(dens)

  list(
    theta_grid = theta_grid,
    phi_grid = phi_grid,
    density = dens,
    data = df,
    kappa_theta = kappa_theta,
    kappa_phi = kappa_phi,
    conditional = isTRUE(conditional)
  )
}

#' Compute toroidal topography data
#'
#' @param theta First angle in radians.
#' @param phi Second angle in radians.
#' @param conditional If `TRUE`, rows are normalized to estimate `f(phi | theta)`.
#' @param ... Additional arguments passed to [estimate_toroidal_density()].
#'
#' @return A data frame with columns `theta`, `phi` and `density`.
#' @export
#' @family toroidal dependence helpers
#'
#' @examples
#' dat <- simulate_toroidal(n = 80, seed = 1)
#' toroidal_topography_data(dat$theta, dat$phi, n_theta = 24, n_phi = 24)
toroidal_topography_data <- function(theta, phi, conditional = FALSE, ...) {
  estimate_toroidal_density(theta, phi, conditional = conditional, ...)$data
}

#' Compute toroidal flow data
#'
#' Discretizes two angular variables into sectors and estimates joint or
#' conditional mass flows between sectors.
#'
#' @param theta First angle in radians.
#' @param phi Second angle in radians.
#' @param n_sectors Number of sectors for both angles.
#' @param min_mass Minimum mass to retain.
#' @param mass_type Either `"joint"` for joint masses or `"conditional"` for
#'   masses normalized within each `theta` sector.
#'
#' @return A data frame with sector identifiers, endpoints and mass values.
#' @export
#' @family toroidal dependence helpers
#'
#' @examples
#' dat <- simulate_toroidal(n = 80, seed = 1)
#' toroidal_flow_data(dat$theta, dat$phi, n_sectors = 12)
toroidal_flow_data <- function(
  theta,
  phi,
  n_sectors = 32,
  min_mass = 0.002,
  mass_type = c("joint", "conditional")
) {
  mass_type <- match.arg(mass_type)
  theta <- directional_wrap(directional_numeric(theta, "theta"))
  phi <- directional_wrap(directional_numeric(phi, "phi"))
  directional_check_pair(theta, phi, "theta", "phi")
  n_sectors <- directional_count(n_sectors, "n_sectors", minimum = 1L)
  min_mass <- directional_probability_scalar(min_mass, "min_mass")

  sector_edges <- seq(0, 2 * pi, length.out = n_sectors + 1L)
  theta_id <- cut(theta, breaks = sector_edges, include.lowest = TRUE, labels = FALSE)
  phi_id <- cut(phi, breaks = sector_edges, include.lowest = TRUE, labels = FALSE)

  tab <- table(theta_id, phi_id)
  theta_total <- rowSums(tab)
  flows <- as.data.frame(tab)
  names(flows) <- c("theta_sector", "phi_sector", "count")
  flows <- flows[flows$count > 0, , drop = FALSE]
  flows$joint_mass <- flows$count / sum(flows$count)
  flows$conditional_mass <- flows$count / theta_total[as.character(flows$theta_sector)]
  flows$mass <- if (mass_type == "conditional") flows$conditional_mass else flows$joint_mass
  flows <- flows[flows$mass >= min_mass, , drop = FALSE]

  flows$theta_sector <- as.integer(as.character(flows$theta_sector))
  flows$phi_sector <- as.integer(as.character(flows$phi_sector))

  centers <- sector_edges[-length(sector_edges)] + diff(sector_edges) / 2
  flows$theta_center <- centers[flows$theta_sector]
  flows$phi_center <- centers[flows$phi_sector]
  flows$theta_plot <- directional_signed_angle(flows$theta_center)
  flows$phi_plot <- directional_signed_angle(flows$phi_center)
  flows$source_y <- -pi
  flows$target_y <- flows$phi_plot
  flows$x0 <- cos(flows$theta_center)
  flows$y0 <- sin(flows$theta_center)
  flows$x1 <- 0.58 * cos(flows$phi_center)
  flows$y1 <- 0.58 * sin(flows$phi_center)
  flows <- flows[order(flows$mass, decreasing = TRUE), , drop = FALSE]
  row.names(flows) <- NULL
  flows
}

#' Compute a conditional toroidal ridge
#'
#' Extracts the modal `phi` value along a grid of conditioning angles and
#' attaches the local circular concentration.
#'
#' @param theta First angle in radians.
#' @param phi Second angle in radians.
#' @param n_theta Number of theta grid points.
#' @param n_phi Number of phi grid points.
#' @param kappa_theta Kernel concentration for `theta`.
#' @param kappa_phi Kernel concentration for `phi`.
#'
#' @return A data frame with columns `theta`, `phi`, `rho` and `ridge_group`.
#' @export
#' @family toroidal dependence helpers
#'
#' @examples
#' dat <- simulate_toroidal(n = 80, scenario = "diagonal", seed = 1)
#' toroidal_ridge_data(dat$theta, dat$phi, n_theta = 24, n_phi = 24)
toroidal_ridge_data <- function(
  theta,
  phi,
  n_theta = 181,
  n_phi = 181,
  kappa_theta = 20,
  kappa_phi = 20
) {
  est <- estimate_toroidal_density(
    theta,
    phi,
    n_theta = n_theta,
    n_phi = n_phi,
    kappa_theta = kappa_theta,
    kappa_phi = kappa_phi,
    conditional = TRUE
  )

  ridge_idx <- max.col(est$density, ties.method = "first")
  ridge_phi <- est$phi_grid[ridge_idx]
  moment <- local_circ_moment(theta, phi, grid = est$theta_grid, kappa = kappa_theta)
  jump <- c(FALSE, abs(diff(ridge_phi)) > pi / 2)

  data.frame(
    theta = est$theta_grid,
    phi = ridge_phi,
    rho = moment$rho,
    ridge_group = cumsum(jump) + 1L
  )
}
