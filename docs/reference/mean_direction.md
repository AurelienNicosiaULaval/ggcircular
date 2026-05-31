# Circular mean direction

Computes the sample mean direction. For axial data, angles are doubled
before computing the mean and the result is transformed back to the
axial scale.

## Usage

``` r
mean_direction(x, axial = FALSE, na.rm = TRUE)
```

## Arguments

- x:

  Numeric vector of angles in radians.

- axial:

  Should the data be treated as axial, modulo `pi`?

- na.rm:

  Should missing values be removed?

## Value

A single angle in radians, or `NA_real_` when the mean is undefined.

## See also

Other circular summaries:
[`circular_mean_ci()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/circular_mean_ci.md),
[`circular_sd()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/circular_sd.md),
[`circular_summary()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/circular_summary.md),
[`circular_variance()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/circular_variance.md),
[`estimate_kappa()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/estimate_kappa.md),
[`mean_resultant_length()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/mean_resultant_length.md),
[`resultant_length()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/resultant_length.md)

## Examples

``` r
mean_direction(c(0, pi / 4, pi / 2))
#> [1] 0.7853982
```
