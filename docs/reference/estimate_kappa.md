# Estimate von Mises concentration

Estimates the von Mises concentration parameter from the mean resultant
length using the standard piecewise approximation described by Fisher
(1993). This is a descriptive approximation and does not apply
small-sample bias corrections or uncertainty quantification.

## Usage

``` r
estimate_kappa(x, axial = FALSE, na.rm = TRUE)
```

## Arguments

- x:

  Numeric vector of angles in radians.

- axial:

  Should the data be treated as axial, modulo `pi`?

- na.rm:

  Should missing values be removed?

## Value

Estimated concentration parameter `kappa`.

## References

Fisher, N. I. (1993). *Statistical Analysis of Circular Data*. Cambridge
University Press.

## See also

Other circular summaries:
[`circular_mean_ci()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/circular_mean_ci.md),
[`circular_sd()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/circular_sd.md),
[`circular_summary()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/circular_summary.md),
[`circular_variance()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/circular_variance.md),
[`mean_direction()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/mean_direction.md),
[`mean_resultant_length()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/mean_resultant_length.md),
[`resultant_length()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/resultant_length.md)
