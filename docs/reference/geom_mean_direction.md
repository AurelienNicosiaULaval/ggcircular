# Mean direction layer

Draws a radial segment at the circular mean direction. The segment
length can be fixed or proportional to the mean resultant length.

## Usage

``` r
geom_mean_direction(
  mapping = NULL,
  data = NULL,
  stat = "mean_direction",
  position = "identity",
  ...,
  length = c("resultant", "fixed"),
  radius = NULL,
  conf.int = FALSE,
  level = 0.95,
  axial = FALSE,
  arrow = TRUE,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
)
```

## Arguments

- mapping, data, position, show.legend, inherit.aes:

  Standard ggplot2 layer arguments.

- stat:

  Statistical transformation, usually `"mean_direction"`.

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

- arrow:

  Should a small arrow head be drawn?

- na.rm:

  Should missing values be silently removed?

## Value

A ggplot2 layer.

## See also

Other mean direction layers:
[`stat_mean_direction()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/stat_mean_direction.md)

## Examples

``` r
ggplot2::ggplot(wind_directions, ggplot2::aes(x = direction)) +
  geom_rose(bins = 16) +
  geom_mean_direction()
```
