# ggcircular

![ggcircular hex logo](reference/figures/logo.png)

[![R-CMD-check](https://github.com/AurelienNicosiaULaval/ggcircular/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/AurelienNicosiaULaval/ggcircular/actions/workflows/R-CMD-check.yaml)
[![pkgdown](https://github.com/AurelienNicosiaULaval/ggcircular/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/AurelienNicosiaULaval/ggcircular/actions/workflows/pkgdown.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![GitHub
release](https://img.shields.io/github/v/release/AurelienNicosiaULaval/ggcircular?label=release)](https://github.com/AurelienNicosiaULaval/ggcircular/releases)
[![License:
MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://aureliennicosiaulaval.github.io/ggcircular/LICENSE)
[![R \>=
4.1.0](https://img.shields.io/badge/R-%3E%3D%204.1.0-276DC3.svg)](https://aureliennicosiaulaval.github.io/ggcircular/DESCRIPTION)
[![pkgdown
site](https://img.shields.io/badge/docs-pkgdown-1f425f.svg)](https://aureliennicosiaulaval.github.io/ggcircular/)

`ggcircular` is a `ggplot2` extension for circular, axial and
directional data. It provides layers, scales, coordinate helpers,
summaries and diagnostics for angles measured on a periodic scale.

The package is designed for exploratory graphics, teaching examples and
reproducible statistical workflows involving directions, bearings,
orientations, times of day, turn angles and other circular measurements.

## Installation

Install the development release from GitHub:

``` r

install.packages("remotes")
remotes::install_github("AurelienNicosiaULaval/ggcircular")
```

Or clone with SSH and install locally:

``` bash
git clone git@github.com:AurelienNicosiaULaval/ggcircular.git
cd ggcircular
R -q -e 'devtools::install(upgrade = "never")'
```

## Quick Start

``` r

library(ggplot2)
library(dplyr)
library(ggcircular)
```

``` r

wind_directions |>
  filter(season == "winter") |>
  ggplot(aes(x = direction)) +
  geom_rose(aes(y = after_stat(density), fill = after_stat(density)), bins = 24, alpha = 0.78) +
  geom_circular_density(linewidth = 1.1, colour = "#123C4A") +
  geom_mean_direction(length = "resultant", colour = "#E4572E", linewidth = 1.1) +
  scale_x_circular_compass() +
  coord_circular(zero = "north", direction = "clockwise") +
  labs(fill = "density", title = "Winter wind directions") +
  theme_circular()
```

![](reference/figures/README-quick-start-1.png)

## What It Does

| Workflow | Main helpers |
|----|----|
| Rose diagrams and circular histograms | [`geom_rose()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/geom_rose.md), [`stat_rose()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/stat_rose.md) |
| Circular density estimation | [`geom_circular_density()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/geom_circular_density.md), [`stat_circular_density()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/stat_circular_density.md) |
| Mean direction and concentration | [`geom_mean_direction()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/geom_mean_direction.md), [`circular_summary()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/circular_summary.md), [`estimate_kappa()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/estimate_kappa.md) |
| Circular confidence intervals and tests | [`circular_mean_ci()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/circular_mean_ci.md), [`rayleigh_test()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/rayleigh_test.md), [`watson_williams_test()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/watson_williams_test.md), [`stat_circular_test()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/stat_circular_test.md) |
| Axial orientations modulo pi | `axial = TRUE` in summaries and layers |
| Theoretical circular distributions | [`stat_vonmises()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/stat_vonmises.md), [`stat_wrapped_normal()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/stat_vonmises.md), [`stat_uniform_circular()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/stat_vonmises.md) |
| Mixtures of von Mises components | [`fit_vonmises_mixture()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/fit_vonmises_mixture.md), [`stat_vonmises_mixture()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/stat_vonmises_mixture.md) |
| Movement and state-angle graphics | [`mutate_directional_features()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/mutate_directional_features.md), [`geom_direction_arrow()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/geom_direction_arrow.md), [`plot_state_angles()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_state_angles.md) |
| Angular model diagnostics | [`circular_residuals()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/circular_residuals.md), [`circular_model_diagnostics()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/circular_model_diagnostics.md), [`autoplot()`](https://ggplot2.tidyverse.org/reference/autoplot.html) methods |
| Spherical and posterior helpers | [`spherical_summary()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/spherical_summary.md), [`as_circular_draws()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/as_circular_draws.md), [`summarise_circular_draws()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/summarise_circular_draws.md) |

## Design Principles

- Angles are stored and computed in radians.
- Scales handle display labels in radians, degrees, hours or compass
  labels.
- Directional data use period `2 * pi`.
- Axial data use period `pi` through `axial = TRUE`.
- Heavy packages remain optional and are accessed with explicit
  availability checks.
- Outputs are standard `ggplot` objects, tibbles or familiar test
  objects.

## Summaries

[`circular_summary()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/circular_summary.md)
respects existing `dplyr` groups and returns mean direction, resultant
length, circular variance, circular standard deviation and an estimated
von Mises concentration parameter.

``` r

wind_directions |>
  circular_summary(direction, season) |>
  mutate(
    mean_degrees = round(rad_to_deg(mean), 1),
    Rbar = round(Rbar, 3),
    kappa = round(kappa, 2)
  ) |>
  select(season, n, mean_degrees, Rbar, kappa)
#> # A tibble: 4 × 5
#>   season     n mean_degrees  Rbar kappa
#>   <chr>  <int>        <dbl> <dbl> <dbl>
#> 1 fall     131        310.  0.811  3
#> 2 spring   115        135.  0.802  2.89
#> 3 summer   138        223.  0.87   4.15
#> 4 winter   116         48.2 0.904  5.52
```

## Axial Data

Axial observations identify opposite directions. For example, an
orientation of 0 radians is equivalent to an orientation of pi radians.
Use `axial = TRUE` to compute and display these data modulo pi.

``` r

ggplot(axial_orientations, aes(x = orientation, fill = group)) +
  geom_rose(bins = 18, axial = TRUE, alpha = 0.72) +
  geom_mean_direction(axial = TRUE, colour = "#123C4A", linewidth = 1) +
  scale_x_circular_degrees(limits = c(0, pi)) +
  coord_circular() +
  facet_wrap(~ group) +
  theme_circular()
```

![](reference/figures/README-axial-1.png)

## Directional Movement

`ggcircular` includes helpers for bearings, turn angles and
state-specific angular distributions.

``` r

animal_steps |>
  filter(!is.na(turn_angle)) |>
  ggplot(aes(x = turn_angle, fill = state)) +
  geom_rose(bins = 24, alpha = 0.72) +
  geom_mean_direction(colour = "#123C4A", linewidth = 1) +
  scale_x_circular_degrees(
    breaks = deg_to_rad(c(0, 90, 180, 270)),
    labels = c("0", "90", "180", "270")
  ) +
  coord_circular() +
  facet_wrap(~ state) +
  theme_circular()
```

![](reference/figures/README-movement-1.png)

## Mixtures of von Mises Distributions

Finite mixtures are fitted with an expectation-maximization routine and
can be drawn directly on top of empirical rose diagrams.

``` r

set.seed(2026)

fit_mix <- fit_vonmises_mixture(wind_directions$direction, k = 2, init = "spaced")

ggplot(wind_directions, aes(x = direction)) +
  geom_rose(aes(y = after_stat(density)), bins = 24, alpha = 0.42) +
  stat_vonmises_mixture(fit = fit_mix, linewidth = 1.2, colour = "#123C4A") +
  scale_x_circular_degrees() +
  coord_circular() +
  theme_circular()
```

![](reference/figures/README-mixture-1.png)

``` r

tidy_circular(fit_mix) |>
  mutate(
    mu_degrees = round(rad_to_deg(mu), 1),
    kappa = round(kappa, 2),
    proportion = round(proportion, 3)
  ) |>
  select(component, proportion, mu_degrees, kappa)
#> # A tibble: 2 × 4
#>   component proportion mu_degrees kappa
#>       <int>      <dbl>      <dbl> <dbl>
#> 1         1      0.337       51.4  1.4
#> 2         2      0.663      232.   0.78
```

## Tests and Intervals

``` r

circular_mean_ci(
  wind_directions$direction,
  method = "bootstrap",
  R = 399,
  seed = 2026
) |>
  mutate(across(c(mean, lower, upper), rad_to_deg))
#> # A tibble: 1 × 7
#>    mean lower upper level method        n   Rbar
#>   <dbl> <dbl> <dbl> <dbl> <chr>     <int>  <dbl>
#> 1  235.  139.  354.  0.95 bootstrap   500 0.0494
```

``` r

rayleigh <- rayleigh_test(wind_directions$direction)

tibble::tibble(
  statistic = unname(rayleigh$statistic),
  n = unname(rayleigh$parameter),
  p_value = rayleigh$p.value,
  method = rayleigh$method
)
#> # A tibble: 1 × 4
#>   statistic     n p_value method
#>       <dbl> <int>   <dbl> <chr>
#> 1      1.22   500   0.295 Rayleigh test of circular uniformity
```

## Optional Model Integrations

The package keeps heavier modeling ecosystems in `Suggests`. When
available, these integrations add diagnostics without making them hard
dependencies.

``` r

fit <- CircularRegression::consensus(direction ~ speed, data = wind_directions)

circular_model_diagnostics(fit)

autoplot(fit, type = "residuals_density")
autoplot(fit, type = "fitted_observed")
```

Optional helpers currently target:

- `CircularRegression` angular, consensus and two-step objects.
- `momentuHMM` state probabilities and Viterbi states.
- `posterior` draw objects through
  [`posterior::as_draws_df()`](https://mc-stan.org/posterior/reference/draws_df.html).
- `circular` tests when classical circular test implementations are
  available.

## Vignettes

Start with:

``` r

vignette("ggcircular", package = "ggcircular")
```

Then see the pkgdown articles:

- [Getting
  started](https://aureliennicosiaulaval.github.io/ggcircular/articles/ggcircular.html)
- [Rose
  diagrams](https://aureliennicosiaulaval.github.io/ggcircular/articles/rose-diagrams.html)
- [Circular
  density](https://aureliennicosiaulaval.github.io/ggcircular/articles/circular-density.html)
- [Mean direction and
  uncertainty](https://aureliennicosiaulaval.github.io/ggcircular/articles/mean-direction-and-uncertainty.html)
- [Axial
  data](https://aureliennicosiaulaval.github.io/ggcircular/articles/axial-data.html)
- [Movement
  data](https://aureliennicosiaulaval.github.io/ggcircular/articles/movement-data.html)
- [Circular
  distributions](https://aureliennicosiaulaval.github.io/ggcircular/articles/circular-distributions.html)
- [Model
  diagnostics](https://aureliennicosiaulaval.github.io/ggcircular/articles/model-diagnostics.html)
- [Spherical and posterior
  helpers](https://aureliennicosiaulaval.github.io/ggcircular/articles/spherical-and-posterior.html)
- [Scientific validation
  notes](https://aureliennicosiaulaval.github.io/ggcircular/articles/validation.html)

## Development Status

`ggcircular` is currently experimental. The public API is usable, tested
and documented, but may still evolve as more angular model classes and
validation cases are added.

Current checks:

- Local
  [`devtools::test()`](https://devtools.r-lib.org/reference/test.html)
  passes with 111 tests.
- Local `devtools::check(document = FALSE, build_args = "--no-manual")`
  passes with 0 errors, 0 warnings and 0 notes.
- GitHub Actions runs `R CMD check` on Linux, macOS and Windows.
- `pkgdown` builds and publishes the website from `main`.

## References

- Fisher, N. I. (1993). [*Statistical Analysis of Circular
  Data*](https://doi.org/10.1017/CBO9780511564345). Cambridge University
  Press.
- Jammalamadaka, S. R., and Sengupta, A. (2001). [*Topics in Circular
  Statistics*](https://doi.org/10.1142/4031). World Scientific.
- Pewsey, A., Neuhäuser, M., and Ruxton, G. D. (2013). [*Circular
  Statistics in
  R*](https://books.google.com/books/about/Circular_Statistics_in_R.html?id=qeadAAAAQBAJ).
  Oxford University Press.
- Wickham, H. (2016). [*ggplot2: Elegant Graphics for Data
  Analysis*](https://doi.org/10.1007/978-3-319-24277-4). Springer.
