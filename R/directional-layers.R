StatPhaseLoom <- ggplot2::ggproto(
  "StatPhaseLoom",
  ggplot2::Stat,
  required_aes = c("x", "y"),
  compute_group = function(
    data,
    scales,
    n_sectors = 48,
    n_x_bins = 24,
    min_mass = 0.002,
    max_flows = 180,
    mass_type = c("joint", "conditional")
  ) {
    mass_type <- match.arg(mass_type)
    out <- phase_loom_data(
      data$x,
      data$y,
      n_sectors = n_sectors,
      n_x_bins = n_x_bins,
      min_mass = min_mass,
      max_flows = max_flows,
      mass_type = mass_type
    )
    data.frame(
      x = out$x0,
      y = out$y0,
      xend = out$x1,
      yend = out$y1,
      mass = out$mass,
      level = out$x_mid
    )
  }
)

#' Add a phase loom layer
#'
#' Adds mass-flow curves for circular-linear data. Use this layer with
#' `ggplot2::ggplot(data, ggplot2::aes(x = theta, y = response))`.
#'
#' @param mapping,data,position,show.legend,inherit.aes Standard ggplot2 layer
#'   arguments.
#' @param n_sectors Number of angular sectors.
#' @param n_x_bins Number of bins for the linear response.
#' @param min_mass Minimum mass to draw.
#' @param max_flows Maximum number of flows to draw. Use `NULL` to draw all.
#' @param mass_type Either `"joint"` or `"conditional"`.
#' @param curvature Curvature passed to `ggplot2::geom_curve()`.
#' @param ... Additional arguments passed to the geom.
#'
#' @return A ggplot2 layer.
#' @export
#' @family cylindrical dependence layers
#'
#' @examples
#' dat <- simulate_cylindrical(n = 80, seed = 1)
#' ggplot2::ggplot(dat, ggplot2::aes(x = theta, y = x)) +
#'   geom_phase_loom(n_sectors = 12, n_x_bins = 8, min_mass = 0)
geom_phase_loom <- function(
  mapping = NULL,
  data = NULL,
  position = "identity",
  n_sectors = 48,
  n_x_bins = 24,
  min_mass = 0.002,
  max_flows = 180,
  mass_type = c("joint", "conditional"),
  curvature = 0.24,
  ...,
  show.legend = NA,
  inherit.aes = TRUE
) {
  mass_type <- match.arg(mass_type)
  default_mapping <- ggplot2::aes(
    xend = ggplot2::after_stat(xend),
    yend = ggplot2::after_stat(yend),
    linewidth = ggplot2::after_stat(mass),
    alpha = ggplot2::after_stat(mass),
    colour = ggplot2::after_stat(level)
  )
  ggplot2::layer(
    stat = StatPhaseLoom,
    geom = "curve",
    mapping = combine_aes(default_mapping, mapping),
    data = data,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      n_sectors = n_sectors,
      n_x_bins = n_x_bins,
      min_mass = min_mass,
      max_flows = max_flows,
      mass_type = mass_type,
      curvature = curvature,
      ...
    )
  )
}

StatCircularTopography <- ggplot2::ggproto(
  "StatCircularTopography",
  ggplot2::Stat,
  required_aes = c("x", "y"),
  compute_group = function(
    data,
    scales,
    n_theta = 181,
    n_x = 200,
    kappa = 20,
    h = NULL,
    conditional = TRUE
  ) {
    est <- estimate_cyl_density(
      data$x,
      data$y,
      n_theta = n_theta,
      n_x = n_x,
      kappa = kappa,
      h = h,
      conditional = conditional
    )
    data.frame(
      x = est$data$theta,
      y = est$data$x,
      theta = est$data$theta,
      value = est$data$x,
      density = est$data$density
    )
  }
)

#' Add a circular topography stat layer
#'
#' Estimates a circular-linear density and returns grid values for topographic
#' displays. Use with `aes(x = theta, y = response)`.
#'
#' @param mapping,data,geom,position,show.legend,inherit.aes Standard ggplot2
#'   layer arguments.
#' @param n_theta Number of angular grid points.
#' @param n_x Number of linear grid points.
#' @param kappa Circular concentration for the conditioning kernel.
#' @param h Linear bandwidth. If `NULL`, a rule-of-thumb bandwidth is used.
#' @param conditional If `TRUE`, estimate `f(y | x_angle)`.
#' @param ... Additional arguments passed to the geom.
#'
#' @return A ggplot2 layer.
#' @export
#' @family cylindrical dependence layers
#'
#' @examples
#' dat <- simulate_cylindrical(n = 80, seed = 1)
#' ggplot2::ggplot(dat, ggplot2::aes(x = theta, y = x)) +
#'   stat_circular_topography(n_theta = 24, n_x = 30)
stat_circular_topography <- function(
  mapping = NULL,
  data = NULL,
  geom = "tile",
  position = "identity",
  n_theta = 181,
  n_x = 200,
  kappa = 20,
  h = NULL,
  conditional = TRUE,
  ...,
  show.legend = NA,
  inherit.aes = TRUE
) {
  default_mapping <- if (identical(geom, "tile") || identical(geom, "raster")) {
    ggplot2::aes(fill = ggplot2::after_stat(density))
  } else {
    ggplot2::aes()
  }
  ggplot2::layer(
    stat = StatCircularTopography,
    geom = geom,
    mapping = combine_aes(default_mapping, mapping),
    data = data,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      n_theta = n_theta,
      n_x = n_x,
      kappa = kappa,
      h = h,
      conditional = conditional,
      ...
    )
  )
}

StatStatisticalOrbit <- ggplot2::ggproto(
  "StatStatisticalOrbit",
  ggplot2::Stat,
  required_aes = c("x", "y"),
  compute_group = function(data, scales, n_theta = 181, kappa = 20) {
    out <- stat_orbit_data(data$x, data$y, n_theta = n_theta, kappa = kappa)
    data.frame(
      x = out$theta,
      y = out$mu,
      ymin = out$lower,
      ymax = out$upper,
      theta = out$theta,
      mu = out$mu,
      sigma_lower = out$lower,
      sigma_upper = out$upper,
      skew = out$skew
    )
  }
)

#' Add a statistical orbit line
#'
#' @param mapping,data,geom,position,show.legend,inherit.aes Standard ggplot2
#'   layer arguments.
#' @param n_theta Number of angular grid points.
#' @param kappa Circular concentration for local weighting.
#' @param ... Additional arguments passed to the geom.
#'
#' @return A ggplot2 layer.
#' @export
#' @family cylindrical dependence layers
#'
#' @examples
#' dat <- simulate_cylindrical(n = 80, seed = 1)
#' ggplot2::ggplot(dat, ggplot2::aes(x = theta, y = x)) +
#'   stat_statistical_orbit(n_theta = 24)
stat_statistical_orbit <- function(
  mapping = NULL,
  data = NULL,
  geom = "line",
  position = "identity",
  n_theta = 181,
  kappa = 20,
  ...,
  show.legend = NA,
  inherit.aes = TRUE
) {
  ggplot2::layer(
    stat = StatStatisticalOrbit,
    geom = geom,
    mapping = mapping,
    data = data,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(n_theta = n_theta, kappa = kappa, ...)
  )
}

#' Add a statistical orbit ribbon
#'
#' @inheritParams stat_statistical_orbit
#'
#' @return A ggplot2 layer.
#' @export
#' @family cylindrical dependence layers
#'
#' @examples
#' dat <- simulate_cylindrical(n = 80, seed = 1)
#' ggplot2::ggplot(dat, ggplot2::aes(x = theta, y = x)) +
#'   stat_statistical_orbit_ribbon(n_theta = 24, alpha = 0.2) +
#'   stat_statistical_orbit(n_theta = 24)
stat_statistical_orbit_ribbon <- function(
  mapping = NULL,
  data = NULL,
  geom = "ribbon",
  position = "identity",
  n_theta = 181,
  kappa = 20,
  ...,
  show.legend = NA,
  inherit.aes = TRUE
) {
  default_mapping <- ggplot2::aes(
    ymin = ggplot2::after_stat(ymin),
    ymax = ggplot2::after_stat(ymax)
  )
  ggplot2::layer(
    stat = StatStatisticalOrbit,
    geom = geom,
    mapping = combine_aes(default_mapping, mapping),
    data = data,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(n_theta = n_theta, kappa = kappa, ...)
  )
}

StatToroidalTopography <- ggplot2::ggproto(
  "StatToroidalTopography",
  ggplot2::Stat,
  required_aes = c("x", "y"),
  compute_group = function(
    data,
    scales,
    n_theta = 181,
    n_phi = 181,
    kappa_theta = 20,
    kappa_phi = 20,
    conditional = FALSE,
    signed = TRUE
  ) {
    est <- estimate_toroidal_density(
      data$x,
      data$y,
      n_theta = n_theta,
      n_phi = n_phi,
      kappa_theta = kappa_theta,
      kappa_phi = kappa_phi,
      conditional = conditional
    )
    x <- if (isTRUE(signed)) directional_signed_angle(est$data$theta) else est$data$theta
    y <- if (isTRUE(signed)) directional_signed_angle(est$data$phi) else est$data$phi
    data.frame(
      x = x,
      y = y,
      theta = est$data$theta,
      phi = est$data$phi,
      density = est$data$density
    )
  }
)

#' Add a toroidal topography stat layer
#'
#' Estimates a circular-circular density and returns grid values for topographic
#' displays. Use with `aes(x = theta, y = phi)`.
#'
#' @param mapping,data,geom,position,show.legend,inherit.aes Standard ggplot2
#'   layer arguments.
#' @param n_theta Number of theta grid points.
#' @param n_phi Number of phi grid points.
#' @param kappa_theta Kernel concentration for `theta`.
#' @param kappa_phi Kernel concentration for `phi`.
#' @param conditional If `TRUE`, estimate `f(phi | theta)`.
#' @param signed If `TRUE`, plot angles in the signed interval.
#' @param ... Additional arguments passed to the geom.
#'
#' @return A ggplot2 layer.
#' @export
#' @family toroidal dependence layers
#'
#' @examples
#' dat <- simulate_toroidal(n = 80, seed = 1)
#' ggplot2::ggplot(dat, ggplot2::aes(x = theta, y = phi)) +
#'   stat_toroidal_topography(n_theta = 24, n_phi = 24)
stat_toroidal_topography <- function(
  mapping = NULL,
  data = NULL,
  geom = "tile",
  position = "identity",
  n_theta = 181,
  n_phi = 181,
  kappa_theta = 20,
  kappa_phi = 20,
  conditional = FALSE,
  signed = TRUE,
  ...,
  show.legend = NA,
  inherit.aes = TRUE
) {
  default_mapping <- if (identical(geom, "tile") || identical(geom, "raster")) {
    ggplot2::aes(fill = ggplot2::after_stat(density))
  } else {
    ggplot2::aes()
  }
  ggplot2::layer(
    stat = StatToroidalTopography,
    geom = geom,
    mapping = combine_aes(default_mapping, mapping),
    data = data,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      n_theta = n_theta,
      n_phi = n_phi,
      kappa_theta = kappa_theta,
      kappa_phi = kappa_phi,
      conditional = conditional,
      signed = signed,
      ...
    )
  )
}

StatToroidalFlow <- ggplot2::ggproto(
  "StatToroidalFlow",
  ggplot2::Stat,
  required_aes = c("x", "y"),
  compute_group = function(
    data,
    scales,
    n_sectors = 32,
    min_mass = 0.002,
    mass_type = c("joint", "conditional")
  ) {
    mass_type <- match.arg(mass_type)
    out <- toroidal_flow_data(
      data$x,
      data$y,
      n_sectors = n_sectors,
      min_mass = min_mass,
      mass_type = mass_type
    )
    data.frame(
      x = out$theta_plot,
      y = out$source_y,
      xend = out$theta_plot,
      yend = out$target_y,
      mass = out$mass,
      theta_sector = out$theta_center,
      phi_sector = out$phi_center
    )
  }
)

#' Add a toroidal flow layer
#'
#' Adds rectangular flow curves from `theta` sectors to `phi` sectors. Use with
#' `aes(x = theta, y = phi)`.
#'
#' @param mapping,data,position,show.legend,inherit.aes Standard ggplot2 layer
#'   arguments.
#' @param n_sectors Number of angular sectors for both variables.
#' @param min_mass Minimum mass to draw.
#' @param mass_type Either `"joint"` or `"conditional"`.
#' @param curvature Curvature passed to `ggplot2::geom_curve()`.
#' @param ... Additional arguments passed to the geom.
#'
#' @return A ggplot2 layer.
#' @export
#' @family toroidal dependence layers
#'
#' @examples
#' dat <- simulate_toroidal(n = 80, seed = 1)
#' ggplot2::ggplot(dat, ggplot2::aes(x = theta, y = phi)) +
#'   geom_toroidal_flow(n_sectors = 12, min_mass = 0)
geom_toroidal_flow <- function(
  mapping = NULL,
  data = NULL,
  position = "identity",
  n_sectors = 32,
  min_mass = 0.002,
  mass_type = c("joint", "conditional"),
  curvature = 0.28,
  ...,
  show.legend = NA,
  inherit.aes = TRUE
) {
  mass_type <- match.arg(mass_type)
  default_mapping <- ggplot2::aes(
    xend = ggplot2::after_stat(xend),
    yend = ggplot2::after_stat(yend),
    linewidth = ggplot2::after_stat(mass),
    alpha = ggplot2::after_stat(mass),
    colour = ggplot2::after_stat(theta_sector)
  )
  ggplot2::layer(
    stat = StatToroidalFlow,
    geom = "curve",
    mapping = combine_aes(default_mapping, mapping),
    data = data,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      n_sectors = n_sectors,
      min_mass = min_mass,
      mass_type = mass_type,
      curvature = curvature,
      ...
    )
  )
}

StatToroidalRidge <- ggplot2::ggproto(
  "StatToroidalRidge",
  ggplot2::Stat,
  required_aes = c("x", "y"),
  compute_group = function(
    data,
    scales,
    n_theta = 181,
    n_phi = 181,
    kappa_theta = 20,
    kappa_phi = 20,
    tie_tolerance = 0.01,
    signed = TRUE
  ) {
    out <- toroidal_ridge_data(
      data$x,
      data$y,
      n_theta = n_theta,
      n_phi = n_phi,
      kappa_theta = kappa_theta,
      kappa_phi = kappa_phi,
      tie_tolerance = tie_tolerance
    )
    x <- if (isTRUE(signed)) directional_signed_angle(out$theta) else out$theta
    y <- if (isTRUE(signed)) directional_signed_angle(out$phi) else out$phi
    out <- data.frame(
      x = x,
      y = y,
      theta = out$theta,
      phi = out$phi,
      rho = out$rho,
      n_local_modes = out$n_local_modes,
      secondary_mode_ratio = out$secondary_mode_ratio,
      ridge_ambiguous = out$ridge_ambiguous
    )
    out <- out[order(out$x), , drop = FALSE]
    jump <- c(FALSE, abs(diff(out$y)) > pi / 2)
    out$group <- cumsum(jump) + 1L
    out
  }
)

#' Add a conditional ridge stat layer on the torus
#'
#' Adds a conditional modal ridge for circular-circular data. Use with
#' `aes(x = theta, y = phi)`.
#'
#' @param mapping,data,geom,position,show.legend,inherit.aes Standard ggplot2
#'   layer arguments.
#' @param n_theta Number of theta grid points.
#' @param n_phi Number of phi grid points.
#' @param kappa_theta Kernel concentration for `theta`.
#' @param kappa_phi Kernel concentration for `phi`.
#' @param tie_tolerance Relative tolerance used to flag near-tied distinct
#'   local modes without changing the selected ridge.
#' @param signed If `TRUE`, plot angles in the signed interval.
#' @param ... Additional arguments passed to the geom.
#'
#' @return A ggplot2 layer.
#' @export
#' @family toroidal dependence layers
#'
#' @examples
#' dat <- simulate_toroidal(n = 80, scenario = "diagonal", seed = 1)
#' ggplot2::ggplot(dat, ggplot2::aes(x = theta, y = phi)) +
#'   stat_toroidal_ridge(n_theta = 24, n_phi = 24)
stat_toroidal_ridge <- function(
  mapping = NULL,
  data = NULL,
  geom = "path",
  position = "identity",
  n_theta = 181,
  n_phi = 181,
  kappa_theta = 20,
  kappa_phi = 20,
  tie_tolerance = 0.01,
  signed = TRUE,
  ...,
  show.legend = NA,
  inherit.aes = TRUE
) {
  default_mapping <- ggplot2::aes(
    colour = ggplot2::after_stat(rho),
    group = ggplot2::after_stat(group)
  )
  ggplot2::layer(
    stat = StatToroidalRidge,
    geom = geom,
    mapping = combine_aes(default_mapping, mapping),
    data = data,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      n_theta = n_theta,
      n_phi = n_phi,
      kappa_theta = kappa_theta,
      kappa_phi = kappa_phi,
      tie_tolerance = tie_tolerance,
      signed = signed,
      ...
    )
  )
}

#' Plot a phase loom
#'
#' @param theta Angles in radians.
#' @param x Real-valued response.
#' @param n_sectors Number of angular sectors.
#' @param n_x_bins Number of linear bins.
#' @param min_mass Minimum mass to retain.
#' @param max_flows Maximum number of flows to retain. Use `NULL` to keep all.
#' @param mass_type Either `"joint"` for joint masses or `"conditional"` for
#'   masses normalized within each angular sector.
#' @param palette Colour palette for response levels.
#' @param base_size Base font size.
#' @param legend_position Legend position.
#' @param show_legend If `FALSE`, hide legends.
#'
#' @return A ggplot object.
#' @export
#' @family cylindrical dependence plots
#'
#' @examples
#' dat <- simulate_cylindrical(n = 80, seed = 1)
#' plot_phase_loom(dat$theta, dat$x, n_sectors = 12, n_x_bins = 8)
plot_phase_loom <- function(
  theta,
  x,
  n_sectors = 48,
  n_x_bins = 24,
  min_mass = 0.002,
  max_flows = 180,
  mass_type = c("joint", "conditional"),
  palette = flow_palette(),
  base_size = 12,
  legend_position = "right",
  show_legend = TRUE
) {
  mass_type <- match.arg(mass_type)
  theta <- directional_wrap(directional_numeric(theta, "theta"))
  x <- directional_numeric(x, "x")
  directional_check_pair(theta, x, "theta", "x")
  data <- data.frame(theta = theta, x = x)
  circle <- data.frame(a = seq(0, 2 * pi, length.out = 721))
  circle$x <- cos(circle$a)
  circle$y <- sin(circle$a)
  mass_label <- if (mass_type == "conditional") {
    "conditional mass"
  } else {
    "joint mass"
  }

  ggplot2::ggplot(data, ggplot2::aes(x = theta, y = x)) +
    ggplot2::geom_segment(
      ggplot2::aes(x = -0.92, y = 0, xend = 0.92, yend = 0),
      inherit.aes = FALSE,
      linewidth = 0.35,
      colour = "#53606c"
    ) +
    ggplot2::geom_path(
      data = circle,
      ggplot2::aes(x, y),
      inherit.aes = FALSE,
      linewidth = 3.2,
      colour = "#1d6f8d",
      lineend = "round"
    ) +
    geom_phase_loom(
      n_sectors = n_sectors,
      n_x_bins = n_x_bins,
      min_mass = min_mass,
      max_flows = max_flows,
      mass_type = mass_type,
      lineend = "round"
    ) +
    ggplot2::scale_colour_gradientn(colours = palette, name = "x") +
    ggplot2::scale_linewidth_continuous(range = c(0.25, 3.2), name = mass_label) +
    ggplot2::scale_alpha_continuous(range = c(0.10, 0.85), guide = "none") +
    ggplot2::coord_equal() +
    theme_directional_void(
      base_size = base_size,
      legend_position = legend_setting(show_legend, legend_position)
    ) +
    ggplot2::labs(title = "Phase loom plot")
}

#' Plot circular topography
#'
#' @param theta Angles in radians.
#' @param x Real-valued response.
#' @param conditional If `TRUE`, rows are normalized to estimate `f(x | theta)`.
#' @param ... Additional arguments passed to [estimate_cyl_density()].
#' @param palette Colour palette for density.
#' @param base_size Base font size.
#' @param legend_position Legend position.
#' @param show_legend If `FALSE`, hide legends.
#'
#' @return A ggplot object.
#' @export
#' @family cylindrical dependence plots
#'
#' @examples
#' dat <- simulate_cylindrical(n = 80, seed = 1)
#' plot_circular_topography(dat$theta, dat$x, n_theta = 24, n_x = 30)
plot_circular_topography <- function(
  theta,
  x,
  conditional = TRUE,
  ...,
  palette = topography_palette(),
  base_size = 12,
  legend_position = "right",
  show_legend = TRUE
) {
  theta <- directional_wrap(directional_numeric(theta, "theta"))
  x <- directional_numeric(x, "x")
  directional_check_pair(theta, x, "theta", "x")
  data <- data.frame(theta = theta, x = x)
  contour_data <- circular_topography_data(theta, x, conditional = conditional, ...)
  fill_label <- if (isTRUE(conditional)) "f(x | theta)" else "f(theta, x)"
  label_radius <- polar_label_radius(x, expand = 0.14)
  angle_labels <- polar_angle_label_data(label_radius)

  ggplot2::ggplot(data, ggplot2::aes(x = theta, y = x)) +
    stat_circular_topography(conditional = conditional, ...) +
    ggplot2::geom_contour(
      data = contour_data,
      ggplot2::aes(x = theta, y = x, z = density),
      inherit.aes = FALSE,
      colour = "white",
      alpha = 0.45,
      linewidth = 0.25,
      bins = 9
    ) +
    ggplot2::geom_text(
      data = angle_labels,
      ggplot2::aes(x, y, label = angle_label),
      inherit.aes = FALSE,
      parse = TRUE,
      colour = "#4b5563",
      size = base_size * 0.32
    ) +
    coord_circular(clip = "off") +
    scale_x_circular_radians() +
    ggplot2::scale_fill_gradientn(colours = palette, name = fill_label) +
    theme_circular(base_size = base_size) +
    ggplot2::theme(legend.position = legend_setting(show_legend, legend_position)) +
    ggplot2::labs(x = "theta", y = "x", title = "Circular topographic map")
}

#' Plot a statistical orbit
#'
#' @param theta Angles in radians.
#' @param x Real-valued response.
#' @param n_theta Number of angular grid points.
#' @param kappa Circular concentration for local weighting.
#' @param base_size Base font size.
#'
#' @return A ggplot object.
#' @export
#' @family cylindrical dependence plots
#'
#' @examples
#' dat <- simulate_cylindrical(n = 80, seed = 1)
#' plot_stat_orbit(dat$theta, dat$x, n_theta = 24)
plot_stat_orbit <- function(theta, x, n_theta = 181, kappa = 20, base_size = 12) {
  theta <- directional_wrap(directional_numeric(theta, "theta"))
  x <- directional_numeric(x, "x")
  directional_check_pair(theta, x, "theta", "x")
  data <- data.frame(theta = theta, x = x)

  ggplot2::ggplot(data, ggplot2::aes(x = theta, y = x)) +
    ggplot2::geom_point(colour = "#3c82d6", alpha = 0.15, size = 1.6) +
    stat_statistical_orbit_ribbon(n_theta = n_theta, kappa = kappa, fill = "#8fb4ff", alpha = 0.28) +
    stat_statistical_orbit(n_theta = n_theta, kappa = kappa, colour = "#123f9b", linewidth = 1.15) +
    coord_circular(clip = "off") +
    scale_x_circular_radians() +
    theme_circular(base_size = base_size) +
    ggplot2::theme(legend.position = "none") +
    ggplot2::labs(x = "theta", y = "x", title = "Statistical orbit plot")
}

#' Plot toroidal topography
#'
#' @param theta First angle in radians.
#' @param phi Second angle in radians.
#' @param conditional If `TRUE`, rows are normalized to estimate `f(phi | theta)`.
#' @param ... Additional arguments passed to [estimate_toroidal_density()].
#' @param palette Colour palette for density.
#' @param base_size Base font size.
#' @param legend_position Legend position.
#' @param show_legend If `FALSE`, hide legends.
#'
#' @return A ggplot object.
#' @export
#' @family toroidal dependence plots
#'
#' @examples
#' dat <- simulate_toroidal(n = 80, seed = 1)
#' plot_toroidal_topography(dat$theta, dat$phi, n_theta = 24, n_phi = 24)
plot_toroidal_topography <- function(
  theta,
  phi,
  conditional = FALSE,
  ...,
  palette = topography_palette(),
  base_size = 12,
  legend_position = "right",
  show_legend = TRUE
) {
  theta <- directional_wrap(directional_numeric(theta, "theta"))
  phi <- directional_wrap(directional_numeric(phi, "phi"))
  directional_check_pair(theta, phi, "theta", "phi")
  data <- data.frame(
    theta = directional_signed_angle(theta),
    phi = directional_signed_angle(phi)
  )
  contour_data <- toroidal_topography_data(theta, phi, conditional = conditional, ...)
  contour_data$theta_plot <- directional_signed_angle(contour_data$theta)
  contour_data$phi_plot <- directional_signed_angle(contour_data$phi)
  br <- signed_angle_breaks_labels()
  fill_label <- if (isTRUE(conditional)) "f(phi | theta)" else "f(theta, phi)"

  ggplot2::ggplot(data, ggplot2::aes(x = theta, y = phi)) +
    stat_toroidal_topography(conditional = conditional, ...) +
    ggplot2::geom_contour(
      data = contour_data,
      ggplot2::aes(x = theta_plot, y = phi_plot, z = density),
      inherit.aes = FALSE,
      colour = "white",
      alpha = 0.38,
      linewidth = 0.25,
      bins = 9
    ) +
    ggplot2::scale_x_continuous(breaks = br$breaks, labels = br$labels) +
    ggplot2::scale_y_continuous(breaks = br$breaks, labels = br$labels) +
    ggplot2::scale_fill_gradientn(colours = palette, name = fill_label) +
    ggplot2::coord_equal(xlim = c(-pi, pi), ylim = c(-pi, pi)) +
    theme_directional_dependence(
      base_size = base_size,
      legend_position = legend_setting(show_legend, legend_position)
    ) +
    ggplot2::labs(x = "theta", y = "phi", title = "Toroidal topographic map")
}

#' Plot toroidal flow
#'
#' @param theta First angle in radians.
#' @param phi Second angle in radians.
#' @param n_sectors Number of sectors for both angles.
#' @param min_mass Minimum mass to retain.
#' @param mass_type Either `"joint"` for joint masses or `"conditional"` for
#'   masses normalized within each `theta` sector.
#' @param palette Colour palette for theta sectors.
#' @param base_size Base font size.
#' @param legend_position Legend position.
#' @param show_legend If `FALSE`, hide legends.
#'
#' @return A ggplot object.
#' @export
#' @family toroidal dependence plots
#'
#' @examples
#' dat <- simulate_toroidal(n = 80, seed = 1)
#' plot_toroidal_flow(dat$theta, dat$phi, n_sectors = 12)
plot_toroidal_flow <- function(
  theta,
  phi,
  n_sectors = 32,
  min_mass = 0.002,
  mass_type = c("joint", "conditional"),
  palette = flow_palette(),
  base_size = 12,
  legend_position = "right",
  show_legend = TRUE
) {
  mass_type <- match.arg(mass_type)
  theta <- directional_wrap(directional_numeric(theta, "theta"))
  phi <- directional_wrap(directional_numeric(phi, "phi"))
  directional_check_pair(theta, phi, "theta", "phi")
  data <- data.frame(
    theta = directional_signed_angle(theta),
    phi = directional_signed_angle(phi)
  )
  br <- signed_angle_breaks_labels()
  mass_label <- if (mass_type == "conditional") "conditional mass" else "joint mass"

  ggplot2::ggplot(data, ggplot2::aes(x = theta, y = phi)) +
    ggplot2::geom_hline(yintercept = c(-pi, 0, pi), colour = "#d7dee8", linewidth = 0.35) +
    ggplot2::geom_vline(xintercept = br$breaks, colour = "#edf1f5", linewidth = 0.35) +
    geom_toroidal_flow(n_sectors = n_sectors, min_mass = min_mass, mass_type = mass_type, lineend = "round") +
    ggplot2::scale_colour_gradientn(colours = palette, name = "theta") +
    ggplot2::scale_linewidth_continuous(range = c(0.25, 3.0), name = mass_label) +
    ggplot2::scale_alpha_continuous(range = c(0.10, 0.82), guide = "none") +
    ggplot2::scale_x_continuous(breaks = br$breaks, labels = br$labels) +
    ggplot2::scale_y_continuous(breaks = br$breaks, labels = br$labels) +
    ggplot2::coord_equal(xlim = c(-pi, pi), ylim = c(-pi, pi)) +
    theme_directional_dependence(
      base_size = base_size,
      legend_position = legend_setting(show_legend, legend_position)
    ) +
    ggplot2::theme(panel.grid = ggplot2::element_blank()) +
    ggplot2::labs(x = "theta", y = "phi", title = "Toroidal flow plot")
}

#' Plot a conditional toroidal ridge
#'
#' @param theta First angle in radians.
#' @param phi Second angle in radians.
#' @param n_theta Number of theta grid points.
#' @param n_phi Number of phi grid points.
#' @param kappa_theta Kernel concentration for `theta`.
#' @param kappa_phi Kernel concentration for `phi`.
#' @param tie_tolerance Relative tolerance used to flag near-tied distinct
#'   local modes without changing the selected ridge.
#' @param density_palette Colour palette for the density background.
#' @param rho_palette Colour palette for local concentration.
#' @param base_size Base font size.
#' @param legend_position Legend position.
#' @param show_legend If `FALSE`, hide legends.
#'
#' @return A ggplot object.
#' @export
#' @family toroidal dependence plots
#'
#' @examples
#' dat <- simulate_toroidal(n = 80, scenario = "diagonal", seed = 1)
#' plot_toroidal_ridge(dat$theta, dat$phi, n_theta = 24, n_phi = 24)
plot_toroidal_ridge <- function(
  theta,
  phi,
  n_theta = 181,
  n_phi = 181,
  kappa_theta = 20,
  kappa_phi = 20,
  tie_tolerance = 0.01,
  density_palette = c("#f6f7f9", "#d7dce1", "#aab4bf", "#6d7f91", "#33485c"),
  rho_palette = ridge_palette(),
  base_size = 12,
  legend_position = "right",
  show_legend = TRUE
) {
  theta <- directional_wrap(directional_numeric(theta, "theta"))
  phi <- directional_wrap(directional_numeric(phi, "phi"))
  directional_check_pair(theta, phi, "theta", "phi")
  data <- data.frame(
    theta = directional_signed_angle(theta),
    phi = directional_signed_angle(phi)
  )
  br <- signed_angle_breaks_labels()

  ggplot2::ggplot(data, ggplot2::aes(x = theta, y = phi)) +
    stat_toroidal_topography(
      n_theta = n_theta,
      n_phi = n_phi,
      kappa_theta = kappa_theta,
      kappa_phi = kappa_phi,
      conditional = TRUE,
      alpha = 0.85
    ) +
    stat_toroidal_ridge(
      n_theta = n_theta,
      n_phi = n_phi,
      kappa_theta = kappa_theta,
      kappa_phi = kappa_phi,
      tie_tolerance = tie_tolerance,
      linewidth = 1.35
    ) +
    ggplot2::scale_x_continuous(breaks = br$breaks, labels = br$labels) +
    ggplot2::scale_y_continuous(breaks = br$breaks, labels = br$labels) +
    ggplot2::scale_fill_gradientn(colours = density_palette, name = "f(phi | theta)") +
    ggplot2::scale_colour_gradientn(colours = rho_palette, name = "rho(theta)") +
    ggplot2::coord_equal(xlim = c(-pi, pi), ylim = c(-pi, pi)) +
    theme_directional_dependence(
      base_size = base_size,
      legend_position = legend_setting(show_legend, legend_position)
    ) +
    ggplot2::labs(x = "theta", y = "phi", title = "Conditional ridge on the torus")
}
