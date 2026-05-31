# Direction arrows

Draws directional arrows from Cartesian coordinates and an angle.

## Usage

``` r
geom_direction_arrow(
  mapping = NULL,
  data = NULL,
  ...,
  length = 1,
  arrow_length = grid::unit(0.15, "cm"),
  angle_convention = c("mathematical", "bearing"),
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

- length:

  Default arrow length when no `length` aesthetic is supplied.

- arrow_length:

  Grid unit controlling the arrow head length.

- angle_convention:

  Angle convention. `"mathematical"` means zero is east and angles
  increase counterclockwise. `"bearing"` means zero is north and angles
  increase clockwise.

- na.rm:

  Should missing values be silently removed?

## Value

A ggplot2 layer.

## See also

Other movement helpers:
[`as_step_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/as_step_data.md),
[`augment_momentuHMM_angles()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/augment_momentuHMM_angles.md),
[`compute_bearing()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/compute_bearing.md),
[`compute_step_length()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/compute_step_length.md),
[`compute_turn_angle()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/compute_turn_angle.md),
[`geom_circular_point()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/geom_circular_point.md),
[`mutate_directional_features()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/mutate_directional_features.md),
[`plot_state_angles()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_state_angles.md)

## Examples

``` r
ggplot2::ggplot(animal_steps, ggplot2::aes(x = x, y = y, angle = bearing)) +
  geom_direction_arrow()
#> Warning: Removed 3 rows containing non-finite outside the scale range
#> (`stat_direction_arrow()`).
```
