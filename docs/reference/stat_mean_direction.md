# Mean direction statistic

Computes one mean direction per group, with resultant length and an
optional approximate confidence arc.

## Usage

``` r
stat_mean_direction(
  mapping = NULL,
  data = NULL,
  geom = "segment",
  position = "identity",
  ...,
  length = c("resultant", "fixed"),
  radius = NULL,
  conf.int = FALSE,
  level = 0.95,
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

- length:

  Should the displayed segment length be proportional to the mean
  resultant length (`"resultant"`) or fixed (`"fixed"`)?

- radius:

  Optional maximum displayed radius.

- conf.int:

  Should approximate confidence limits be computed?

- level:

  Confidence level used when `conf.int = TRUE`.

- axial:

  Should the data be treated as axial, modulo `pi`?

- na.rm:

  Should missing values be silently removed?

## Value

A ggplot2 layer. Computed variables include `x`, `xend`, `y`, `yend`,
`mean`, `R`, `Rbar`, `n`, `kappa`, `ci_low` and `ci_high`.

## See also

Other mean direction layers:
[`geom_mean_direction()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/geom_mean_direction.md)

## Examples

``` r
ggplot2::ggplot(wind_directions, ggplot2::aes(x = direction)) +
  stat_mean_direction()
```
