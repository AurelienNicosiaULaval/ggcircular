# Convert Cartesian coordinates to spherical coordinates

Convert Cartesian coordinates to spherical coordinates

## Usage

``` r
cartesian_to_spherical(
  x,
  y,
  z,
  convention = c("azimuth_colatitude", "azimuth_elevation")
)
```

## Arguments

- x, y, z:

  Cartesian coordinates.

- convention:

  Output convention for `phi`.

## Value

A tibble with `theta`, `phi` and `radius`.

## See also

Other spherical helpers:
[`spherical_summary()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/spherical_summary.md),
[`spherical_to_cartesian()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/spherical_to_cartesian.md)
