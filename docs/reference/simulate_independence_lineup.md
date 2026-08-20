# Simulate a visual-inference lineup under independence

Simulate a visual-inference lineup under independence

## Usage

``` r
simulate_independence_lineup(
  data,
  plot_fun = NULL,
  m = 20,
  seed = NULL,
  space = c("cylindrical", "toroidal"),
  ...
)
```

## Arguments

- data:

  Data frame containing `theta` and either `x` or `phi`.

- plot_fun:

  Optional function taking one data frame and returning a ggplot object.

- m:

  Number of lineup panels.

- seed:

  Optional random seed.

- space:

  Either `"cylindrical"` or `"toroidal"`.

- ...:

  Passed to the default plot function when `plot_fun` is `NULL`.

## Value

A list with plots, true position and metadata. The returned object has
class `directional_lineup`.

## See also

Other directional uncertainty helpers:
[`autoplot.bootstrap_stat_orbit()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/autoplot.bootstrap_stat_orbit.md),
[`autoplot.bootstrap_toroidal_ridge()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/autoplot.bootstrap_toroidal_ridge.md),
[`bootstrap_stat_orbit()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/bootstrap_stat_orbit.md),
[`bootstrap_toroidal_ridge()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/bootstrap_toroidal_ridge.md),
[`marginal_support_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/marginal_support_data.md),
[`plot_marginal_support()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_marginal_support.md),
[`sensitivity_bandwidth_grid()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/sensitivity_bandwidth_grid.md)

## Examples

``` r
dat <- simulate_cyl_diagnostic(n = 40, scenario = "smooth", seed = 1)
lineup <- simulate_independence_lineup(
  dat,
  plot_fun = function(d) ggplot2::ggplot(d, ggplot2::aes(theta, x)) + ggplot2::geom_point(),
  m = 4,
  seed = 1,
  space = "cylindrical"
)
length(lineup$plots)
#> [1] 4
```
