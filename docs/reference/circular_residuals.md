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
fit <- structure(
  list(y = c(0, 0.2, 0.4), mui = c(0.05, 0.15, 0.5)),
  class = "angular"
)
circular_residuals(fit)
#> # A tibble: 3 × 6
#>   .observed .fitted  .resid .abs_resid .index .model_class
#>       <dbl>   <dbl>   <dbl>      <dbl>  <int> <chr>       
#> 1       0      0.05 -0.0500     0.0500      1 angular     
#> 2       0.2    0.15  0.0500     0.0500      2 angular     
#> 3       0.4    0.5  -0.100      0.100       3 angular     
```
