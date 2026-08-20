# Plot toroidal topography

Plot toroidal topography

## Usage

``` r
plot_toroidal_topography(
  theta,
  phi,
  conditional = FALSE,
  ...,
  palette = topography_palette(),
  base_size = 12,
  legend_position = "right",
  show_legend = TRUE
)
```

## Arguments

- theta:

  First angle in radians.

- phi:

  Second angle in radians.

- conditional:

  If `TRUE`, rows are normalized to estimate `f(phi | theta)`.

- ...:

  Additional arguments passed to
  [`estimate_toroidal_density()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/estimate_toroidal_density.md).

- palette:

  Colour palette for density.

- base_size:

  Base font size.

- legend_position:

  Legend position.

- show_legend:

  If `FALSE`, hide legends.

## Value

A ggplot object.

## See also

Other toroidal dependence plots:
[`plot_toroidal_flow()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_toroidal_flow.md),
[`plot_toroidal_ridge()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_toroidal_ridge.md),
[`plot_toroidal_topography_3d()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_toroidal_topography_3d.md)

## Examples

``` r
dat <- simulate_toroidal(n = 80, seed = 1)
plot_toroidal_topography(dat$theta, dat$phi, n_theta = 24, n_phi = 24)
```
