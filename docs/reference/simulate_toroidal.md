# Simulate circular-circular data

Simulates examples on the torus, where both `theta` and `phi` are angles
in radians.

## Usage

``` r
simulate_toroidal(
  n = 500,
  scenario = c("nonlinear", "diagonal", "anti_diagonal", "multimodal", "independent"),
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

A data frame with columns `theta`, `phi` and `scenario`.

## See also

Other directional simulation helpers:
[`simulate_cylindrical()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/simulate_cylindrical.md)

## Examples

``` r
simulate_toroidal(n = 30, scenario = "diagonal", seed = 1)
#>         theta       phi scenario
#> 1  1.66824013 1.3372684 diagonal
#> 2  2.33812342 2.4444432 diagonal
#> 3  3.59934384 4.5701674 diagonal
#> 4  5.70643784 5.9713122 diagonal
#> 5  1.26720495 0.8839489 diagonal
#> 6  5.64474887 5.9707947 diagonal
#> 7  5.93556977 5.6091308 diagonal
#> 8  4.15191498 4.0091548 diagonal
#> 9  3.95284012 4.1438438 diagonal
#> 10 0.38821459 0.1271232 diagonal
#> 11 1.29417642 1.6023411 diagonal
#> 12 1.10933879 1.2606657 diagonal
#> 13 4.31669186 4.1091451 diagonal
#> 14 2.41339484 2.6170397 diagonal
#> 15 4.83705630 4.5516268 diagonal
#> 16 3.12713657 2.9296214 diagonal
#> 17 4.50893007 3.8137782 diagonal
#> 18 6.23232980 6.1514558 diagonal
#> 19 2.38783146 2.6923713 diagonal
#> 20 4.88483239 4.4001500 diagonal
#> 21 5.87292617 5.3413493 diagonal
#> 22 1.33293077 1.6598735 diagonal
#> 23 4.09458703 3.8737666 diagonal
#> 24 0.78888593 0.7816257 diagonal
#> 25 1.67899698 1.9750814 diagonal
#> 26 2.42602639 2.0809687 diagonal
#> 27 0.08413394 6.0053206 diagonal
#> 28 2.40261439 1.9319395 diagonal
#> 29 5.46442874 5.4841768 diagonal
#> 30 2.13847582 2.6127180 diagonal
```
