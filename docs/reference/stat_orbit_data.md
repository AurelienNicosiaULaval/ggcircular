# Compute statistical orbit data

Computes local conditional means, local standard deviations and local
skewness over an angular grid.

## Usage

``` r
stat_orbit_data(theta, x, n_theta = 181, kappa = 20)
```

## Arguments

- theta:

  Angles in radians.

- x:

  Real-valued response.

- n_theta:

  Number of angular grid points.

- kappa:

  Circular concentration for local weighting.

## Value

A data frame with `theta`, `mu`, `lower`, `upper` and `skew`.

## See also

Other cylindrical dependence helpers:
[`circular_topography_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/circular_topography_data.md),
[`estimate_cyl_density()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/estimate_cyl_density.md),
[`phase_loom_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/phase_loom_data.md)

## Examples

``` r
dat <- simulate_cylindrical(n = 80, seed = 1)
stat_orbit_data(dat$theta, dat$x, n_theta = 24)
#>        theta       mu    lower    upper        skew
#> 1  0.1308997 6.109261 5.426799 6.791724  0.09327799
#> 2  0.3926991 5.936562 5.317865 6.555258  0.10928619
#> 3  0.6544985 5.553232 5.007562 6.098902  0.86101048
#> 4  0.9162979 5.305150 4.869064 5.741235  1.60966720
#> 5  1.1780972 5.568455 4.953468 6.183442  0.95796430
#> 6  1.4398966 6.066295 5.346491 6.786098  0.35570985
#> 7  1.7016960 6.180261 5.460777 6.899744  0.23638311
#> 8  1.9634954 5.753430 5.009934 6.496925  0.40130470
#> 9  2.2252948 5.396750 4.643516 6.149985  0.51152416
#> 10 2.4870942 5.006149 4.323744 5.688555  0.77287060
#> 11 2.7488936 4.619345 4.033169 5.205522  0.59393876
#> 12 3.0106930 4.375935 3.770981 4.980889 -0.39638283
#> 13 3.2724923 3.985440 3.081460 4.889420 -0.61573460
#> 14 3.5342917 3.058546 2.086662 4.030430  0.48803545
#> 15 3.7960911 2.546310 1.942418 3.150203  0.85584695
#> 16 4.0578905 2.768620 2.114566 3.422675  0.59307268
#> 17 4.3196899 3.373713 2.449836 4.297590  0.47784651
#> 18 4.5814893 4.605818 3.541067 5.670569 -0.27907806
#> 19 4.8432887 5.453124 4.799142 6.107106 -1.09871040
#> 20 5.1050881 5.573448 5.055754 6.091142  0.38752733
#> 21 5.3668874 5.814592 5.183932 6.445251  0.63068223
#> 22 5.6286868 6.128596 5.435069 6.822124  0.93338377
#> 23 5.8904862 6.423608 5.651618 7.195598  0.71129651
#> 24 6.1522856 6.322387 5.575921 7.068853  0.48322612
#> 25 6.2831853 6.175844 5.459647 6.892040  0.31345358
```
