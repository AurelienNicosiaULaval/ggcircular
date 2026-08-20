# Select smoothing parameters for toroidal conditional density

Ranks candidate smoothing parameters by K-fold conditional
log-likelihood for `f(phi | theta)`.

## Usage

``` r
select_toroidal_smoothing(
  theta,
  phi,
  kappa_theta_values = c(6, 8, 12, 16, 24, 36),
  kappa_phi_values = kappa_theta_values,
  n_folds = 5,
  seed = NULL
)
```

## Arguments

- theta:

  Conditioning angles in radians.

- phi:

  Response angles in radians.

- kappa_theta_values:

  Candidate concentrations for the conditioning angle.

- kappa_phi_values:

  Candidate concentrations for the response angle.

- n_folds:

  Number of cross-validation folds.

- seed:

  Optional random seed for fold assignment.

## Value

A data frame ranked by decreasing mean held-out log score. The returned
object has class `directional_smoothing_selection`.

## See also

Other directional smoothing helpers:
[`select_cyl_smoothing()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/select_cyl_smoothing.md)

## Examples

``` r
dat <- simulate_toroidal(n = 80, scenario = "diagonal", seed = 1)
select_toroidal_smoothing(
  dat$theta, dat$phi,
  kappa_theta_values = c(8, 12),
  kappa_phi_values = c(8, 12),
  n_folds = 2,
  seed = 1
)
#>   kappa_theta kappa_phi mean_log_score se_log_score rank
#> 1          12        12     -0.4107139   0.02640808    1
#> 2          12         8     -0.4565855   0.02281268    2
#> 3           8        12     -0.4667357   0.01399824    3
#> 4           8         8     -0.5107015   0.01308776    4
```
