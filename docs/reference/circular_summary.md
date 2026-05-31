# Summarize circular data

Computes grouped circular summaries for an angle column. Existing dplyr
groups are respected, and additional grouping variables can be supplied
in `...`.

## Usage

``` r
circular_summary(data, angle, ..., axial = FALSE, na.rm = TRUE)
```

## Arguments

- data:

  A data frame or tibble.

- angle:

  Angle column, in radians.

- ...:

  Optional grouping variables.

- axial:

  Should the data be treated as axial, modulo `pi`?

- na.rm:

  Should missing values be removed?

## Value

A tibble with columns `n`, `mean`, `R`, `Rbar`, `variance`, `sd` and
`kappa`. The returned object also has class `ggcircular_summary`.

## See also

Other circular summaries:
[`circular_mean_ci()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/circular_mean_ci.md),
[`circular_sd()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/circular_sd.md),
[`circular_variance()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/circular_variance.md),
[`estimate_kappa()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/estimate_kappa.md),
[`mean_direction()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/mean_direction.md),
[`mean_resultant_length()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/mean_resultant_length.md),
[`resultant_length()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/resultant_length.md)

## Examples

``` r
tibble::tibble(group = c("a", "a", "b"), theta = c(0, pi / 2, pi)) |>
  dplyr::group_by(group) |>
  circular_summary(theta)
#> # A tibble: 2 × 8
#>   group     n  mean     R  Rbar variance    sd  kappa
#>   <chr> <int> <dbl> <dbl> <dbl>    <dbl> <dbl>  <dbl>
#> 1 a         2 0.785  1.41 0.707    0.293 0.833   2.05
#> 2 b         1 3.14   1    1        0     0     Inf   
```
