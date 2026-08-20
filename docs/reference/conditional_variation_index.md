# Conditional variation index

Computes a simple squared variation summary for a matrix of conditional
densities across conditioning-grid rows.

## Usage

``` r
conditional_variation_index(density_matrix)
```

## Arguments

- density_matrix:

  Matrix with rows representing conditioning-grid values and columns
  representing conditional density values.

## Value

A non-negative numeric scalar.

## See also

Other directional dependence indicators:
[`alignment_index()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/alignment_index.md),
[`local_circ_moment()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/local_circ_moment.md)

## Examples

``` r
dat <- simulate_toroidal(n = 80, seed = 1)
est <- estimate_toroidal_density(dat$theta, dat$phi, n_theta = 12, n_phi = 12, conditional = TRUE)
conditional_variation_index(est$density)
#> [1] 0.8478339
```
