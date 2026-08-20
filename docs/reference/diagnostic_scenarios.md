# List built-in directional diagnostic scenarios

List built-in directional diagnostic scenarios

## Usage

``` r
diagnostic_scenarios()
```

## Value

A data frame describing the built-in diagnostic scenarios.

## See also

Other directional diagnostics:
[`autoplot.diagnostic_atlas_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/autoplot.diagnostic_atlas_data.md),
[`diagnostic_atlas_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/diagnostic_atlas_data.md),
[`plot_classical_comparison()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_classical_comparison.md),
[`plot_diagnostic_atlas()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_diagnostic_atlas.md),
[`simulate_cyl_diagnostic()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/simulate_cyl_diagnostic.md),
[`simulate_tor_diagnostic()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/simulate_tor_diagnostic.md)

## Examples

``` r
diagnostic_scenarios()
#>          space                    scenario
#> 1  cylindrical                 independent
#> 2  cylindrical                      smooth
#> 3  cylindrical             heteroscedastic
#> 4  cylindrical                  multimodal
#> 5  cylindrical                        seam
#> 6     toroidal    independent_concentrated
#> 7     toroidal                    diagonal
#> 8     toroidal                    doubling
#> 9     toroidal                 bifurcation
#> 10    toroidal uniform_marginal_dependence
#>                                                               expected
#> 1                    Same conditional distribution of x for all theta.
#> 2        Narrow conditional band following a smooth function of theta.
#> 3      Conditional spread changes with theta while the mean is stable.
#> 4        Several conditional modes may make the local mean misleading.
#> 5       Structure crosses the 0/2pi seam and should remain continuous.
#> 6                  Same conditional distribution of phi for all theta.
#> 7                        Diagonal ridge: phi follows theta modulo 2pi.
#> 8              Wrapped nonlinear ridge: phi follows 2theta modulo 2pi.
#> 9                  Two conditional branches create ridge bifurcations.
#> 10 Marginals can be near uniform while conditional dependence remains.
```
