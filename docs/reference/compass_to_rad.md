# Convert compass labels to radians

Converts the eight standard compass labels `N`, `NE`, `E`, `SE`, `S`,
`SW`, `W` and `NW` to bearing angles in radians, where zero is north and
angles increase clockwise.

## Usage

``` r
compass_to_rad(x)
```

## Arguments

- x:

  Character vector of compass labels.

## Value

Numeric vector of bearing angles in radians.

## See also

Other angle utilities:
[`angular_difference()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/angular_difference.md),
[`angular_distance()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/angular_distance.md),
[`check_angle()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/check_angle.md),
[`deg_to_rad()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/deg_to_rad.md),
[`hour_to_rad()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/hour_to_rad.md),
[`is_angle()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/is_angle.md),
[`normalize_angle()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/normalize_angle.md),
[`rad_to_compass()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/rad_to_compass.md),
[`rad_to_deg()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/rad_to_deg.md),
[`rad_to_hour()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/rad_to_hour.md)

## Examples

``` r
compass_to_rad(c("N", "E", "S", "W"))
#> [1] 0.000000 1.570796 3.141593 4.712389
```
