# Autoplot circular data

Creates a quick diagnostic plot for a numeric vector of circular angles.

## Usage

``` r
autoplot_circular(
  theta,
  bins = 24,
  density = TRUE,
  mean = TRUE,
  axial = FALSE,
  ...
)
```

## Arguments

- theta:

  Numeric vector of angles in radians.

- bins:

  Number of rose diagram bins.

- density:

  Should a circular density estimate be added?

- mean:

  Should the mean direction be added?

- axial:

  Should the data be treated as axial, modulo `pi`?

- ...:

  Additional arguments currently ignored.

## Value

A ggplot object.

## Examples

``` r
autoplot_circular(wind_directions$direction)
```
