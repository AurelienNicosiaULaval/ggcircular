# Alignment index for two angular variables

Computes `|mean(exp(i * (phi - theta)))|`, a scalar summary of circular
alignment between two angular variables.

## Usage

``` r
alignment_index(theta, phi)
```

## Arguments

- theta:

  First angle in radians.

- phi:

  Second angle in radians.

## Value

A numeric scalar between 0 and 1.

## See also

Other directional dependence indicators:
[`conditional_variation_index()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/conditional_variation_index.md),
[`local_circ_moment()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/local_circ_moment.md)

## Examples

``` r
dat <- simulate_toroidal(n = 80, scenario = "diagonal", seed = 1)
alignment_index(dat$theta, dat$phi)
#> [1] 0.9545508
```
