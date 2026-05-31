# Simulated animal movement steps

Simulated tracks for three individuals with derived step length, bearing
and turn angle features.

## Usage

``` r
animal_steps
```

## Format

A tibble with 600 rows and 8 variables:

- id:

  Animal identifier.

- time:

  Step index.

- x, y:

  Cartesian coordinates.

- step_length:

  Euclidean step length.

- bearing:

  Movement bearing in radians under the mathematical convention.

- turn_angle:

  Signed turn angle in radians.

- state:

  Latent movement state label.

## Source

Simulated for package examples.
