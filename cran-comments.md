## R CMD check results

0 errors | 0 warnings | 0 notes

Checked locally on macOS 26.5 with R 4.5.0 using:

```r
devtools::check(document = FALSE, args = "--as-cran", build_args = "--no-manual")
devtools::check(document = FALSE, args = c("--as-cran", "--run-donttest"), build_args = "--no-manual")
```

Additional local validation:

```r
devtools::test()
pkgdown::build_site()
devtools::install(upgrade = "never")
library(ggcircular)
```

The source tarball built with `R CMD build --no-manual .` is 1.8 MB.

## Downstream dependencies

This is a new package, so there are no downstream dependencies.

## Optional dependencies

The package uses optional integrations through `Suggests` and
`requireNamespace()` checks. Optional integrations include `CircularRegression`,
`momentuHMM`, `posterior` and `circular`.

The package should install and load without these optional packages. Tests that
require optional integrations use `testthat::skip_if_not_installed()`.

`CircularRegression` is currently used only through optional examples and S3
class support. Its availability should be reviewed again before CRAN submission.

## Notes for a future CRAN submission

This release is prepared as a GitHub release. Before CRAN submission, rerun
checks on Linux, macOS and Windows, review optional dependency burden, and
verify that all examples remain fast under CRAN timing constraints.
