#' Experimental 3D circular topography
#'
#' Displays a circular-linear conditional density on a cylinder. The function is
#' experimental and is intended as a geometric companion to
#' [plot_circular_topography()], not as a replacement for the 2D display.
#'
#' @param theta Angles in radians.
#' @param x Real-valued response.
#' @param radius Radius of the cylinder.
#' @param conditional If `TRUE`, rows are normalized to estimate `f(x | theta)`.
#' @param ... Additional arguments passed to [circular_topography_data()].
#'
#' @return A `plotly` htmlwidget.
#' @export
#' @family cylindrical dependence plots
#'
#' @examplesIf requireNamespace("plotly", quietly = TRUE)
#' dat <- simulate_cylindrical(n = 120, seed = 1)
#' plot_circular_topography_3d(dat$theta, dat$x, n_theta = 32, n_x = 40)
plot_circular_topography_3d <- function(
  theta,
  x,
  radius = 1,
  conditional = TRUE,
  ...
) {
  directional_require_plotly()
  radius <- directional_positive_scalar(radius, "radius")
  topo <- circular_topography_data(theta, x, conditional = conditional, ...)
  directional_topography_columns(topo, c("theta", "x", "density"))

  theta_grid <- sort(unique(topo$theta))
  x_grid <- sort(unique(topo$x))
  density <- matrix(topo$density, nrow = length(theta_grid), ncol = length(x_grid))

  theta_matrix <- matrix(theta_grid, nrow = length(theta_grid), ncol = length(x_grid))
  x_matrix <- matrix(x_grid, nrow = length(theta_grid), ncol = length(x_grid), byrow = TRUE)
  surface_x <- radius * cos(theta_matrix)
  surface_y <- radius * sin(theta_matrix)

  plotly::plot_ly(
    x = surface_x,
    y = surface_y,
    z = x_matrix,
    surfacecolor = density,
    type = "surface",
    colorscale = "Viridis",
    showscale = TRUE
  ) |>
    plotly::layout(
      scene = list(
        xaxis = list(title = "cos(theta)"),
        yaxis = list(title = "sin(theta)"),
        zaxis = list(title = "x")
      )
    )
}

#' Experimental 3D toroidal topography
#'
#' Displays a circular-circular density on a torus. Colour represents the
#' estimated density and, by default, a small radial displacement also highlights
#' high-density regions. The function is experimental and is intended as a
#' geometric companion to [plot_toroidal_topography()].
#'
#' @param theta First angle in radians.
#' @param phi Second angle in radians.
#' @param major_radius Major torus radius.
#' @param minor_radius Minor torus radius.
#' @param density_scale Non-negative radial displacement applied after scaling
#'   density to `[0, 1]`. Use `0` for colour-only density encoding.
#' @param conditional If `TRUE`, rows are normalized to estimate `f(phi | theta)`.
#' @param ... Additional arguments passed to [toroidal_topography_data()].
#'
#' @return A `plotly` htmlwidget.
#' @export
#' @family toroidal dependence plots
#'
#' @examplesIf requireNamespace("plotly", quietly = TRUE)
#' dat <- simulate_toroidal(n = 120, seed = 1)
#' plot_toroidal_topography_3d(dat$theta, dat$phi, n_theta = 32, n_phi = 32)
plot_toroidal_topography_3d <- function(
  theta,
  phi,
  major_radius = 1,
  minor_radius = 0.35,
  density_scale = 0.15,
  conditional = TRUE,
  ...
) {
  directional_require_plotly()
  major_radius <- directional_positive_scalar(major_radius, "major_radius")
  minor_radius <- directional_positive_scalar(minor_radius, "minor_radius")
  density_scale <- directional_nonnegative_scalar(density_scale, "density_scale")
  topo <- toroidal_topography_data(theta, phi, conditional = conditional, ...)
  directional_topography_columns(topo, c("theta", "phi", "density"))

  theta_grid <- sort(unique(topo$theta))
  phi_grid <- sort(unique(topo$phi))
  density <- matrix(topo$density, nrow = length(theta_grid), ncol = length(phi_grid))
  density_scaled <- density
  max_density <- max(density_scaled, na.rm = TRUE)
  if (is.finite(max_density) && max_density > 0) {
    density_scaled <- density_scaled / max_density
  } else {
    density_scaled[] <- 0
  }

  theta_matrix <- matrix(theta_grid, nrow = length(theta_grid), ncol = length(phi_grid))
  phi_matrix <- matrix(phi_grid, nrow = length(theta_grid), ncol = length(phi_grid), byrow = TRUE)
  local_radius <- minor_radius + density_scale * density_scaled
  ring_radius <- major_radius + local_radius * cos(phi_matrix)
  surface_x <- ring_radius * cos(theta_matrix)
  surface_y <- ring_radius * sin(theta_matrix)
  surface_z <- local_radius * sin(phi_matrix)

  plotly::plot_ly(
    x = surface_x,
    y = surface_y,
    z = surface_z,
    surfacecolor = density,
    type = "surface",
    colorscale = "Viridis",
    showscale = TRUE
  ) |>
    plotly::layout(
      scene = list(
        xaxis = list(title = "x"),
        yaxis = list(title = "y"),
        zaxis = list(title = "z")
      )
    )
}

directional_require_plotly <- function() {
  if (!requireNamespace("plotly", quietly = TRUE)) {
    rlang::abort("Package `plotly` is required for experimental 3D directional displays.")
  }
  invisible(TRUE)
}

directional_topography_columns <- function(data, columns) {
  missing <- setdiff(columns, names(data))
  if (length(missing)) {
    rlang::abort(paste0("Topography data is missing columns: ", paste(missing, collapse = ", ")))
  }
  invisible(TRUE)
}

directional_nonnegative_scalar <- function(value, name) {
  value <- directional_numeric(value, name)
  if (length(value) != 1L || is.na(value) || !is.finite(value) || value < 0) {
    rlang::abort(paste0("`", name, "` must be a non-negative finite scalar."))
  }
  value
}
