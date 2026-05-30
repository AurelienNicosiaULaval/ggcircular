# ggcircular

[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

`ggcircular` is a `ggplot2` extension for circular, axial and directional data.
It provides rose diagrams, circular density estimates, mean direction layers,
circular scales, movement helpers and simulated datasets for examples and
teaching.

## Installation

``` r
devtools::install()
```

## Minimal example

``` r
library(ggplot2)
library(ggcircular)

ggplot(wind_directions, aes(x = direction)) +
  geom_rose(bins = 16) +
  geom_circular_density() +
  geom_mean_direction() +
  scale_x_circular_compass() +
  coord_circular(zero = "north", direction = "clockwise") +
  theme_circular()
```

## Rose diagram

``` r
ggplot(wind_directions, aes(x = direction)) +
  geom_rose(bins = 16, aes(fill = after_stat(count))) +
  scale_x_circular_degrees() +
  coord_circular() +
  theme_rose()
```

## Circular density

``` r
ggplot(wind_directions, aes(x = direction)) +
  geom_rose(aes(y = after_stat(density)), bins = 24, alpha = 0.45) +
  geom_circular_density(linewidth = 1) +
  scale_x_circular_degrees() +
  coord_circular() +
  theme_circular()
```

## Mean direction

``` r
ggplot(wind_directions, aes(x = direction, colour = season)) +
  geom_circular_density(linewidth = 1) +
  geom_mean_direction(length = "resultant") +
  scale_x_circular_degrees() +
  coord_circular() +
  theme_circular()
```

## Movement data

``` r
ggplot(animal_steps, aes(x = turn_angle, fill = state)) +
  geom_rose(bins = 24) +
  geom_mean_direction() +
  facet_wrap(~ state) +
  scale_x_circular_radians() +
  coord_circular() +
  theme_circular()
```

## Axial data

``` r
ggplot(axial_orientations, aes(x = orientation, fill = group)) +
  geom_rose(bins = 18, axial = TRUE, alpha = 0.7) +
  geom_mean_direction(axial = TRUE) +
  scale_x_circular_degrees(limits = c(0, pi)) +
  coord_circular() +
  theme_circular()
```

## Angular model diagnostics

``` r
if (requireNamespace("CircularRegression", quietly = TRUE)) {
  fit <- CircularRegression::consensus(direction ~ speed, data = wind_directions)

  circular_model_diagnostics(fit)

  autoplot(fit, type = "residuals_density")
}
```

## Mixtures of von Mises distributions

``` r
fit_mix <- fit_vonmises_mixture(wind_directions$direction, k = 2)

ggplot(wind_directions, aes(x = direction)) +
  geom_rose(aes(y = after_stat(density)), bins = 24, alpha = 0.4) +
  stat_vonmises_mixture(fit = fit_mix, linewidth = 1) +
  scale_x_circular_degrees() +
  coord_circular() +
  theme_circular()
```

## Vignettes

Start with `vignette("ggcircular")`, then see the specialized vignettes on rose
diagrams, circular density, mean direction, axial data, movement data and
circular distributions, model diagnostics, spherical helpers and posterior
draws.
