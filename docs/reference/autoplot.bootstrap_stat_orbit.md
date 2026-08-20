# Plot bootstrap uncertainty for a statistical orbit

Plot bootstrap uncertainty for a statistical orbit

## Usage

``` r
# S3 method for class 'bootstrap_stat_orbit'
autoplot(
  object,
  ...,
  quantity = c("mu", "sigma"),
  base_size = 11,
  ribbon_fill = "#8fb4ff",
  line_colour = "#123f9b"
)
```

## Arguments

- object:

  Object returned by
  [`bootstrap_stat_orbit()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/bootstrap_stat_orbit.md).

- ...:

  Reserved for future extensions.

- quantity:

  Either `"mu"` or `"sigma"`.

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
[`autoplot.bootstrap_toroidal_ridge()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/autoplot.bootstrap_toroidal_ridge.md),
[`bootstrap_stat_orbit()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/bootstrap_stat_orbit.md),
[`bootstrap_toroidal_ridge()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/bootstrap_toroidal_ridge.md),
[`marginal_support_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/marginal_support_data.md),
[`plot_marginal_support()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_marginal_support.md),
[`sensitivity_bandwidth_grid()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/sensitivity_bandwidth_grid.md),
[`simulate_independence_lineup()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/simulate_independence_lineup.md)

## Examples

``` r
dat <- simulate_cylindrical(n = 60, seed = 1)
boot <- bootstrap_stat_orbit(dat$theta, dat$x, n_boot = 5, n_theta = 12, seed = 1)
ggplot2::autoplot(boot)
```
