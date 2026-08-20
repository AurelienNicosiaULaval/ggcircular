# Experimental 3D toroidal topography

Displays a circular-circular density on a torus. Colour represents the
estimated density and, by default, a small radial displacement also
highlights high-density regions. The function is experimental and is
intended as a geometric companion to
[`plot_toroidal_topography()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_toroidal_topography.md).

## Usage

``` r
plot_toroidal_topography_3d(
  theta,
  phi,
  major_radius = 1,
  minor_radius = 0.35,
  density_scale = 0.15,
  conditional = TRUE,
  ...
)
```

## Arguments

- theta:

  First angle in radians.

- phi:

  Second angle in radians.

- major_radius:

  Major torus radius.

- minor_radius:

  Minor torus radius.

- density_scale:

  Non-negative radial displacement applied after scaling density to
  `[0, 1]`. Use `0` for colour-only density encoding.

- conditional:

  If `TRUE`, rows are normalized to estimate `f(phi | theta)`.

- ...:

  Additional arguments passed to
  [`toroidal_topography_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/toroidal_topography_data.md).

## Value

A `plotly` htmlwidget.

## See also

Other toroidal dependence plots:
[`plot_toroidal_flow()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_toroidal_flow.md),
[`plot_toroidal_ridge()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_toroidal_ridge.md),
[`plot_toroidal_topography()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_toroidal_topography.md)

## Examples

``` r
if (FALSE) { # requireNamespace("plotly", quietly = TRUE)
dat <- simulate_toroidal(n = 120, seed = 1)
plot_toroidal_topography_3d(dat$theta, dat$phi, n_theta = 32, n_phi = 32)
}
```
