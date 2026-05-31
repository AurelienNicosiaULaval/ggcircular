# Circular density statistic

Estimates a smooth circular density using a von Mises kernel. The
density wraps around the origin, avoiding the boundary artifacts of a
linear kernel density estimate.

## Usage

``` r
stat_circular_density(
  mapping = NULL,
  data = NULL,
  geom = "line",
  position = "identity",
  ...,
  method = c("kernel", "vonmises"),
  bw = NULL,
  adjust = 1,
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

- method:

  Density method. Currently `"kernel"` and `"vonmises"` both use a von
  Mises kernel estimator.

- bw:

  Optional circular bandwidth. It is interpreted as `1 / sqrt(kappa)`.

- adjust:

  Multiplicative adjustment applied to `bw` or to the automatic
  bandwidth scale.

- n:

  Number of grid points.

- axial:

  Should the data be treated as axial, modulo `pi`?

- na.rm:

  Should missing values be silently removed?

## Value

A ggplot2 layer. Computed variables are `x`, `density`, `scaled`,
`count`, `n`, `bw` and `kappa`.

## See also

Other circular density layers:
[`geom_circular_density()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/geom_circular_density.md)

## Examples

``` r
ggplot2::ggplot(wind_directions, ggplot2::aes(x = direction)) +
  stat_circular_density()
```
