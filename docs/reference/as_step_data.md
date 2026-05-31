# Coerce to step data

Thin wrapper around
[`mutate_directional_features()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/mutate_directional_features.md)
for pipelines where a more explicit movement-data verb is useful.

## Usage

``` r
as_step_data(
  data,
  x,
  y,
  id = NULL,
  time = NULL,
  angle_convention = c("mathematical", "bearing")
)
```

## Arguments

- data:

  A data frame.

- x, y:

  Coordinate columns.

- id:

  Optional individual identifier column.

- time:

  Optional time column used for sorting within individual.

- angle_convention:

  Angle convention passed to
  [`compute_bearing()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/compute_bearing.md).

## Value

A tibble with movement features.

## See also

Other movement helpers:
[`augment_momentuHMM_angles()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/augment_momentuHMM_angles.md),
[`compute_bearing()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/compute_bearing.md),
[`compute_step_length()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/compute_step_length.md),
[`compute_turn_angle()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/compute_turn_angle.md),
[`geom_circular_point()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/geom_circular_point.md),
[`geom_direction_arrow()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/geom_direction_arrow.md),
[`mutate_directional_features()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/mutate_directional_features.md),
[`plot_state_angles()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_state_angles.md)
