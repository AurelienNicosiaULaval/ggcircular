# Compute a conditional toroidal ridge

Extracts the modal `phi` value along a grid of conditioning angles and
attaches the local circular concentration.

## Usage

``` r
toroidal_ridge_data(
  theta,
  phi,
  n_theta = 181,
  n_phi = 181,
  kappa_theta = 20,
  kappa_phi = 20,
  tie_tolerance = 0.01
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

- tie_tolerance:

  Relative tolerance used to flag two distinct local maxima as
  near-tied. The selected ridge remains the first exact grid maximum for
  backward compatibility.

## Value

A data frame with columns `theta`, `phi`, `rho`, `ridge_group`,
`n_local_modes`, `secondary_mode_ratio` and `ridge_ambiguous`.

## See also

Other toroidal dependence helpers:
[`estimate_toroidal_density()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/estimate_toroidal_density.md),
[`toroidal_flow_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/toroidal_flow_data.md),
[`toroidal_topography_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/toroidal_topography_data.md)

## Examples

``` r
dat <- simulate_toroidal(n = 80, scenario = "diagonal", seed = 1)
toroidal_ridge_data(dat$theta, dat$phi, n_theta = 24, n_phi = 24)
#>        theta       phi       rho ridge_group n_local_modes secondary_mode_ratio
#> 1  0.1308997 0.6544985 0.8773161           1             2            0.9124515
#> 2  0.3926991 0.3926991 0.9290955           1             2            0.1915401
#> 3  0.6544985 0.6544985 0.9659109           1             1                   NA
#> 4  0.9162979 0.6544985 0.9281805           1             1                   NA
#> 5  1.1780972 1.4398966 0.9347777           1             1                   NA
#> 6  1.4398966 1.4398966 0.9369439           1             2            0.1334134
#> 7  1.7016960 1.4398966 0.9084594           1             2            0.4926221
#> 8  1.9634954 2.2252948 0.9221946           1             1                   NA
#> 9  2.2252948 2.2252948 0.9663859           1             1                   NA
#> 10 2.4870942 2.2252948 0.9569966           1             1                   NA
#> 11 2.7488936 2.7488936 0.9085508           1             2            0.7619745
#> 12 3.0106930 3.0106930 0.9469863           1             1                   NA
#> 13 3.2724923 3.0106930 0.9648213           1             1                   NA
#> 14 3.5342917 3.0106930 0.9439305           1             1                   NA
#> 15 3.7960911 3.7960911 0.8936598           1             2            0.4244847
#> 16 4.0578905 4.0578905 0.9501667           1             1                   NA
#> 17 4.3196899 4.0578905 0.9538950           1             1                   NA
#> 18 4.5814893 4.5814893 0.9354493           1             1                   NA
#> 19 4.8432887 4.5814893 0.9403187           1             1                   NA
#> 20 5.1050881 4.8432887 0.9294776           1             1                   NA
#> 21 5.3668874 5.3668874 0.9338653           1             1                   NA
#> 22 5.6286868 5.6286868 0.9261024           1             1                   NA
#> 23 5.8904862 5.6286868 0.9226128           1             1                   NA
#> 24 6.1522856 5.8904862 0.8951724           1             2            0.3111980
#>    ridge_ambiguous
#> 1            FALSE
#> 2            FALSE
#> 3            FALSE
#> 4            FALSE
#> 5            FALSE
#> 6            FALSE
#> 7            FALSE
#> 8            FALSE
#> 9            FALSE
#> 10           FALSE
#> 11           FALSE
#> 12           FALSE
#> 13           FALSE
#> 14           FALSE
#> 15           FALSE
#> 16           FALSE
#> 17           FALSE
#> 18           FALSE
#> 19           FALSE
#> 20           FALSE
#> 21           FALSE
#> 22           FALSE
#> 23           FALSE
#> 24           FALSE
```
