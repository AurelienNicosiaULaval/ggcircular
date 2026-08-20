# Plot a diagnostic atlas

Plot a diagnostic atlas

## Usage

``` r
plot_diagnostic_atlas(
  space = c("cylindrical", "toroidal"),
  n = 600,
  seed = 20260609
)
```

## Arguments

- space:

  Either `"cylindrical"` or `"toroidal"`.

- n:

  Number of observations per scenario.

- seed:

  Optional random seed.

## Value

A ggplot object.

## See also

Other directional diagnostics:
[`autoplot.diagnostic_atlas_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/autoplot.diagnostic_atlas_data.md),
[`diagnostic_atlas_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/diagnostic_atlas_data.md),
[`diagnostic_scenarios()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/diagnostic_scenarios.md),
[`plot_classical_comparison()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_classical_comparison.md),
[`simulate_cyl_diagnostic()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/simulate_cyl_diagnostic.md),
[`simulate_tor_diagnostic()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/simulate_tor_diagnostic.md)

## Examples

``` r
plot_diagnostic_atlas("toroidal", n = 20, seed = 1)
```
