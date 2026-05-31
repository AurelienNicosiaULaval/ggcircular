# Convert spherical coordinates to Cartesian coordinates

Convert spherical coordinates to Cartesian coordinates

## Usage

``` r
spherical_to_cartesian(
  theta,
  phi,
  radius = 1,
  convention = c("azimuth_colatitude", "azimuth_elevation")
)
```

## Arguments

- theta:

  Azimuth angle in radians.

- phi:

  Colatitude or elevation angle in radians.

- radius:

  Radius.

- convention:

  Interpretation of `phi`.

## Value

A tibble with `x`, `y` and `z`.

## See also

Other spherical helpers:
[`cartesian_to_spherical()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/cartesian_to_spherical.md),
[`spherical_summary()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/spherical_summary.md)
