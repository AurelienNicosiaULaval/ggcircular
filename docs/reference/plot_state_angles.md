# Plot angular distributions by state

Convenience function for visualizing angles by observed or inferred
states.

## Usage

``` r
plot_state_angles(
  data,
  angle,
  state,
  type = c("rose", "density", "mean"),
  bins = 24,
  axial = FALSE
)
```

## Arguments

- data:

  A data frame.

- angle:

  Angle column.

- state:

  State or group column.

- type:

  Plot type.

- bins:

  Number of bins for rose diagrams.

- axial:

  Should data be treated as axial, modulo `pi`?

## Value

A ggplot object.

## See also

Other movement helpers:
[`as_step_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/as_step_data.md),
[`augment_momentuHMM_angles()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/augment_momentuHMM_angles.md),
[`compute_bearing()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/compute_bearing.md),
[`compute_step_length()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/compute_step_length.md),
[`compute_turn_angle()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/compute_turn_angle.md),
[`geom_circular_point()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/geom_circular_point.md),
[`geom_direction_arrow()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/geom_direction_arrow.md),
[`mutate_directional_features()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/mutate_directional_features.md)
