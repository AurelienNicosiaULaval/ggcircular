# Plot angular marginal support

Plot angular marginal support

## Usage

``` r
plot_marginal_support(
  theta,
  grid = NULL,
  n_theta = 181,
  kappa = 20,
  relative_threshold = 0.15,
  base_size = 11
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

  Relative support threshold used to flag low-support regions.

- base_size:

  Base font size.

## Value

A ggplot object.

## See also

Other directional uncertainty helpers:
[`autoplot.bootstrap_stat_orbit()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/autoplot.bootstrap_stat_orbit.md),
[`autoplot.bootstrap_toroidal_ridge()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/autoplot.bootstrap_toroidal_ridge.md),
[`bootstrap_stat_orbit()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/bootstrap_stat_orbit.md),
[`bootstrap_toroidal_ridge()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/bootstrap_toroidal_ridge.md),
[`marginal_support_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/marginal_support_data.md),
[`sensitivity_bandwidth_grid()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/sensitivity_bandwidth_grid.md),
[`simulate_independence_lineup()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/simulate_independence_lineup.md)

## Examples

``` r
dat <- simulate_cylindrical(n = 60, seed = 1)
plot_marginal_support(dat$theta, n_theta = 12)
```
