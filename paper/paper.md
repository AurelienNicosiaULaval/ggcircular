---
title: "ggcircular: Reproducible visualization and diagnostics for circular data in ggplot2"
tags:
  - R
  - ggplot2
  - circular statistics
  - data visualization
  - reproducible research
authors:
  - name: Aurelien Nicosia
    affiliation: 1
affiliations:
  - name: Universite Laval
    index: 1
date: 2026-05-31
bibliography: paper.bib
---

# Summary

`ggcircular` is an R package that extends the `ggplot2` grammar of graphics
[@wickham2016ggplot2] to circular, axial and directional data. It provides rose
diagrams, circular density layers, mean-direction summaries, coordinate and
scale helpers, circular intervals, classical tests, diagnostic plots for angular
models, movement-state graphics, spherical summaries and posterior draw
summaries.

The package is designed for exploratory graphics, teaching examples and
reproducible statistical workflows involving directions, bearings, orientations,
times of day, turn angles and other periodic measurements.

# Statement of need

Circular data require methods that respect the periodic topology of the sample
space [@fisher1993statistical; @jammalamadaka2001topics]. Linear summaries can
be misleading near the origin because `0` and `2 * pi` represent the same
direction. Axial data add another common complication because opposite
directions represent the same orientation.

Many R users already build analyses with `ggplot2`, but circular workflows often
require switching between plotting idioms, manual angle transformations and
package-specific output formats. `ggcircular` addresses this practical gap by
keeping the user inside familiar `ggplot2`, tibble and S3 workflows while making
the angle conventions explicit.

# Functionality

The core public interface covers:

1. rose diagrams through `geom_rose()` and `stat_rose()`;
2. circular density visualization through `geom_circular_density()`;
3. circular summaries through `circular_summary()`, `mean_direction()` and
   `estimate_kappa()`;
4. uncertainty and tests through `circular_mean_ci()`, `rayleigh_test()` and
   `watson_williams_test()`;
5. von Mises and wrapped distributions through `stat_vonmises()`,
   `stat_vonmises_fit()`, `fit_vonmises_mixture()` and
   `stat_vonmises_mixture()`;
6. diagnostics for angular models through `circular_residuals()`,
   `circular_model_diagnostics()` and `autoplot()` methods;
7. movement and latent-state graphics through `mutate_directional_features()`,
   `augment_momentuHMM_angles()` and `plot_state_angles()`;
8. spherical and posterior helpers through `spherical_summary()`,
   `as_circular_draws()` and `summarise_circular_draws()`.

# Validation

The validation plan combines unit tests, CRAN-style checks, pkgdown article
builds and comparative examples against established circular-statistics
packages when optional dependencies are available. The comparative validation
article covers boundary cases around `0` and `2 * pi`, uniform data, axial data,
bimodal von Mises mixtures and timing proxies for common plotting workflows.

# Limitations

`ggcircular` is primarily a visualization and diagnostic package, not a general
replacement for specialist circular-inference software. In particular, the
automatic circular density bandwidth is heuristic, `estimate_kappa()` is a
descriptive approximation, `circular_mean_ci()` is unreliable when the mean
resultant length is close to zero, and classical tests such as Rayleigh and
Watson-Williams require assumptions that should be checked before confirmatory
use.

# Availability

The development repository is available at
<https://github.com/AurelienNicosiaULaval/ggcircular>. A Zenodo archive DOI
should be added after the first stable GitHub release and before journal
submission.

# References
