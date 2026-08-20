# Simulate diagnostic circular-linear data

Simulate diagnostic circular-linear data

## Usage

``` r
simulate_cyl_diagnostic(
  n = 800,
  scenario = c("independent", "smooth", "heteroscedastic", "multimodal", "seam"),
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

A data frame with `theta`, `x` and `scenario`.

## See also

Other directional diagnostics:
[`autoplot.diagnostic_atlas_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/autoplot.diagnostic_atlas_data.md),
[`diagnostic_atlas_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/diagnostic_atlas_data.md),
[`diagnostic_scenarios()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/diagnostic_scenarios.md),
[`plot_classical_comparison()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_classical_comparison.md),
[`plot_diagnostic_atlas()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_diagnostic_atlas.md),
[`simulate_tor_diagnostic()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/simulate_tor_diagnostic.md)

## Examples

``` r
simulate_cyl_diagnostic(n = 40, scenario = "smooth", seed = 1)
#>         theta        x scenario
#> 1  1.66824013 3.270595   smooth
#> 2  2.33812342 2.520929   smooth
#> 3  3.59934384 2.422176   smooth
#> 4  5.70643784 2.800610   smooth
#> 5  1.26720495 3.788633   smooth
#> 6  5.64474887 3.261412   smooth
#> 7  5.93556977 3.616537   smooth
#> 8  4.15191498 2.041517   smooth
#> 9  3.95284012 2.313467   smooth
#> 10 0.38821459 4.401275   smooth
#> 11 1.29417642 3.956145   smooth
#> 12 1.10933879 3.803893   smooth
#> 13 4.31669186 2.564539   smooth
#> 14 2.41339484 2.249672   smooth
#> 15 4.83705630 2.163761   smooth
#> 16 3.12713657 2.155049   smooth
#> 17 4.50893007 2.357716   smooth
#> 18 6.23232980 3.993828   smooth
#> 19 2.38783146 2.584349   smooth
#> 20 4.88483239 2.784132   smooth
#> 21 5.87292617 3.532088   smooth
#> 22 1.33293077 3.447422   smooth
#> 23 4.09458703 2.647553   smooth
#> 24 0.78888593 4.321806   smooth
#> 25 1.67899698 2.804790   smooth
#> 26 2.42602639 2.061289   smooth
#> 27 0.08413394 4.235575   smooth
#> 28 2.40261439 2.484693   smooth
#> 29 5.46442874 3.022617   smooth
#> 30 2.13847582 2.692273   smooth
#> 31 3.02899870 2.356295   smooth
#> 32 3.76718318 2.258802   smooth
#> 33 3.10101149 2.359405   smooth
#> 34 1.17003970 3.435799   smooth
#> 35 5.19853988 3.181887   smooth
#> 36 4.20010039 3.008441   smooth
#> 37 4.99035622 2.524180   smooth
#> 38 0.67822980 3.942742   smooth
#> 39 4.54720998 2.632375   smooth
#> 40 2.58411345 2.175314   smooth
```
