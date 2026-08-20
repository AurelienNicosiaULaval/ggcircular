# ggcircular 0.2.0

Version 0.2.0 adds a conditional visualization workflow for directional
dependence on cylinders and tori.

## Highlights

- Circular topography and phase loom layers for circular-linear data.
- Toroidal topography, toroidal flow and conditional ridge layers for
  circular-circular data.
- Cross-validated smoothing selection and marginal-support diagnostics.
- Conditional-ridge diagnostics for multiple local modes and near-tied
  modes.
- Pointwise bootstrap displays using circular intervals for toroidal
  ridges.
- Executable README examples and three workflow vignettes for the new
  displays.

## Corrections and validation

- Signed plotting coordinates no longer remove observations above pi
  before toroidal statistics are computed.
- Filled topographies and their isocontours are computed from the same
  complete sample and density estimate.
- The first-grid-maximum ridge selection remains unchanged for
  compatibility; ambiguity is reported separately.
- The package test suite, source build, vignettes, pkgdown site and
  `R CMD check --as-cran` validation were completed for this release.

Version 0.2.0 and its reproducibility supplement are distributed through
the tagged GitHub release. It is not submitted to CRAN; the CRAN release
remains version 0.1.0.
