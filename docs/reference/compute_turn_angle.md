# Compute turn angles

Compute turn angles

## Usage

``` r
compute_turn_angle(bearing, period = 2 * pi)
```

## Arguments

- bearing:

  Numeric vector of bearings in radians.

- period:

  Angular period.

## Value

Numeric vector of signed turn angles. The first value is `NA`.

## See also

Other movement helpers:
[`as_step_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/as_step_data.md),
[`augment_momentuHMM_angles()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/augment_momentuHMM_angles.md),
[`compute_bearing()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/compute_bearing.md),
[`compute_step_length()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/compute_step_length.md),
[`geom_circular_point()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/geom_circular_point.md),
[`geom_direction_arrow()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/geom_direction_arrow.md),
[`mutate_directional_features()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/mutate_directional_features.md),
[`plot_state_angles()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_state_angles.md)
