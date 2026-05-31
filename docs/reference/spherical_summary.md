# Summarize spherical directions

Computes the mean direction vector and mean spherical coordinates.

## Usage

``` r
spherical_summary(
  theta,
  phi,
  weights = NULL,
  convention = c("azimuth_colatitude", "azimuth_elevation"),
  na.rm = TRUE
)
```

## Arguments

- theta:

  Azimuth angle in radians.

- phi:

  Colatitude or elevation angle in radians.

- weights:

  Optional non-negative weights.

- convention:

  Interpretation of `phi`.

- na.rm:

  Should missing values be removed?

## Value

A tibble with sample size, mean spherical coordinates and resultant
length.

## See also

Other spherical helpers:
[`cartesian_to_spherical()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/cartesian_to_spherical.md),
[`spherical_to_cartesian()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/spherical_to_cartesian.md)
