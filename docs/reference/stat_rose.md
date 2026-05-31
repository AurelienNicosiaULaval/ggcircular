# Rose diagram statistic

Bins circular angles over a full period and returns counts, densities
and proportions for rose diagrams.

## Usage

``` r
stat_rose(
  mapping = NULL,
  data = NULL,
  geom = "col",
  position = "identity",
  ...,
  bins = 30,
  binwidth = NULL,
  boundary = 0,
  closed = TRUE,
  area = FALSE,
  normalize = c("count", "density", "proportion"),
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

- bins:

  Number of bins over the circular period.

- binwidth:

  Optional bin width in radians. If supplied, `bins` is ignored after
  the number of bins is inferred from the period.

- boundary:

  Lower boundary for the first bin.

- closed:

  Included for API compatibility. Values on the upper period boundary
  are wrapped into the first bin.

- area:

  If `TRUE`, radial heights are square-root transformed so that visual
  area is closer to the selected frequency scale.

- normalize:

  Which scale should be used for the computed radial `y` value: counts,
  densities or proportions.

- axial:

  Should angles be treated as axial, modulo `pi`?

- na.rm:

  Should missing values be silently removed?

## Value

A ggplot2 layer. Computed variables are `xmin`, `xmax`, `x`, `count`,
`density`, `proportion`, `width` and `y`.

## See also

Other rose diagram layers:
[`geom_rose()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/geom_rose.md)

## Examples

``` r
ggplot2::ggplot(wind_directions, ggplot2::aes(x = direction)) +
  stat_rose(bins = 16) +
  coord_circular()
```
