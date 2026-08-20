# Simulate circular-linear data

Simulates examples on the cylinder, where `theta` is an angle in radians
and `x` is a real-valued response.

## Usage

``` r
simulate_cylindrical(
  n = 500,
  scenario = c("nonlinear", "independent", "unimodal", "heteroscedastic", "multimodal"),
  seed = NULL
)
```

## Arguments

- n:

  Number of observations.

- scenario:

  Dependence pattern to simulate.

- seed:

  Optional random seed.

## Value

A data frame with columns `theta`, `x` and `scenario`.

## See also

Other directional simulation helpers:
[`simulate_toroidal()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/simulate_toroidal.md)

## Examples

``` r
simulate_cylindrical(n = 30, scenario = "nonlinear", seed = 1)
#>         theta        x  scenario
#> 1  1.66824013 6.281755 nonlinear
#> 2  2.33812342 5.058780 nonlinear
#> 3  3.59934384 3.290647 nonlinear
#> 4  5.70643784 6.629403 nonlinear
#> 5  1.26720495 6.194429 nonlinear
#> 6  5.64474887 6.601926 nonlinear
#> 7  5.93556977 6.943293 nonlinear
#> 8  4.15191498 2.830456 nonlinear
#> 9  3.95284012 1.054950 nonlinear
#> 10 0.38821459 6.056568 nonlinear
#> 11 1.29417642 5.834908 nonlinear
#> 12 1.10933879 5.329143 nonlinear
#> 13 4.31669186 2.443945 nonlinear
#> 14 2.41339484 4.636504 nonlinear
#> 15 4.83705630 5.544576 nonlinear
#> 16 3.12713657 4.960376 nonlinear
#> 17 4.50893007 4.151707 nonlinear
#> 18 6.23232980 6.797298 nonlinear
#> 19 2.38783146 4.951163 nonlinear
#> 20 4.88483239 4.468103 nonlinear
#> 21 5.87292617 6.080940 nonlinear
#> 22 1.33293077 5.701702 nonlinear
#> 23 4.09458703 2.575884 nonlinear
#> 24 0.78888593 5.726256 nonlinear
#> 25 1.67899698 6.803189 nonlinear
#> 26 2.42602639 4.822153 nonlinear
#> 27 0.08413394 6.216745 nonlinear
#> 28 2.40261439 5.416379 nonlinear
#> 29 5.46442874 6.156981 nonlinear
#> 30 2.13847582 5.042930 nonlinear
```
