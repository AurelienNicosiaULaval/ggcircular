# Scientific API review

This file records the current methodological review targets for `ggcircular`.

## Reviewed statistical components

1. Angle normalization and signed angular differences use modular arithmetic on
   the requested period.
2. Directional means use mean sine and cosine components.
3. Axial summaries use the standard doubled-angle transformation.
4. Mean resultant length, circular variance and circular standard deviation are
   descriptive circular statistics.
5. Von Mises density calculations use the modified Bessel function of order
   zero.
6. Von Mises concentration estimation uses the common piecewise approximation
   based on mean resultant length.
7. Rayleigh tests and Watson-Williams wrappers are intended as exploratory
   graphics helpers, not a replacement for full model diagnostics.

## Main references

- Fisher, N. I. (1993). *Statistical Analysis of Circular Data*. Cambridge
  University Press.
- Mardia, K. V. and Jupp, P. E. (2000). *Directional Statistics*. Wiley.
- Jammalamadaka, S. R. and Sengupta, A. (2001). *Topics in Circular Statistics*.
  World Scientific.
- Pewsey, A., Neuhäuser, M. and Ruxton, G. D. (2013). *Circular Statistics in R*.
  Oxford University Press.

## Future review checklist

1. Compare all summary functions against `circular` on deterministic examples.
2. Compare von Mises mixture fits against simulated mixtures with known
   parameters.
3. Add stronger small-sample mean-direction intervals.
4. Add references in function documentation where inferential functions are
   exposed.
5. Revisit default bandwidth and mixture initialization before CRAN submission.
