# Watson-Williams test for equal circular means

Wrapper around
[`circular::watson.williams.test()`](https://rdrr.io/pkg/circular/man/watson.williams.test.html)
with explicit optional dependency handling.

## Usage

``` r
watson_williams_test(x, group, ...)
```

## Arguments

- x:

  Numeric vector of angles in radians.

- group:

  Grouping variable.

- ...:

  Additional arguments passed to
  [`circular::watson.williams.test()`](https://rdrr.io/pkg/circular/man/watson.williams.test.html).

## Value

An object returned by
[`circular::watson.williams.test()`](https://rdrr.io/pkg/circular/man/watson.williams.test.html).

## See also

Other circular tests:
[`rayleigh_test()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/rayleigh_test.md),
[`stat_circular_test()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/stat_circular_test.md)
