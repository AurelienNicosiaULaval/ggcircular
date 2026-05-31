# Confidence interval for a circular mean

Computes an approximate confidence interval for a circular mean. The
large sample method uses a normal approximation on the mean direction,
while the bootstrap method resamples angles and forms an interval from
angular deviations around the sample mean. These intervals are
exploratory; they are not reliable when the mean resultant length is
close to zero and the mean direction is weakly identified.

## Usage

``` r
circular_mean_ci(
  x,
  level = 0.95,
  method = c("large_sample", "bootstrap"),
  R = 999,
  axial = FALSE,
  na.rm = TRUE,
  seed = NULL
)
```

## Arguments

- x:

  Numeric vector of angles in radians.

- level:

  Confidence level.

- method:

  Interval method.

- R:

  Number of bootstrap resamples.

- axial:

  Should data be treated as axial, modulo `pi`?

- na.rm:

  Should missing values be removed?

- seed:

  Optional random seed for the bootstrap.

## Value

A tibble with `mean`, `lower`, `upper`, `level`, `method`, `n` and
`Rbar`.

## See also

Other circular summaries:
[`circular_sd()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/circular_sd.md),
[`circular_summary()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/circular_summary.md),
[`circular_variance()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/circular_variance.md),
[`estimate_kappa()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/estimate_kappa.md),
[`mean_direction()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/mean_direction.md),
[`mean_resultant_length()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/mean_resultant_length.md),
[`resultant_length()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/resultant_length.md)
