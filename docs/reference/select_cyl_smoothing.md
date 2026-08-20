# Select smoothing parameters for circular-linear conditional density

Ranks candidate smoothing parameters by K-fold conditional
log-likelihood.

## Usage

``` r
select_cyl_smoothing(
  theta,
  x,
  kappa_values = c(6, 8, 12, 16, 24, 36),
  h_values = NULL,
  n_folds = 5,
  seed = NULL
)
```

## Arguments

- theta:

  Conditioning angles in radians.

- x:

  Linear response.

- kappa_values:

  Candidate circular concentration values.

- h_values:

  Candidate linear bandwidth values. If `NULL`, a small grid is built
  around the rule-of-thumb bandwidth used by
  [`estimate_cyl_density()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/estimate_cyl_density.md).

- n_folds:

  Number of cross-validation folds.

- seed:

  Optional random seed for fold assignment.

## Value

A data frame ranked by decreasing mean held-out log score. The returned
object has class `directional_smoothing_selection`.

## See also

Other directional smoothing helpers:
[`select_toroidal_smoothing()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/select_toroidal_smoothing.md)

## Examples

``` r
dat <- simulate_cylindrical(n = 80, seed = 1)
select_cyl_smoothing(
  dat$theta, dat$x,
  kappa_values = c(8, 12),
  h_values = c(0.3, 0.5),
  n_folds = 2,
  seed = 1
)
#>   kappa   h mean_log_score se_log_score rank
#> 1    12 0.5      -1.160393   0.03815670    1
#> 2     8 0.5      -1.184392   0.03798779    2
#> 3     8 0.3      -1.306153   0.10941871    3
#> 4    12 0.3      -1.314517   0.10744874    4
```
