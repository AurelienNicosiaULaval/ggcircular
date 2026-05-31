# Add directional movement features

Computes step length, bearing and turn angle from track coordinates.
When `id` and `time` are supplied, records are sorted by individual and
time before features are computed.

## Usage

``` r
mutate_directional_features(
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

A tibble with added `step_length`, `bearing` and `turn_angle`.

## See also

Other movement helpers:
[`as_step_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/as_step_data.md),
[`augment_momentuHMM_angles()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/augment_momentuHMM_angles.md),
[`compute_bearing()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/compute_bearing.md),
[`compute_step_length()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/compute_step_length.md),
[`compute_turn_angle()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/compute_turn_angle.md),
[`geom_circular_point()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/geom_circular_point.md),
[`geom_direction_arrow()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/geom_direction_arrow.md),
[`plot_state_angles()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_state_angles.md)

## Examples

``` r
tibble::tibble(id = 1, time = 1:3, x = 0:2, y = 0) |>
  mutate_directional_features(x = x, y = y, id = id, time = time)
#> # A tibble: 3 × 7
#>      id  time     x     y step_length bearing turn_angle
#>   <dbl> <int> <int> <dbl>       <dbl>   <dbl>      <dbl>
#> 1     1     1     0     0          NA      NA         NA
#> 2     1     2     1     0           1       0         NA
#> 3     1     3     2     0           1       0          0
```
