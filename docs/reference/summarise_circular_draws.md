# Summarize circular posterior draws

Summarize circular posterior draws

## Usage

``` r
summarise_circular_draws(
  draws,
  variables = NULL,
  level = 0.95,
  axial = FALSE,
  ...
)
```

## Arguments

- draws:

  Circular draws from
  [`as_circular_draws()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/as_circular_draws.md)
  or any object accepted by
  [`posterior::as_draws_df()`](https://mc-stan.org/posterior/reference/draws_df.html).

- variables:

  Optional variables to summarize.

- level:

  Credible interval level.

- axial:

  Should draws be treated as axial, modulo `pi`?

- ...:

  Additional arguments passed to
  [`as_circular_draws()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/as_circular_draws.md)
  when needed.

## Value

A tibble with posterior circular summaries.

## See also

Other posterior helpers:
[`as_circular_draws()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/as_circular_draws.md),
[`autoplot_circular_draws()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/autoplot_circular_draws.md)
