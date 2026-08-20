# Bootstrap a statistical orbit

Bootstrap a statistical orbit

## Usage

``` r
bootstrap_stat_orbit(
  theta,
  x,
  n_boot = 100,
  n_theta = 181,
  kappa = 20,
  seed = NULL
)
```

## Arguments

- theta:

  Angles in radians.

- x:

  Real-valued response.

- n_boot:

  Number of bootstrap resamples.

- n_theta:

  Number of angular grid points.

- kappa:

  Circular concentration for local weighting.

- seed:

  Optional random seed.

## Value

A data frame with point estimates and bootstrap intervals. The returned
object has class `bootstrap_stat_orbit`.

## See also

Other directional uncertainty helpers:
[`autoplot.bootstrap_stat_orbit()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/autoplot.bootstrap_stat_orbit.md),
[`autoplot.bootstrap_toroidal_ridge()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/autoplot.bootstrap_toroidal_ridge.md),
[`bootstrap_toroidal_ridge()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/bootstrap_toroidal_ridge.md),
[`marginal_support_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/marginal_support_data.md),
[`plot_marginal_support()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_marginal_support.md),
[`sensitivity_bandwidth_grid()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/sensitivity_bandwidth_grid.md),
[`simulate_independence_lineup()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/simulate_independence_lineup.md)

## Examples

``` r
dat <- simulate_cylindrical(n = 60, seed = 1)
bootstrap_stat_orbit(dat$theta, dat$x, n_boot = 5, n_theta = 12, seed = 1)
#>        theta       mu mu_lower mu_upper     sigma sigma_lower sigma_upper
#> 1  0.2617994 6.061975 5.822436 6.335147 0.4290466   0.3460750   0.7650937
#> 2  0.7853982 5.329410 4.949296 5.750783 0.6764954   0.3479637   0.8053785
#> 3  1.3089969 5.569323 5.489868 6.040907 0.6147432   0.5597669   0.7948101
#> 4  1.8325957 6.394964 6.463097 6.758314 0.8611388   0.5790386   0.9447400
#> 5  2.3561945 5.284812 5.183122 5.650887 0.6531845   0.5452323   0.8931083
#> 6  2.8797933 4.733036 4.363412 5.278231 0.8986703   0.6403833   0.9524795
#> 7  3.4033920 3.284923 3.092735 3.374240 0.8913754   0.7744814   1.2010801
#> 8  3.9269908 2.800256 2.534729 2.956424 0.4598891   0.4306713   0.5578457
#> 9  4.4505896 3.867428 3.664545 4.116220 0.8813417   0.6545217   1.2087563
#> 10 4.9741884 5.316577 4.945900 5.485314 0.6344382   0.5707966   0.6612465
#> 11 5.4977871 5.855650 5.642772 5.951711 0.3951717   0.2734881   0.4952528
#> 12 6.0213859 6.367069 5.929435 6.426635 0.3999742   0.1556249   0.5134313
#> 13 6.2831853 6.352979 6.037347 6.842855 0.4463329   0.1364842   0.4481147
```
