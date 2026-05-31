# Annotate circular tests

Adds a text annotation with the p-value from a Rayleigh or
Watson-Williams test.

## Usage

``` r
stat_circular_test(
  mapping = NULL,
  data = NULL,
  geom = "text",
  position = "identity",
  ...,
  test = c("rayleigh", "watson_williams"),
  x = 0,
  y = 1,
  digits = 3,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
)
```

## Arguments

- mapping, data, geom, position, show.legend, inherit.aes:

  Standard ggplot2 layer arguments.

- ...:

  Additional arguments passed to the text geom.

- test:

  Test to compute.

- x, y:

  Text position.

- digits:

  Number of digits used for p-value formatting.

- na.rm:

  Should missing values be removed?

## Value

A ggplot2 layer.

## See also

Other circular tests:
[`rayleigh_test()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/rayleigh_test.md),
[`watson_williams_test()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/watson_williams_test.md)
