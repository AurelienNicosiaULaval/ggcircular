# Fit a mixture of von Mises distributions

Fits a finite mixture of von Mises components using an expectation
maximization algorithm. For axial data, the algorithm fits doubled
angles and returns component means on the original modulo-`pi` scale.

## Usage

``` r
fit_vonmises_mixture(
  x,
  k = 2,
  weights = NULL,
  axial = FALSE,
  init = c("kmeans", "spaced"),
  max_iter = 200,
  tol = 1e-08,
  na.rm = TRUE
)
```

## Arguments

- x:

  Numeric vector of angles in radians.

- k:

  Number of mixture components.

- weights:

  Optional non-negative observation weights.

- axial:

  Should data be treated as axial, modulo `pi`?

- init:

  Initialization method, either `"kmeans"` or `"spaced"`.

- max_iter:

  Maximum number of EM iterations.

- tol:

  Convergence tolerance on the log-likelihood.

- na.rm:

  Should missing values be removed?

## Value

An object of class `ggcircular_vonmises_mixture`.

## See also

Other circular distributions:
[`stat_vonmises()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/stat_vonmises.md),
[`stat_vonmises_fit()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/stat_vonmises_fit.md),
[`stat_vonmises_mixture()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/stat_vonmises_mixture.md)

## Examples

``` r
fit <- fit_vonmises_mixture(wind_directions$direction, k = 2)
tidy_circular(fit)
#> # A tibble: 2 × 4
#>   component proportion    mu kappa
#>       <int>      <dbl> <dbl> <dbl>
#> 1         1      0.317 0.904 1.51 
#> 2         2      0.683 4.06  0.749
```
