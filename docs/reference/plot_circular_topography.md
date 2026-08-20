# Plot circular topography

Plot circular topography

## Usage

``` r
plot_circular_topography(
  theta,
  x,
  conditional = TRUE,
  ...,
  palette = topography_palette(),
  base_size = 12,
  legend_position = "right",
  show_legend = TRUE
)
```

## Arguments

- theta:

  Angles in radians.

- x:

  Real-valued response.

- conditional:

  If `TRUE`, rows are normalized to estimate `f(x | theta)`.

- ...:

  Additional arguments passed to
  [`estimate_cyl_density()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/estimate_cyl_density.md).

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

Other cylindrical dependence plots:
[`plot_circular_topography_3d()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_circular_topography_3d.md),
[`plot_phase_loom()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_phase_loom.md),
[`plot_stat_orbit()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_stat_orbit.md)

## Examples

``` r
dat <- simulate_cylindrical(n = 80, seed = 1)
plot_circular_topography(dat$theta, dat$x, n_theta = 24, n_x = 30)
```
