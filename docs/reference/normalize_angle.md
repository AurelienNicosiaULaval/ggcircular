# Normalize angles to a periodic interval

`normalize_angle()` maps numeric angles to `[origin, origin + period)`.
The default period is `2 * pi`, which is appropriate for directional
circular data measured in radians.

## Usage

``` r
normalize_angle(x, period = 2 * pi, origin = 0)
```

## Arguments

- x:

  Numeric vector of angles.

- period:

  Positive numeric period. Use `2 * pi` for directional data and `pi`
  for axial data.

- origin:

  Lower bound of the target interval.

## Value

A numeric vector with the same length as `x`.

## See also

Other angle utilities:
[`angular_difference()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/angular_difference.md),
[`angular_distance()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/angular_distance.md),
[`check_angle()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/check_angle.md),
[`compass_to_rad()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/compass_to_rad.md),
[`deg_to_rad()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/deg_to_rad.md),
[`hour_to_rad()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/hour_to_rad.md),
[`is_angle()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/is_angle.md),
[`rad_to_compass()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/rad_to_compass.md),
[`rad_to_deg()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/rad_to_deg.md),
[`rad_to_hour()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/rad_to_hour.md)

## Examples

``` r
normalize_angle(c(-pi, 0, 3 * pi))
#> [1] 3.141593 0.000000 3.141593
```
