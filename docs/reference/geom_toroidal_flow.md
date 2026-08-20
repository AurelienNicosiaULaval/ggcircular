# Add a toroidal flow layer

Adds rectangular flow curves from `theta` sectors to `phi` sectors. Use
with `aes(x = theta, y = phi)`.

## Usage

``` r
geom_toroidal_flow(
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
)
```

## Arguments

- mapping, data, position, show.legend, inherit.aes:

  Standard ggplot2 layer arguments.

- n_sectors:

  Number of angular sectors for both variables.

- min_mass:

  Minimum mass to draw.

- mass_type:

  Either `"joint"` or `"conditional"`.

- curvature:

  Curvature passed to
  [`ggplot2::geom_curve()`](https://ggplot2.tidyverse.org/reference/geom_segment.html).

- ...:

  Additional arguments passed to the geom.

## Value

A ggplot2 layer.

## See also

Other toroidal dependence layers:
[`stat_toroidal_ridge()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/stat_toroidal_ridge.md),
[`stat_toroidal_topography()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/stat_toroidal_topography.md)

## Examples

``` r
dat <- simulate_toroidal(n = 80, seed = 1)
ggplot2::ggplot(dat, ggplot2::aes(x = theta, y = phi)) +
  geom_toroidal_flow(n_sectors = 12, min_mass = 0)
```
