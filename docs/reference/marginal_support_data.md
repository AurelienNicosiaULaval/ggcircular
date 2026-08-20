# Estimate angular marginal support

Computes a kernel-weighted marginal support score along the conditioning
angle. Low relative support marks angular regions where conditional
displays should be interpreted cautiously.

## Usage

``` r
marginal_support_data(
  theta,
  grid = NULL,
  n_theta = 181,
  kappa = 20,
  relative_threshold = 0.15
)
```

## Arguments

- theta:

  Conditioning angles in radians.

- grid:

  Optional angular grid in radians.

- n_theta:

  Number of grid points used when `grid` is `NULL`.

- kappa:

  Circular concentration for local kernel weights.

- relative_threshold:

  Relative support threshold used to flag low-support regions. With
  other ingredients fixed, the local standard error is approximately
  inflated by `1 / sqrt(relative_support)`. The default 0.15 corresponds
  to an inflation of about 2.58 relative to the best-supported
  direction; 0.25 is a more conservative threshold corresponding to
  about twofold inflation.

## Value

A data frame with grid values, support, relative support and flags.

## See also

Other directional uncertainty helpers:
[`autoplot.bootstrap_stat_orbit()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/autoplot.bootstrap_stat_orbit.md),
[`autoplot.bootstrap_toroidal_ridge()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/autoplot.bootstrap_toroidal_ridge.md),
[`bootstrap_stat_orbit()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/bootstrap_stat_orbit.md),
[`bootstrap_toroidal_ridge()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/bootstrap_toroidal_ridge.md),
[`plot_marginal_support()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_marginal_support.md),
[`sensitivity_bandwidth_grid()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/sensitivity_bandwidth_grid.md),
[`simulate_independence_lineup()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/simulate_independence_lineup.md)

## Examples

``` r
dat <- simulate_cylindrical(n = 60, seed = 1)
marginal_support_data(dat$theta, n_theta = 12)
#>        theta  support relative_support low_support kappa relative_threshold
#> 1  0.2617994 4.117877        0.5616172       FALSE    20               0.15
#> 2  0.7853982 4.047707        0.5520471       FALSE    20               0.15
#> 3  1.3089969 5.720164        0.7801454       FALSE    20               0.15
#> 4  1.8325957 3.627064        0.4946777       FALSE    20               0.15
#> 5  2.3561945 7.332177        1.0000000       FALSE    20               0.15
#> 6  2.8797933 6.249973        0.8524034       FALSE    20               0.15
#> 7  3.4033920 5.291841        0.7217285       FALSE    20               0.15
#> 8  3.9269908 6.008550        0.8194770       FALSE    20               0.15
#> 9  4.4505896 7.067453        0.9638957       FALSE    20               0.15
#> 10 4.9741884 6.890080        0.9397045       FALSE    20               0.15
#> 11 5.4977871 4.728663        0.6449194       FALSE    20               0.15
#> 12 6.0213859 3.597078        0.4905880       FALSE    20               0.15
```
