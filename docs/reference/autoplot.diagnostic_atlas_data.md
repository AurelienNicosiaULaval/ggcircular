# Plot diagnostic atlas data

Plot diagnostic atlas data

## Usage

``` r
# S3 method for class 'diagnostic_atlas_data'
autoplot(
  object,
  ...,
  point_alpha = 0.2,
  point_size = 0.7,
  smooth = TRUE,
  base_size = 11
)
```

## Arguments

- object:

  Object returned by
  [`diagnostic_atlas_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/diagnostic_atlas_data.md).

- ...:

  Reserved for future extensions.

- point_alpha:

  Point transparency.

- point_size:

  Point size.

- smooth:

  Should a loess smooth be added for cylindrical data?

- base_size:

  Base font size.

## Value

A ggplot object.

## See also

Other directional diagnostics:
[`diagnostic_atlas_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/diagnostic_atlas_data.md),
[`diagnostic_scenarios()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/diagnostic_scenarios.md),
[`plot_classical_comparison()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_classical_comparison.md),
[`plot_diagnostic_atlas()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_diagnostic_atlas.md),
[`simulate_cyl_diagnostic()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/simulate_cyl_diagnostic.md),
[`simulate_tor_diagnostic()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/simulate_tor_diagnostic.md)

## Examples

``` r
atlas <- diagnostic_atlas_data("cylindrical", n = 20, seed = 1)
ggplot2::autoplot(atlas)
```
