# Simulate diagnostic circular-circular data

Simulate diagnostic circular-circular data

## Usage

``` r
simulate_tor_diagnostic(
  n = 900,
  scenario = c("independent_concentrated", "diagonal", "doubling", "bifurcation",
    "uniform_marginal_dependence"),
  seed = NULL
)
```

## Arguments

- n:

  Number of observations.

- scenario:

  Diagnostic scenario.

- seed:

  Optional random seed.

## Value

A data frame with `theta`, `phi` and `scenario`.

## See also

Other directional diagnostics:
[`autoplot.diagnostic_atlas_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/autoplot.diagnostic_atlas_data.md),
[`diagnostic_atlas_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/diagnostic_atlas_data.md),
[`diagnostic_scenarios()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/diagnostic_scenarios.md),
[`plot_classical_comparison()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_classical_comparison.md),
[`plot_diagnostic_atlas()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_diagnostic_atlas.md),
[`simulate_cyl_diagnostic()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/simulate_cyl_diagnostic.md)

## Examples

``` r
simulate_tor_diagnostic(n = 40, scenario = "diagonal", seed = 1)
#>         theta       phi scenario
#> 1  1.66824013 1.3539525 diagonal
#> 2  2.33812342 2.6051962 diagonal
#> 3  3.59934384 3.3319470 diagonal
#> 4  5.70643784 5.5897772 diagonal
#> 5  1.26720495 1.4233589 diagonal
#> 6  5.64474887 5.4311076 diagonal
#> 7  5.93556977 6.1879165 diagonal
#> 8  4.15191498 4.2755849 diagonal
#> 9  3.95284012 3.7831304 diagonal
#> 10 0.38821459 0.5547264 diagonal
#> 11 1.29417642 1.0605341 diagonal
#> 12 1.10933879 0.9478501 diagonal
#> 13 4.31669186 3.7413398 diagonal
#> 14 2.41339484 2.3473316 diagonal
#> 15 4.83705630 5.0864195 diagonal
#> 16 3.12713657 2.7287079 diagonal
#> 17 4.50893007 4.0713783 diagonal
#> 18 6.23232980 0.2169563 diagonal
#> 19 2.38783146 2.2072395 diagonal
#> 20 4.88483239 4.8789028 diagonal
#> 21 5.87292617 6.1153317 diagonal
#> 22 1.33293077 1.0501850 diagonal
#> 23 4.09458703 3.7978613 diagonal
#> 24 0.78888593 0.4021147 diagonal
#> 25 1.67899698 1.6951258 diagonal
#> 26 2.42602639 2.8157652 diagonal
#> 27 0.08413394 5.8487848 diagonal
#> 28 2.40261439 2.2788647 diagonal
#> 29 5.46442874 5.3830145 diagonal
#> 30 2.13847582 1.7961385 diagonal
#> 31 3.02899870 3.3160244 diagonal
#> 32 3.76718318 3.7329002 diagonal
#> 33 3.10101149 2.9627592 diagonal
#> 34 1.17003970 0.9519883 diagonal
#> 35 5.19853988 5.8022754 diagonal
#> 36 4.20010039 4.4031620 diagonal
#> 37 4.99035622 5.4440778 diagonal
#> 38 0.67822980 0.3886148 diagonal
#> 39 4.54720998 3.9705047 diagonal
#> 40 2.58411345 2.9645742 diagonal
```
