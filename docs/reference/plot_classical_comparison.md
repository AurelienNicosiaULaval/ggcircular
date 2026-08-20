# Plot a classical unfolded comparison

Plot a classical unfolded comparison

## Usage

``` r
plot_classical_comparison(data, space = c("cylindrical", "toroidal"))
```

## Arguments

- data:

  Data frame containing `theta` and either `x` or `phi`.

- space:

  Either `"cylindrical"` or `"toroidal"`.

## Value

A ggplot object.

## See also

Other directional diagnostics:
[`autoplot.diagnostic_atlas_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/autoplot.diagnostic_atlas_data.md),
[`diagnostic_atlas_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/diagnostic_atlas_data.md),
[`diagnostic_scenarios()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/diagnostic_scenarios.md),
[`plot_diagnostic_atlas()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_diagnostic_atlas.md),
[`simulate_cyl_diagnostic()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/simulate_cyl_diagnostic.md),
[`simulate_tor_diagnostic()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/simulate_tor_diagnostic.md)

## Examples

``` r
dat <- simulate_cyl_diagnostic(n = 40, scenario = "smooth", seed = 1)
plot_classical_comparison(dat, "cylindrical")
```
