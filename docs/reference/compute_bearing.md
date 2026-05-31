# Compute bearings

Compute bearings

## Usage

``` r
compute_bearing(x, y, angle_convention = c("mathematical", "bearing"))
```

## Arguments

- x, y:

  Numeric coordinate vectors.

- angle_convention:

  Angle convention. `"mathematical"` means zero is east and angles
  increase counterclockwise. `"bearing"` means zero is north and angles
  increase clockwise.

## Value

Numeric vector of bearings in radians. The first value is `NA`.

## See also

Other movement helpers:
[`as_step_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/as_step_data.md),
[`augment_momentuHMM_angles()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/augment_momentuHMM_angles.md),
[`compute_step_length()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/compute_step_length.md),
[`compute_turn_angle()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/compute_turn_angle.md),
[`geom_circular_point()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/geom_circular_point.md),
[`geom_direction_arrow()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/geom_direction_arrow.md),
[`mutate_directional_features()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/mutate_directional_features.md),
[`plot_state_angles()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_state_angles.md)
