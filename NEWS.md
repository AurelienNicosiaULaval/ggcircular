# ggcircular 0.2.0

## New features

* Integrated the directional-dependence displays prototyped in
  `ggdirectionalvis` into `ggcircular`.
* Added circular-linear helpers for density estimation, phase loom displays,
  circular topographies, statistical orbits and bootstrap orbit intervals.
* Added circular-circular helpers for toroidal density estimation, toroidal
  topographies, toroidal flow displays, conditional ridges and bootstrap ridge
  intervals.
* Added directional diagnostic scenarios, diagnostic atlases, classical
  unfolded comparisons, marginal support diagnostics, smoothing selection and
  independence lineups.
* Added simulation helpers for cylindrical and toroidal examples.

## API

* The existing public API remains available.
* New ggplot2 layers use the standard `ggcircular` convention
  `aes(x = theta, y = response)` or `aes(x = theta, y = phi)`.
* High-level `plot_*()` helpers are retained as shortcuts built from the new
  ggplot2 layers.
* Prototype-only integration stubs are not included.

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
* Further validation is planned for the R Journal article workflow.
