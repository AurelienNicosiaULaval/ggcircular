# Circular point and rug helpers

Convenience layers for plotting angular observations at a fixed radius.

## Usage

``` r
geom_circular_point(
  mapping = NULL,
  data = NULL,
  ...,
  radius = 1,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
)

geom_circular_rug(
  mapping = NULL,
  data = NULL,
  ...,
  radius = 1,
  rug_length = 0.05,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
)
```

## Arguments

- mapping, data, show.legend, inherit.aes:

  Standard ggplot2 layer arguments.

- ...:

  Additional arguments passed to
  [`ggplot2::geom_segment()`](https://ggplot2.tidyverse.org/reference/geom_segment.html).

- radius:

  Radius at which points or rugs are drawn.

- na.rm:

  Should missing values be silently removed?

- rug_length:

  Radial length of rug marks.

## Value

A ggplot2 layer.

## See also

Other movement helpers:
[`as_step_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/as_step_data.md),
[`augment_momentuHMM_angles()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/augment_momentuHMM_angles.md),
[`compute_bearing()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/compute_bearing.md),
[`compute_step_length()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/compute_step_length.md),
[`compute_turn_angle()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/compute_turn_angle.md),
[`geom_direction_arrow()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/geom_direction_arrow.md),
[`mutate_directional_features()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/mutate_directional_features.md),
[`plot_state_angles()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_state_angles.md)
