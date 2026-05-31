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
  nstart = 1,
  init_params = NULL,
  kappa_max = 10000,
  min_component_weight = 1e-08,
  max_iter = 200,
  tol = 1e-08,
  na.rm = TRUE,
  seed = NULL
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

- nstart:

  Number of EM starts. The fit with the largest log-likelihood is
  retained.

- init_params:

  Optional list or data frame with initial `proportions`, `mu` and
  `kappa` values.

- kappa_max:

  Maximum fitted concentration. This caps nearly degenerate components.

- min_component_weight:

  Minimum relative component weight before a component is reinitialized.

- max_iter:

  Maximum number of EM iterations.

- tol:

  Convergence tolerance on the log-likelihood.

- na.rm:

  Should missing values be removed?

- seed:

  Optional random seed used for initialization.

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
#> Warning: `fit_vonmises_mixture()` did not converge within `max_iter` iterations.
tidy_circular(fit)
#> # A tibble: 2 × 4
#>   component proportion    mu kappa
#>       <int>      <dbl> <dbl> <dbl>
#> 1         1      0.321 0.903 1.49 
#> 2         2      0.679 4.06  0.755
```
