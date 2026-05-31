# Circular residuals for angular models

Extracts observed angles, fitted angles and signed circular residuals
from supported angular model objects. The function currently supports
objects produced by the optional `CircularRegression` package when their
fitted values are stored in a `mui` component.

## Usage

``` r
circular_residuals(object, data = NULL, ...)
```

## Arguments

- object:

  A supported angular model object.

- data:

  Optional data frame to bind to the diagnostic columns.

- ...:

  Reserved for future methods.

## Value

A tibble with `.observed`, `.fitted`, `.resid`, `.abs_resid`, `.index`
and `.model_class`.

## See also

Other circular model helpers:
[`augment_circular()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/augment_circular.md),
[`circular_model_diagnostics()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/circular_model_diagnostics.md)

## Examples

``` r
if (requireNamespace("CircularRegression", quietly = TRUE)) {
  set.seed(1)
  df <- tibble::tibble(y = normalize_angle(rnorm(30)), x = rnorm(30))
  fit <- CircularRegression::consensus(y ~ x, data = df)
  circular_residuals(fit)
}
```
