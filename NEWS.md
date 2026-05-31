# ggcircular 0.1.0

## New features

* Added rose diagrams, circular density estimates, mean direction layers,
  circular scales, circular coordinates, movement helpers and simulated
  datasets.
* Added circular summaries, confidence intervals, Rayleigh and Watson-Williams
  helpers, and theoretical circular distribution overlays.

## Experimental

* Added angular model diagnostics and optional helpers for `CircularRegression`.
* Added exploratory finite mixtures of von Mises distributions.
* Added optional helpers for `momentuHMM`, spherical summaries and posterior
  circular draws.
* Added repository support files for contributions, support and conduct.

## Documentation

* Added a README with badges, examples and a package logo.
* Added pkgdown reference pages and articles for the main workflows.
* Added CRAN readiness notes to the README, validation vignette and
  `cran-comments.md`.

## Validation

* Added testthat coverage for angle utilities, summaries, ggplot2 layers,
  diagnostics, movement helpers, circular tests, spherical/posterior helpers
  and von Mises mixtures.
* Added strict `momentuHMM` alignment checks to prevent silent truncation.
* Added a strict hard-dependency CI profile with `_R_CHECK_FORCE_SUGGESTS_`
  set to `false`.

## Known limitations

* Advanced model diagnostics, von Mises mixtures and optional ecosystem
  integrations are experimental.
* Automatic circular-density smoothing is heuristic.
* CRAN submission is planned after additional validation and dependency checks.
