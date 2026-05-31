# Convert radians to compass labels

Converts angles to the nearest label among `labels`. Angles are
interpreted as bearings by default: zero is north and angles increase
clockwise.

## Usage

``` r
rad_to_compass(x, labels = c("N", "NE", "E", "SE", "S", "SW", "W", "NW"))
```

## Arguments

- x:

  Numeric vector of angles in radians.

- labels:

  Character vector of equally spaced labels.

## Value

Character vector of labels.

## See also

Other angle utilities:
[`angular_difference()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/angular_difference.md),
[`angular_distance()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/angular_distance.md),
[`check_angle()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/check_angle.md),
[`compass_to_rad()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/compass_to_rad.md),
[`deg_to_rad()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/deg_to_rad.md),
[`hour_to_rad()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/hour_to_rad.md),
[`is_angle()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/is_angle.md),
[`normalize_angle()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/normalize_angle.md),
[`rad_to_deg()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/rad_to_deg.md),
[`rad_to_hour()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/rad_to_hour.md)

## Examples

``` r
rad_to_compass(c(0, pi / 2, pi))
#> [1] "N" "E" "S"
```
