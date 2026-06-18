#' Estimate a density on the cylinder
#'
#' Estimates a joint or conditional kernel density for circular-linear data on
#' `S1 x R`. The circular component uses von Mises weights and the linear
#' component uses a Gaussian kernel.
#'
#' @param theta Angles in radians.
#' @param x Real-valued response.
#' @param n_theta Number of angular grid points.
#' @param n_x Number of linear grid points.
#' @param kappa Circular concentration for the conditioning kernel.
#' @param h Linear bandwidth. If `NULL`, a rule-of-thumb bandwidth is used.
#' @param x_grid Optional grid for the linear response.
#' @param conditional If `TRUE`, rows are normalized to estimate `f(x | theta)`.
#'
#' @return A list with grids, a density matrix, a long data frame and smoothing
#'   metadata.
#' @export
#' @family cylindrical dependence helpers
#'
#' @examples
#' dat <- simulate_cylindrical(n = 80, seed = 1)
#' est <- estimate_cyl_density(dat$theta, dat$x, n_theta = 24, n_x = 30)
#' str(est$data)
estimate_cyl_density <- function(
  theta,
  x,
  n_theta = 181,
  n_x = 200,
  kappa = 20,
  h = NULL,
  x_grid = NULL,
  conditional = TRUE
) {
  theta <- directional_wrap(directional_numeric(theta, "theta"))
  x <- directional_numeric(x, "x")
  directional_check_pair(theta, x, "theta", "x")
  n_theta <- directional_count(n_theta, "n_theta", minimum = 2L)
  n_x <- directional_count(n_x, "n_x", minimum = 2L)
  kappa <- directional_positive_scalar(kappa, "kappa")
  if (!is.null(h)) {
    h <- directional_positive_scalar(h, "h")
  } else {
    h <- default_linear_bandwidth(x)
  }

  theta_grid <- directional_angle_grid(n_theta)
  if (is.null(x_grid)) {
    x_grid <- directional_safe_linear_grid(x, n_x)
  } else {
    x_grid <- directional_numeric(x_grid, "x_grid")
    if (length(x_grid) < 2L) {
      rlang::abort("`x_grid` must contain at least two values.")
    }
  }

  angular_weights <- outer(
    theta_grid,
    theta,
    function(grid_value, observed_value) {
      stable_vm_weight(directional_signed_difference(grid_value, observed_value), kappa)
    }
  )
  linear_weights <- outer(
    x_grid,
    x,
    function(grid_value, observed_value) {
      gaussian_kernel(grid_value - observed_value, h)
    }
  )
  dens <- angular_weights %*% t(linear_weights) / length(theta)

  if (isTRUE(conditional)) {
    dx <- mean(diff(x_grid))
    row_integral <- rowSums(dens) * dx
    row_integral[row_integral <= 0 | !is.finite(row_integral)] <- 1
    dens <- dens / row_integral
  }

  df <- expand.grid(theta = theta_grid, x = x_grid)
  df$density <- as.vector(dens)

  list(
    theta_grid = theta_grid,
    x_grid = x_grid,
    density = dens,
    data = df,
    kappa = kappa,
    h = h,
    conditional = isTRUE(conditional)
  )
}

#' Compute phase loom data
#'
#' Discretizes circular-linear observations into angular sectors and linear bins
#' and returns binned mass flows for phase loom displays.
#'
#' @param theta Angles in radians.
#' @param x Real-valued response.
#' @param n_sectors Number of angular sectors.
#' @param n_x_bins Number of linear bins.
#' @param min_mass Minimum mass to retain.
#' @param max_flows Maximum number of flows to retain. Use `NULL` to keep all.
#' @param mass_type Either `"joint"` for joint masses or `"conditional"` for
#'   masses normalized within each angular sector.
#'
#' @return A data frame with sector identifiers, endpoints and mass values.
#' @export
#' @family cylindrical dependence helpers
#'
#' @examples
#' dat <- simulate_cylindrical(n = 80, seed = 1)
#' phase_loom_data(dat$theta, dat$x, n_sectors = 12, n_x_bins = 8)
phase_loom_data <- function(
  theta,
  x,
  n_sectors = 48,
  n_x_bins = 24,
  min_mass = 0.002,
  max_flows = 180,
  mass_type = c("joint", "conditional")
) {
  mass_type <- match.arg(mass_type)
  theta <- directional_wrap(directional_numeric(theta, "theta"))
  x <- directional_numeric(x, "x")
  directional_check_pair(theta, x, "theta", "x")
  n_sectors <- directional_count(n_sectors, "n_sectors", minimum = 1L)
  n_x_bins <- directional_count(n_x_bins, "n_x_bins", minimum = 1L)
  min_mass <- directional_probability_scalar(min_mass, "min_mass")
  if (!is.null(max_flows)) {
    max_flows <- directional_count(max_flows, "max_flows", minimum = 1L)
  }

  sector_edges <- seq(0, 2 * pi, length.out = n_sectors + 1L)
  sector_id <- cut(theta, breaks = sector_edges, include.lowest = TRUE, labels = FALSE)
  x_breaks <- directional_safe_breaks(x, n_x_bins)
  x_id <- cut(x, breaks = x_breaks, include.lowest = TRUE, labels = FALSE)

  tab <- table(sector_id, x_id)
  sector_total <- rowSums(tab)
  mass <- as.data.frame(tab)
  names(mass) <- c("sector", "x_bin", "count")
  mass <- mass[mass$count > 0, , drop = FALSE]
  mass$joint_mass <- mass$count / sum(mass$count)
  mass$conditional_mass <- mass$count / sector_total[as.character(mass$sector)]
  mass$mass <- if (mass_type == "conditional") mass$conditional_mass else mass$joint_mass
  mass <- mass[mass$mass >= min_mass, , drop = FALSE]

  mass$sector <- as.integer(as.character(mass$sector))
  mass$x_bin <- as.integer(as.character(mass$x_bin))

  sector_centers <- sector_edges[-length(sector_edges)] + diff(sector_edges) / 2
  x_centers <- x_breaks[-length(x_breaks)] + diff(x_breaks) / 2
  x_span <- diff(range(x_centers))
  if (!is.finite(x_span) || x_span <= 0) {
    x_scaled <- rep(0, length(x_centers))
  } else {
    x_scaled <- -0.85 + 1.7 * (x_centers - min(x_centers)) / x_span
  }

  mass$theta_center <- sector_centers[mass$sector]
  mass$x0 <- cos(mass$theta_center)
  mass$y0 <- sin(mass$theta_center)
  mass$x1 <- x_scaled[mass$x_bin]
  mass$y1 <- 0
  mass$x_mid <- x_centers[mass$x_bin]
  mass <- mass[order(mass$mass, decreasing = TRUE), , drop = FALSE]
  if (!is.null(max_flows) && nrow(mass) > max_flows) {
    mass <- mass[seq_len(max_flows), , drop = FALSE]
  }
  row.names(mass) <- NULL
  mass
}

#' Compute circular topography data
#'
#' @param theta Angles in radians.
#' @param x Real-valued response.
#' @param conditional If `TRUE`, rows are normalized to estimate `f(x | theta)`.
#' @param ... Additional arguments passed to [estimate_cyl_density()].
#'
#' @return A data frame with columns `theta`, `x` and `density`.
#' @export
#' @family cylindrical dependence helpers
#'
#' @examples
#' dat <- simulate_cylindrical(n = 80, seed = 1)
#' circular_topography_data(dat$theta, dat$x, n_theta = 24, n_x = 30)
circular_topography_data <- function(theta, x, conditional = TRUE, ...) {
  estimate_cyl_density(theta, x, conditional = conditional, ...)$data
}

#' Compute statistical orbit data
#'
#' Computes local conditional means, local standard deviations and local
#' skewness over an angular grid.
#'
#' @param theta Angles in radians.
#' @param x Real-valued response.
#' @param n_theta Number of angular grid points.
#' @param kappa Circular concentration for local weighting.
#'
#' @return A data frame with `theta`, `mu`, `lower`, `upper` and `skew`.
#' @export
#' @family cylindrical dependence helpers
#'
#' @examples
#' dat <- simulate_cylindrical(n = 80, seed = 1)
#' stat_orbit_data(dat$theta, dat$x, n_theta = 24)
stat_orbit_data <- function(theta, x, n_theta = 181, kappa = 20) {
  theta <- directional_wrap(directional_numeric(theta, "theta"))
  x <- directional_numeric(x, "x")
  directional_check_pair(theta, x, "theta", "x")
  n_theta <- directional_count(n_theta, "n_theta", minimum = 2L)
  kappa <- directional_positive_scalar(kappa, "kappa")

  grid <- c(directional_angle_grid(n_theta), 2 * pi)
  mu <- sig <- skew <- numeric(length(grid))

  for (j in seq_along(grid)) {
    w <- stable_vm_weight(directional_signed_difference(grid[j], theta), kappa)
    w <- w / sum(w)
    mu[j] <- sum(w * x)
    sig[j] <- sqrt(sum(w * (x - mu[j])^2))
    skew[j] <- if (sig[j] > 0) {
      sum(w * ((x - mu[j]) / sig[j])^3)
    } else {
      0
    }
  }

  data.frame(theta = grid, mu = mu, lower = mu - sig, upper = mu + sig, skew = skew)
}
