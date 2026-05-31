# Circular model helper generics

Lightweight generics reserved for future integration with angular
regression packages. The default methods fail with an explicit message
rather than silently returning incomplete output.

## Usage

``` r
augment_circular(x, ...)

tidy_circular(x, ...)

glance_circular(x, ...)
```

## Arguments

- x:

  A model or circular object.

- ...:

  Additional arguments passed to methods.

## Value

Method-dependent tibble output.

## See also

Other circular model helpers:
[`circular_model_diagnostics()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/circular_model_diagnostics.md),
[`circular_residuals()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/circular_residuals.md)
