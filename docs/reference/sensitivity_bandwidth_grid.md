# Evaluate sensitivity to smoothing concentration

Evaluate sensitivity to smoothing concentration

## Usage

``` r
sensitivity_bandwidth_grid(
  theta,
  target,
  space = c("cylindrical", "toroidal"),
  kappa_values = c(8, 12, 20, 32)
)
```

## Arguments

- theta:

  Conditioning angle in radians.

- target:

  Real-valued response or second angle.

- space:

  Either `"cylindrical"` or `"toroidal"`.

- kappa_values:

  Numeric vector of candidate concentrations.

## Value

A data frame of compact sensitivity summaries.

## See also

Other directional uncertainty helpers:
[`autoplot.bootstrap_stat_orbit()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/autoplot.bootstrap_stat_orbit.md),
[`autoplot.bootstrap_toroidal_ridge()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/autoplot.bootstrap_toroidal_ridge.md),
[`bootstrap_stat_orbit()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/bootstrap_stat_orbit.md),
[`bootstrap_toroidal_ridge()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/bootstrap_toroidal_ridge.md),
[`marginal_support_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/marginal_support_data.md),
[`plot_marginal_support()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_marginal_support.md),
[`simulate_independence_lineup()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/simulate_independence_lineup.md)

## Examples

``` r
dat <- simulate_cylindrical(n = 60, seed = 1)
sensitivity_bandwidth_grid(dat$theta, dat$x, space = "cylindrical", kappa_values = c(8, 12))
#>         space kappa mean_range mean_sigma mean_rho
#> 1 cylindrical     8   3.228224  0.7848828       NA
#> 2 cylindrical    12   3.463063  0.7192836       NA
```
