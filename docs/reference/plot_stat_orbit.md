# Plot a statistical orbit

Plot a statistical orbit

## Usage

``` r
plot_stat_orbit(theta, x, n_theta = 181, kappa = 20, base_size = 12)
```

## Arguments

- theta:

  Angles in radians.

- x:

  Real-valued response.

- n_theta:

  Number of angular grid points.

- kappa:

  Circular concentration for local weighting.

- base_size:

  Base font size.

## Value

A ggplot object.

## See also

Other cylindrical dependence plots:
[`plot_circular_topography()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_circular_topography.md),
[`plot_circular_topography_3d()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_circular_topography_3d.md),
[`plot_phase_loom()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_phase_loom.md)

## Examples

``` r
dat <- simulate_cylindrical(n = 80, seed = 1)
plot_stat_orbit(dat$theta, dat$x, n_theta = 24)
```
