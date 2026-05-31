# Circular x scales

These scales label angular x axes in radians, degrees, hours or compass
directions.

## Usage

``` r
scale_x_circular_radians(
  breaks = ggplot2::waiver(),
  labels = ggplot2::waiver(),
  limits = c(0, 2 * pi),
  ...
)

scale_x_circular_degrees(
  breaks = ggplot2::waiver(),
  labels = ggplot2::waiver(),
  limits = c(0, 2 * pi),
  ...
)

scale_x_circular_hours(
  breaks = ggplot2::waiver(),
  labels = ggplot2::waiver(),
  limits = c(0, 2 * pi),
  ...
)

scale_x_circular_compass(
  breaks = ggplot2::waiver(),
  labels = ggplot2::waiver(),
  limits = c(0, 2 * pi),
  ...
)
```

## Arguments

- breaks:

  Break positions in radians.

- labels:

  Break labels.

- limits:

  Scale limits in radians.

- ...:

  Additional arguments passed to
  [`ggplot2::scale_x_continuous()`](https://ggplot2.tidyverse.org/reference/scale_continuous.html).

## Value

A ggplot2 scale.

## See also

Other circular scales:
[`coord_circular()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/coord_circular.md)

## Examples

``` r
scale_x_circular_radians()
#> <ScaleContinuousPosition>
#>  Range:  
#>  Limits:    0 -- 6.28
```
