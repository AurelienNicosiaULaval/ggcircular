# Add a statistical orbit ribbon

Add a statistical orbit ribbon

## Usage

``` r
stat_statistical_orbit_ribbon(
  mapping = NULL,
  data = NULL,
  geom = "ribbon",
  position = "identity",
  n_theta = 181,
  kappa = 20,
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

- kappa:

  Circular concentration for local weighting.

- ...:

  Additional arguments passed to the geom.

## Value

A ggplot2 layer.

## See also

Other cylindrical dependence layers:
[`geom_phase_loom()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/geom_phase_loom.md),
[`stat_circular_topography()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/stat_circular_topography.md),
[`stat_statistical_orbit()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/stat_statistical_orbit.md)

## Examples

``` r
dat <- simulate_cylindrical(n = 80, seed = 1)
ggplot2::ggplot(dat, ggplot2::aes(x = theta, y = x)) +
  stat_statistical_orbit_ribbon(n_theta = 24, alpha = 0.2) +
  stat_statistical_orbit(n_theta = 24)
```
