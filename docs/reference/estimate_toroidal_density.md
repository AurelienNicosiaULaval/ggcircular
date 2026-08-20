# Estimate a density on the torus

Estimates a joint or conditional kernel density for circular-circular
data on `S1 x S1`. Both components use von Mises weights.

## Usage

``` r
estimate_toroidal_density(
  theta,
  phi,
  n_theta = 181,
  n_phi = 181,
  kappa_theta = 20,
  kappa_phi = 20,
  conditional = FALSE
)
```

## Arguments

- theta:

  First angle in radians.

- phi:

  Second angle in radians.

- n_theta:

  Number of theta grid points.

- n_phi:

  Number of phi grid points.

- kappa_theta:

  Kernel concentration for `theta`.

- kappa_phi:

  Kernel concentration for `phi`.

- conditional:

  If `TRUE`, rows are normalized to estimate `f(phi | theta)`.

## Value

A list with grids, a density matrix, a long data frame and smoothing
metadata.

## See also

Other toroidal dependence helpers:
[`toroidal_flow_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/toroidal_flow_data.md),
[`toroidal_ridge_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/toroidal_ridge_data.md),
[`toroidal_topography_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/toroidal_topography_data.md)

## Examples

``` r
dat <- simulate_toroidal(n = 80, seed = 1)
est <- estimate_toroidal_density(dat$theta, dat$phi, n_theta = 24, n_phi = 24)
str(est$data)
#> 'data.frame':    576 obs. of  3 variables:
#>  $ theta  : num  0.131 0.393 0.654 0.916 1.178 ...
#>  $ phi    : num  0.131 0.131 0.131 0.131 0.131 ...
#>  $ density: num  3.43e-03 2.19e-03 8.09e-04 1.41e-04 9.08e-06 ...
#>  - attr(*, "out.attrs")=List of 2
#>   ..$ dim     : Named int [1:2] 24 24
#>   .. ..- attr(*, "names")= chr [1:2] "theta" "phi"
#>   ..$ dimnames:List of 2
#>   .. ..$ theta: chr [1:24] "theta=0.1308997" "theta=0.3926991" "theta=0.6544985" "theta=0.9162979" ...
#>   .. ..$ phi  : chr [1:24] "phi=0.1308997" "phi=0.3926991" "phi=0.6544985" "phi=0.9162979" ...
```
