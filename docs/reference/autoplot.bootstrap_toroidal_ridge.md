# Plot bootstrap uncertainty for a toroidal ridge

Plot bootstrap uncertainty for a toroidal ridge

## Usage

``` r
# S3 method for class 'bootstrap_toroidal_ridge'
autoplot(
  object,
  ...,
  quantity = c("rho", "ridge"),
  base_size = 11,
  ribbon_fill = "#99d9d0",
  line_colour = "#0f766e"
)
```

## Arguments

- object:

  Object returned by
  [`bootstrap_toroidal_ridge()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/bootstrap_toroidal_ridge.md).

- ...:

  Reserved for future extensions.

- quantity:

  Either `"rho"` or `"ridge"`.

- base_size:

  Base font size.

- ribbon_fill:

  Ribbon fill colour.

- line_colour:

  Line colour.

## Value

A ggplot object.

## See also

Other directional uncertainty helpers:
[`autoplot.bootstrap_stat_orbit()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/autoplot.bootstrap_stat_orbit.md),
[`bootstrap_stat_orbit()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/bootstrap_stat_orbit.md),
[`bootstrap_toroidal_ridge()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/bootstrap_toroidal_ridge.md),
[`marginal_support_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/marginal_support_data.md),
[`plot_marginal_support()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_marginal_support.md),
[`sensitivity_bandwidth_grid()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/sensitivity_bandwidth_grid.md),
[`simulate_independence_lineup()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/simulate_independence_lineup.md)

## Examples

``` r
dat <- simulate_toroidal(n = 60, scenario = "diagonal", seed = 1)
boot <- bootstrap_toroidal_ridge(dat$theta, dat$phi, n_boot = 5, n_theta = 12, n_phi = 12, seed = 1)
ggplot2::autoplot(boot)
```
