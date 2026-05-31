# Rayleigh test for circular uniformity

Performs the one-sample Rayleigh test for non-uniformity. The returned
object follows the base `htest` structure.

## Usage

``` r
rayleigh_test(x, axial = FALSE, na.rm = TRUE)
```

## Arguments

- x:

  Numeric vector of angles in radians.

- axial:

  Should data be treated as axial, modulo `pi`?

- na.rm:

  Should missing values be removed?

## Value

An object of class `htest`.

## See also

Other circular tests:
[`stat_circular_test()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/stat_circular_test.md),
[`watson_williams_test()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/watson_williams_test.md)
