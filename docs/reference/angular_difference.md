# Signed angular difference

Computes the signed difference `x - y` on a periodic scale. With the
default period, values are returned in `[-pi, pi)`.

## Usage

``` r
angular_difference(x, y, period = 2 * pi)
```

## Arguments

- x, y:

  Numeric vectors of angles.

- period:

  Positive numeric period.

## Value

A numeric vector following R recycling rules.

## See also

Other angle utilities:
[`angular_distance()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/angular_distance.md),
[`check_angle()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/check_angle.md),
[`compass_to_rad()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/compass_to_rad.md),
[`deg_to_rad()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/deg_to_rad.md),
[`hour_to_rad()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/hour_to_rad.md),
[`is_angle()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/is_angle.md),
[`normalize_angle()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/normalize_angle.md),
[`rad_to_compass()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/rad_to_compass.md),
[`rad_to_deg()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/rad_to_deg.md),
[`rad_to_hour()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/rad_to_hour.md)

## Examples

``` r
angular_difference(0, 3 * pi / 2)
#> [1] 1.570796
```
