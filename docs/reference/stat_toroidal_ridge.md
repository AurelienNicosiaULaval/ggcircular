# Add a conditional ridge stat layer on the torus

Adds a conditional modal ridge for circular-circular data. Use with
`aes(x = theta, y = phi)`.

## Usage

``` r
stat_toroidal_ridge(
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
)
```

## Arguments

- mapping, data, geom, position, show.legend, inherit.aes:

  Standard ggplot2 layer arguments.

- n_theta:

  Number of theta grid points.

- n_phi:

  Number of phi grid points.

- kappa_theta:

  Kernel concentration for `theta`.

- kappa_phi:

  Kernel concentration for `phi`.

- tie_tolerance:

  Relative tolerance used to flag near-tied distinct local modes without
  changing the selected ridge.

- signed:

  If `TRUE`, plot angles in the signed interval.

- ...:

  Additional arguments passed to the geom.

## Value

A ggplot2 layer.

## See also

Other toroidal dependence layers:
[`geom_toroidal_flow()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/geom_toroidal_flow.md),
[`stat_toroidal_topography()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/stat_toroidal_topography.md)

## Examples

``` r
dat <- simulate_toroidal(n = 80, scenario = "diagonal", seed = 1)
ggplot2::ggplot(dat, ggplot2::aes(x = theta, y = phi)) +
  stat_toroidal_ridge(n_theta = 24, n_phi = 24)
```
