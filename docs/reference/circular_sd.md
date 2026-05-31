# Circular standard deviation

Uses the common descriptive statistic `sqrt(-2 * log(Rbar))`.

## Usage

``` r
circular_sd(x, axial = FALSE, na.rm = TRUE)
```

## Arguments

- x:

  Numeric vector of angles in radians.

- axial:

  Should the data be treated as axial, modulo `pi`?

- na.rm:

  Should missing values be removed?

## Value

Circular standard deviation in radians.

## See also

Other circular summaries:
[`circular_mean_ci()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/circular_mean_ci.md),
[`circular_summary()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/circular_summary.md),
[`circular_variance()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/circular_variance.md),
[`estimate_kappa()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/estimate_kappa.md),
[`mean_direction()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/mean_direction.md),
[`mean_resultant_length()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/mean_resultant_length.md),
[`resultant_length()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/resultant_length.md)
