# Estimate a density on the cylinder

Estimates a joint or conditional kernel density for circular-linear data
on `S1 x R`. The circular component uses von Mises weights and the
linear component uses a Gaussian kernel.

## Usage

``` r
estimate_cyl_density(
  theta,
  x,
  n_theta = 181,
  n_x = 200,
  kappa = 20,
  h = NULL,
  x_grid = NULL,
  conditional = TRUE
)
```

## Arguments

- theta:

  Angles in radians.

- x:

  Real-valued response.

- n_theta:

  Number of angular grid points.

- n_x:

  Number of linear grid points.

- kappa:

  Circular concentration for the conditioning kernel.

- h:

  Linear bandwidth. If `NULL`, a rule-of-thumb bandwidth is used.

- x_grid:

  Optional grid for the linear response.

- conditional:

  If `TRUE`, rows are normalized to estimate `f(x | theta)`.

## Value

A list with grids, a density matrix, a long data frame and smoothing
metadata.

## See also

Other cylindrical dependence helpers:
[`circular_topography_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/circular_topography_data.md),
[`phase_loom_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/phase_loom_data.md),
[`stat_orbit_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/stat_orbit_data.md)

## Examples

``` r
dat <- simulate_cylindrical(n = 80, seed = 1)
est <- estimate_cyl_density(dat$theta, dat$x, n_theta = 24, n_x = 30)
str(est$data)
#> 'data.frame':    720 obs. of  3 variables:
#>  $ theta  : num  0.131 0.393 0.654 0.916 1.178 ...
#>  $ x      : num  1.41 1.41 1.41 1.41 1.41 ...
#>  $ density: num  1.11e-10 2.88e-10 8.77e-10 1.79e-09 1.49e-09 ...
#>  - attr(*, "out.attrs")=List of 2
#>   ..$ dim     : Named int [1:2] 24 30
#>   .. ..- attr(*, "names")= chr [1:2] "theta" "x"
#>   ..$ dimnames:List of 2
#>   .. ..$ theta: chr [1:24] "theta=0.1308997" "theta=0.3926991" "theta=0.6544985" "theta=0.9162979" ...
#>   .. ..$ x    : chr [1:30] "x=1.413491" "x=1.654167" "x=1.894842" "x=2.135518" ...
```
