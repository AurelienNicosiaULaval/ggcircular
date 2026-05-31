# Augment momentuHMM fits with angular states

Extracts an angle column and inferred states from a fitted `momentuHMM`
model. The function uses `momentuHMM::viterbi()` by default and adds
state probabilities when `momentuHMM::stateProbs()` is available.

## Usage

``` r
augment_momentuHMM_angles(
  object,
  data = NULL,
  angle = NULL,
  state_method = c("viterbi", "stateProbs"),
  ...
)
```

## Arguments

- object:

  A fitted `momentuHMM` object.

- data:

  Optional data frame. If `NULL`, `object$data` is used.

- angle:

  Optional name of the angle column.

- state_method:

  State extraction method.

- ...:

  Reserved for future methods.

## Value

A tibble with `.angle`, `.state` and optional state probabilities.

## See also

Other movement helpers:
[`as_step_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/as_step_data.md),
[`compute_bearing()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/compute_bearing.md),
[`compute_step_length()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/compute_step_length.md),
[`compute_turn_angle()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/compute_turn_angle.md),
[`geom_circular_point()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/geom_circular_point.md),
[`geom_direction_arrow()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/geom_direction_arrow.md),
[`mutate_directional_features()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/mutate_directional_features.md),
[`plot_state_angles()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_state_angles.md)
