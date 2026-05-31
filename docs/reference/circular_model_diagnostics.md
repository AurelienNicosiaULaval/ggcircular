# Circular model diagnostics

Summarizes circular residual diagnostics for supported angular model
objects.

## Usage

``` r
circular_model_diagnostics(object, data = NULL, ...)
```

## Arguments

- object:

  A supported angular model object.

- data:

  Optional data frame to bind to the diagnostic columns.

- ...:

  Reserved for future methods.

## Value

A tibble with residual mean direction, resultant length, circular
variance and maximum absolute circular residual.

## See also

Other circular model helpers:
[`augment_circular()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/augment_circular.md),
[`circular_residuals()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/circular_residuals.md)
