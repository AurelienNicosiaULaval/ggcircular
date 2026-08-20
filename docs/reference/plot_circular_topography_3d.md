# Experimental 3D circular topography

Displays a circular-linear conditional density on a cylinder. The
function is experimental and is intended as a geometric companion to
[`plot_circular_topography()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_circular_topography.md),
not as a replacement for the 2D display.

## Usage

``` r
plot_circular_topography_3d(theta, x, radius = 1, conditional = TRUE, ...)
```

## Arguments

- theta:

  Angles in radians.

- x:

  Real-valued response.

- radius:

  Radius of the cylinder.

- conditional:

  If `TRUE`, rows are normalized to estimate `f(x | theta)`.

- ...:

  Additional arguments passed to
  [`circular_topography_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/circular_topography_data.md).

## Value

A `plotly` htmlwidget.

## See also

Other cylindrical dependence plots:
[`plot_circular_topography()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_circular_topography.md),
[`plot_phase_loom()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_phase_loom.md),
[`plot_stat_orbit()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_stat_orbit.md)

## Examples

``` r
if (FALSE) { # requireNamespace("plotly", quietly = TRUE)
dat <- simulate_cylindrical(n = 120, seed = 1)
plot_circular_topography_3d(dat$theta, dat$x, n_theta = 32, n_x = 40)
}
```
