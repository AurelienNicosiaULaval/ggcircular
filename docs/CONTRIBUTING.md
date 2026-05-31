# Contributing to ggcircular

Thank you for considering a contribution to `ggcircular`. The package is
being prepared for CRAN-quality release, so small, focused changes are
preferred.

## Ways to contribute

- Report bugs with a minimal reproducible example.
- Improve documentation, examples or vignettes.
- Add tests for circular, axial or directional edge cases.
- Propose integrations with angular model packages.
- Share validation examples from teaching or research workflows.

## Development workflow

1.  Open an issue before starting large changes.
2.  Fork the repository and create a topic branch.
3.  Keep changes focused on one problem or feature.
4.  Add or update tests when behavior changes.
5.  Run the validation commands below before opening a pull request.

``` r

devtools::document()
devtools::test()
devtools::check(document = FALSE, args = "--as-cran", build_args = "--no-manual")
```

For changes touching examples, vignettes or documentation, also run:

``` r

pkgdown::build_site()
```

## Optional dependencies

Integrations with `CircularRegression`, `momentuHMM`, `posterior`,
`circular` and other specialized packages must remain optional. Use
[`requireNamespace()`](https://rdrr.io/r/base/ns-load.html) checks and
provide clear error messages when an optional package is required.

## Style

- Use clear base R or tidyverse-style code consistent with the
  surrounding file.
- Keep exported functions documented with roxygen2.
- Prefer explicit validation over silent recycling or truncation.
- Keep examples fast and deterministic.

## Support and conduct

Please use the issue tracker for bug reports and feature requests. Be
respectful, specific and constructive when discussing code,
documentation or statistical limitations.
