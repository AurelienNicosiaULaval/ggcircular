# Bootstrap a toroidal conditional ridge

Bootstrap a toroidal conditional ridge

## Usage

``` r
bootstrap_toroidal_ridge(
  theta,
  phi,
  n_boot = 100,
  n_theta = 181,
  n_phi = 181,
  kappa_theta = 20,
  kappa_phi = 20,
  level = 0.95,
  seed = NULL
)
```

## Arguments

- theta:

  First angle in radians.

- phi:

  Second angle in radians.

- n_boot:

  Number of bootstrap resamples.

- n_theta:

  Number of theta grid points.

- n_phi:

  Number of phi grid points.

- kappa_theta:

  Kernel concentration for `theta`.

- kappa_phi:

  Kernel concentration for `phi`.

- level:

  Coverage level for the pointwise circular bootstrap interval.

- seed:

  Optional random seed.

## Value

A data frame with ridge and local concentration intervals. The returned
object has class `bootstrap_toroidal_ridge`.

## See also

Other directional uncertainty helpers:
[`autoplot.bootstrap_stat_orbit()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/autoplot.bootstrap_stat_orbit.md),
[`autoplot.bootstrap_toroidal_ridge()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/autoplot.bootstrap_toroidal_ridge.md),
[`bootstrap_stat_orbit()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/bootstrap_stat_orbit.md),
[`marginal_support_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/marginal_support_data.md),
[`plot_marginal_support()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_marginal_support.md),
[`sensitivity_bandwidth_grid()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/sensitivity_bandwidth_grid.md),
[`simulate_independence_lineup()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/simulate_independence_lineup.md)

## Examples

``` r
dat <- simulate_toroidal(n = 60, scenario = "diagonal", seed = 1)
bootstrap_toroidal_ridge(dat$theta, dat$phi, n_boot = 5, n_theta = 12, n_phi = 12, seed = 1)
#>        theta       phi phi_signed phi_center phi_center_signed phi_radius
#> 1  0.2617994 6.0213859 -0.2617994  6.2115115       -0.07167378  0.7236827
#> 2  0.7853982 0.2617994  0.2617994  0.4700601        0.47006015  0.3153380
#> 3  1.3089969 1.3089969  1.3089969  1.3089969        1.30899694  0.5235988
#> 4  1.8325957 1.8325957  1.8325957  1.8325957        1.83259571  0.0000000
#> 5  2.3561945 2.3561945  2.3561945  2.3561945        2.35619449  0.0000000
#> 6  2.8797933 2.3561945  2.3561945  2.3561945        2.35619449  0.0000000
#> 7  3.4033920 3.4033920 -2.8797933  3.1951313       -3.08805403  0.3153380
#> 8  3.9269908 3.9269908 -2.3561945  4.1352516       -2.14793373  0.3153380
#> 9  4.4505896 4.4505896 -1.8325957  4.3481957       -1.93498962  0.3574427
#> 10 4.9741884 4.9741884 -1.3089969  4.9741884       -1.30899694  0.0000000
#> 11 5.4977871 5.4977871 -0.7853982  5.1824491       -1.10073618  0.3153380
#> 12 6.0213859 5.4977871 -0.7853982  5.6001811       -0.68300426  0.3574427
#>     phi_lower  phi_upper phi_crosses_seam       rho rho_lower rho_upper level
#> 1  -0.7953565  0.6520089            FALSE 0.9639468 0.8228609 0.9828831  0.95
#> 2   0.1547221  0.7853982            FALSE 0.8950466 0.8580708 0.9772511  0.95
#> 3   0.7853982  1.8325957            FALSE 0.9270387 0.8905141 0.9690575  0.95
#> 4   1.8325957  1.8325957            FALSE 0.9429492 0.9404743 0.9867021  0.95
#> 5   2.3561945  2.3561945            FALSE 0.9730068 0.9479184 0.9765312  0.95
#> 6   2.3561945  2.3561945            FALSE 0.9155024 0.9100642 0.9739086  0.95
#> 7   2.8797933 -2.7727160             TRUE 0.9230231 0.9082364 0.9420589  0.95
#> 8  -2.4632717 -1.8325957            FALSE 0.9408525 0.9115729 0.9846717  0.95
#> 9  -2.2924323 -1.5775469            FALSE 0.9520079 0.9138543 0.9709773  0.95
#> 10 -1.3089969 -1.3089969            FALSE 0.9608643 0.9035875 0.9799160  0.95
#> 11 -1.4160742 -0.7853982            FALSE 0.9114836 0.8706313 0.9613684  0.95
#> 12 -1.0404469 -0.3255616            FALSE 0.9350154 0.8989520 0.9679761  0.95
```
