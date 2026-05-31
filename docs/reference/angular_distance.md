# Circular angular distance

Computes the non-negative angular distance between `x` and `y`. With the
default period, values are returned in `[0, pi]`.

## Usage

``` r
angular_distance(x, y, period = 2 * pi)
```

## Arguments

- x, y:

  Numeric vectors of angles.

- period:

  Positive numeric period.

## Value

A non-negative numeric vector.

## See also

Other angle utilities:
[`angular_difference()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/angular_difference.md),
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
angular_distance(0, 3 * pi / 2)
#> [1] 1.570796
```
