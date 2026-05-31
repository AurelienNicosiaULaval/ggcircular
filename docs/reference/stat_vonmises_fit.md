# Fitted von Mises density

Estimates `mu` with
[`mean_direction()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/mean_direction.md)
and `kappa` with
[`estimate_kappa()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/estimate_kappa.md),
then draws the fitted von Mises density.

## Usage

``` r
stat_vonmises_fit(
  mapping = NULL,
  data = NULL,
  geom = "line",
  position = "identity",
  ...,
  n = 512,
  axial = FALSE,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
)
```

## Arguments

- mapping, data, geom, position, show.legend, inherit.aes:

  Standard ggplot2 layer arguments.

- ...:

  Additional arguments passed to the layer.

- n:

  Number of grid points.

- axial:

  Should the data be treated as axial, modulo `pi`?

- na.rm:

  Should missing values be silently removed?

## Value

A ggplot2 layer.

## See also

Other circular distributions:
[`fit_vonmises_mixture()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/fit_vonmises_mixture.md),
[`stat_vonmises()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/stat_vonmises.md),
[`stat_vonmises_mixture()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/stat_vonmises_mixture.md)

## Examples

``` r
ggplot2::ggplot(wind_directions, ggplot2::aes(x = direction)) +
  geom_rose(ggplot2::aes(y = ggplot2::after_stat(density))) +
  stat_vonmises_fit()
```
