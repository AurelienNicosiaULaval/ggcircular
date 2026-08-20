# Add a circular topography stat layer

Estimates a circular-linear density and returns grid values for
topographic displays. Use with `aes(x = theta, y = response)`.

## Usage

``` r
stat_circular_topography(
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
)
```

## Arguments

- mapping, data, geom, position, show.legend, inherit.aes:

  Standard ggplot2 layer arguments.

- n_theta:

  Number of angular grid points.

- n_x:

  Number of linear grid points.

- kappa:

  Circular concentration for the conditioning kernel.

- h:

  Linear bandwidth. If `NULL`, a rule-of-thumb bandwidth is used.

- conditional:

  If `TRUE`, estimate `f(y | x_angle)`.

- ...:

  Additional arguments passed to the geom.

## Value

A ggplot2 layer.

## See also

Other cylindrical dependence layers:
[`geom_phase_loom()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/geom_phase_loom.md),
[`stat_statistical_orbit()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/stat_statistical_orbit.md),
[`stat_statistical_orbit_ribbon()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/stat_statistical_orbit_ribbon.md)

## Examples

``` r
dat <- simulate_cylindrical(n = 80, seed = 1)
ggplot2::ggplot(dat, ggplot2::aes(x = theta, y = x)) +
  stat_circular_topography(n_theta = 24, n_x = 30)
```
