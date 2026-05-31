# Circular confidence arc

Draws angular intervals as arcs at a fixed radius. Intervals crossing
zero are split into two path segments.

## Usage

``` r
geom_confidence_arc(
  mapping = NULL,
  data = NULL,
  ...,
  radius = 1,
  n = 200,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
)

geom_circular_interval(
  mapping = NULL,
  data = NULL,
  ...,
  radius = 1,
  n = 200,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
)
```

## Arguments

- mapping, data, show.legend, inherit.aes:

  Standard ggplot2 layer arguments.

- ...:

  Additional arguments passed to the path geometry.

- radius:

  Default radius used when no `radius` or `y` aesthetic is supplied.

- n:

  Number of points used to discretize each interval.

- na.rm:

  Should missing interval endpoints be silently removed?

## Value

A ggplot2 layer.

## Examples

``` r
tibble::tibble(lower = 5.5, upper = 0.5) |>
  ggplot2::ggplot(ggplot2::aes(xmin = lower, xmax = upper)) +
  geom_confidence_arc()
```
