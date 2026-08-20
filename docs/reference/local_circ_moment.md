# Local circular moment

Computes a kernel-weighted local circular moment of `phi` conditional on
`theta`.

## Usage

``` r
local_circ_moment(theta, phi, grid = NULL, kappa = 20)
```

## Arguments

- theta:

  Conditioning angles in radians.

- phi:

  Target angles in radians.

- grid:

  Optional angular grid. If `NULL`, a default grid is used.

- kappa:

  Circular concentration for local weighting.

## Value

A data frame with local real and imaginary components, mean direction
`mu`, and local concentration `rho`.

## See also

Other directional dependence indicators:
[`alignment_index()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/alignment_index.md),
[`conditional_variation_index()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/conditional_variation_index.md)

## Examples

``` r
dat <- simulate_toroidal(n = 80, scenario = "diagonal", seed = 1)
local_circ_moment(dat$theta, dat$phi, grid = seq(0, 2 * pi, length.out = 12))
#>        theta         re           im        mu       rho
#> 1  0.0000000  0.8760220 -0.080024545 6.1920882 0.8796695
#> 2  0.5711987  0.8223242  0.498038315 0.5445615 0.9613840
#> 3  1.1423973  0.3044075  0.879885168 1.2377226 0.9310542
#> 4  1.7135960 -0.1739165  0.890452912 1.7636805 0.9072780
#> 5  2.2847947 -0.5984524  0.762290583 2.2363679 0.9691400
#> 6  2.8559933 -0.8837242  0.263314267 2.8520087 0.9221187
#> 7  3.4271920 -0.9637037 -0.004254778 3.1460077 0.9637131
#> 8  3.9983907 -0.6061235 -0.721007460 4.0133412 0.9419328
#> 9  4.5695893 -0.2766743 -0.893855862 4.4122131 0.9356960
#> 10 5.1407880  0.2759762 -0.887319286 5.0139272 0.9292461
#> 11 5.7119866  0.6841353 -0.622419291 5.5449878 0.9249037
#> 12 0.0000000  0.8760220 -0.080024545 6.1920882 0.8796695
```
