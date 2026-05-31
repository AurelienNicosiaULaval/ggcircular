## R CMD check results

0 errors | 0 warnings | 0 notes

## Resubmission

This is a resubmission. In this version I have:

* single quoted the software name 'ggplot2' in the Title and Description
  fields of DESCRIPTION;
* replaced local README links to CONTRIBUTING.md, SUPPORT.md and
  CODE_OF_CONDUCT.md with absolute GitHub URLs.

Checked locally on macOS 26.5 with R 4.5.0 using:

```r
devtools::check(document = FALSE, args = "--as-cran", build_args = "--no-manual")
devtools::check(document = FALSE, args = c("--as-cran", "--run-donttest"), build_args = "--no-manual")
```

Additional local validation:

```r
devtools::test()
pkgdown::build_site()
tools::checkRdaFiles("data")
devtools::install(upgrade = "never")
library(ggcircular)
```

The test suite currently has 168 passing expectations.

The source tarball built with `R CMD build --no-manual .` is 1.8 MB and took
about 12 seconds to build locally. The CRAN tarball includes three vignettes:
`ggcircular`, `rose-diagrams` and `validation`.

The data files use xz compression and R data version 3 according to
`tools::checkRdaFiles("data")`.

A strict hard-dependency check was also run from a temporary directory:

```bash
_R_CHECK_FORCE_SUGGESTS_=false R CMD check \
  --no-manual --ignore-vignettes --no-tests --as-cran \
  ggcircular_0.1.0.tar.gz
```

That check returns only the expected incoming NOTE for a new submission.

## Downstream dependencies

This is a new package, so there are no downstream dependencies.

## Optional dependencies

The package uses optional integrations through `Suggests` and
`requireNamespace()` checks. Optional integrations include `momentuHMM`,
`posterior` and `circular`.

The package should install and load without these optional packages. Tests that
require optional integrations use `testthat::skip_if_not_installed()`.

The package also provides S3 methods for `CircularRegression`-style classes, but
`CircularRegression` is not declared in `Suggests` because it is not currently
available from a mainstream CRAN check repository.

## Notes for a future CRAN submission

This release is prepared as a GitHub release. Before CRAN submission, rerun
checks on Linux, macOS and Windows, submit to win-builder, consider macbuilder
if needed, and verify that all examples remain fast under CRAN timing
constraints.
