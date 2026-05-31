# Autoplot circular posterior draws

Autoplot circular posterior draws

## Usage

``` r
autoplot_circular_draws(
  draws,
  variables = NULL,
  type = c("density", "interval"),
  axial = FALSE,
  ...
)
```

## Arguments

- draws:

  Circular draws or posterior draws.

- variables:

  Optional variables to plot.

- type:

  Plot type.

- axial:

  Should draws be treated as axial, modulo `pi`?

- ...:

  Additional arguments passed to
  [`as_circular_draws()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/as_circular_draws.md)
  when needed.

## Value

A ggplot object.

## See also

Other posterior helpers:
[`as_circular_draws()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/as_circular_draws.md),
[`summarise_circular_draws()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/summarise_circular_draws.md)
