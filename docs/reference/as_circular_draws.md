# Convert posterior draws to circular draws

Converts objects supported by
[`posterior::as_draws_df()`](https://mc-stan.org/posterior/reference/draws_df.html)
into a long tibble of normalized angular draws.

## Usage

``` r
as_circular_draws(draws, variables = NULL, period = 2 * pi, origin = 0)
```

## Arguments

- draws:

  Posterior draws object.

- variables:

  Optional variables to keep.

- period:

  Angular period.

- origin:

  Lower bound of the normalized interval.

## Value

A tibble with draw identifiers, `.variable` and `.angle`.

## See also

Other posterior helpers:
[`autoplot_circular_draws()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/autoplot_circular_draws.md),
[`summarise_circular_draws()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/summarise_circular_draws.md)
