## R CMD check results

0 errors | 0 warnings | 0 notes

## Release scope

Version 0.2.0 is a GitHub release. It is not being submitted to CRAN.
The release adds conditional displays for cylindrical and toroidal data,
diagnostics for ambiguous ridges, circular bootstrap intervals and expanded
reproducibility documentation.

Checked locally on macOS with R 4.5.0 using:

```bash
R CMD build --no-manual .
R CMD check --as-cran --no-manual ggcircular_0.2.0.tar.gz
```

Additional local validation:

```r
devtools::test()
pkgdown::build_site()
tools::checkRdaFiles("data")
pkgdown::check_pkgdown()
```

The test suite has 284 passing expectations.

The source tarball is built with `R CMD build --no-manual .`; all included
vignettes are rebuilt during the package check.

The data files use xz compression and R data version 3 according to
`tools::checkRdaFiles("data")`.

## Downstream dependencies

No reverse-dependency assessment is claimed for this GitHub-only release.

## Optional dependencies

The package uses optional integrations through `Suggests` and
`requireNamespace()` checks. Optional integrations include `momentuHMM`,
`posterior` and `circular`.

The package should install and load without these optional packages. Tests that
require optional integrations use `testthat::skip_if_not_installed()`.

The package also provides S3 methods for `CircularRegression`-style classes, but
`CircularRegression` is not declared in `Suggests` because it is not currently
available from a mainstream CRAN check repository.

## Distribution

The canonical version 0.2.0 source and its reproducibility supplement are
distributed through the tagged GitHub release.
