# Von Mises mixture density layer

Fits or draws a mixture of von Mises densities.

## Usage

``` r
stat_vonmises_mixture(
  mapping = NULL,
  data = NULL,
  geom = "line",
  position = "identity",
  ...,
  fit = NULL,
  k = 2,
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

- fit:

  Optional `ggcircular_vonmises_mixture` object. If `NULL`, the mixture
  is fitted to the layer's `x` aesthetic.

- k:

  Number of components when fitting inside the statistic.

- n:

  Number of grid points.

- axial:

  Should data be treated as axial, modulo `pi`?

- na.rm:

  Should missing values be removed before fitting?

## Value

A ggplot2 layer.

## See also

Other circular distributions:
[`fit_vonmises_mixture()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/fit_vonmises_mixture.md),
[`stat_vonmises()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/stat_vonmises.md),
[`stat_vonmises_fit()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/stat_vonmises_fit.md)
