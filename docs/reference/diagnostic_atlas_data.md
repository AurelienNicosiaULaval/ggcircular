# Build diagnostic atlas data

Build diagnostic atlas data

## Usage

``` r
diagnostic_atlas_data(
  space = c("cylindrical", "toroidal"),
  n = 600,
  seed = 20260609
)
```

## Arguments

- space:

  Either `"cylindrical"` or `"toroidal"`.

- n:

  Number of observations per scenario.

- seed:

  Optional random seed.

## Value

A data frame with diagnostic scenarios and plotting columns. The
returned object has class `diagnostic_atlas_data`.

## See also

Other directional diagnostics:
[`autoplot.diagnostic_atlas_data()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/autoplot.diagnostic_atlas_data.md),
[`diagnostic_scenarios()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/diagnostic_scenarios.md),
[`plot_classical_comparison()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_classical_comparison.md),
[`plot_diagnostic_atlas()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/plot_diagnostic_atlas.md),
[`simulate_cyl_diagnostic()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/simulate_cyl_diagnostic.md),
[`simulate_tor_diagnostic()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/simulate_tor_diagnostic.md)

## Examples

``` r
diagnostic_atlas_data("cylindrical", n = 20, seed = 1)
#>          theta        x        scenario       space  theta_plot  scenario_label
#> 1   1.16164950 3.313238     independent cylindrical  1.16164950     independent
#> 2   4.41314622 3.736315     independent cylindrical -1.87003908     independent
#> 3   3.60231560 2.705478     independent cylindrical -2.68086970     independent
#> 4   1.05590136 2.220248     independent cylindrical  1.05590136     independent
#> 5   5.93031747 4.336672     independent cylindrical -0.35286784     independent
#> 6   5.92802800 1.266698     independent cylindrical -0.35515731     independent
#> 7   0.81152978 3.658953     independent cylindrical  0.81152978     independent
#> 8   5.23671335 3.026855     independent cylindrical -1.04647195     independent
#> 9   2.94064706 3.759622     independent cylindrical  2.94064706     independent
#> 10  3.45564977 3.324199     independent cylindrical -2.82753554     independent
#> 11  3.47255358 4.568114     independent cylindrical -2.81063173     independent
#> 12  1.50102004 2.100056     independent cylindrical  1.50102004     independent
#> 13  4.77844607 4.192229     independent cylindrical -1.50473923     independent
#> 14  1.13612620 4.465989     independent cylindrical  1.13612620     independent
#> 15  2.54646305 3.003703     independent cylindrical  2.54646305     independent
#> 16  5.36300310 1.161220     independent cylindrical -0.92018221     independent
#> 17  6.13489264 3.357928     independent cylindrical -0.14829266     independent
#> 18  1.41890322 2.552581     independent cylindrical  1.41890322     independent
#> 19  2.79481881 3.594152     independent cylindrical  2.79481881     independent
#> 20  0.47110962 3.217228     independent cylindrical  0.47110962     independent
#> 21  1.05583605 3.691390          smooth cylindrical  1.05583605     smooth mean
#> 22  5.07377517 2.365058          smooth cylindrical -1.20941013     smooth mean
#> 23  2.41866413 2.061894          smooth cylindrical  2.41866413     smooth mean
#> 24  2.05921545 2.591208          smooth cylindrical  2.05921545     smooth mean
#> 25  3.78311011 2.474801          smooth cylindrical -2.50007519     smooth mean
#> 26  3.79751984 2.347847          smooth cylindrical -2.48566547     smooth mean
#> 27  0.78309503 3.903366          smooth cylindrical  0.78309503     smooth mean
#> 28  1.85103220 2.579309          smooth cylindrical  1.85103220     smooth mean
#> 29  3.62923016 2.750197          smooth cylindrical -2.65395515     smooth mean
#> 30  3.96455971 2.503929          smooth cylindrical -2.31862560     smooth mean
#> 31  3.21709076 2.135685          smooth cylindrical -3.06609454     smooth mean
#> 32  3.17315884 2.020758          smooth cylindrical -3.11002647     smooth mean
#> 33  3.35544309 2.281833          smooth cylindrical -2.92774222     smooth mean
#> 34  3.50130147 1.912046          smooth cylindrical -2.78188384     smooth mean
#> 35  5.45329897 2.905482          smooth cylindrical -0.82988633     smooth mean
#> 36  5.21321347 2.586077          smooth cylindrical -1.06997184     smooth mean
#> 37  0.70025568 4.548440          smooth cylindrical  0.70025568     smooth mean
#> 38  4.42140436 2.743950          smooth cylindrical -1.86178095     smooth mean
#> 39  5.63908508 3.249633          smooth cylindrical -0.64410023     smooth mean
#> 40  1.75761147 2.567707          smooth cylindrical  1.75761147     smooth mean
#> 41  3.68069187 3.451882 heteroscedastic cylindrical -2.60249344 variable spread
#> 42  0.05620809 3.005555 heteroscedastic cylindrical  0.05620809 variable spread
#> 43  1.84562041 3.415995 heteroscedastic cylindrical  1.84562041 variable spread
#> 44  1.74279826 2.952183 heteroscedastic cylindrical  1.74279826 variable spread
#> 45  5.11183755 3.008162 heteroscedastic cylindrical -1.17134775 variable spread
#> 46  1.63631595 3.173681 heteroscedastic cylindrical  1.63631595 variable spread
#> 47  4.55157646 3.469383 heteroscedastic cylindrical -1.73160885 variable spread
#> 48  5.69314489 2.990817 heteroscedastic cylindrical -0.59004042 variable spread
#> 49  5.96299557 2.975168 heteroscedastic cylindrical -0.32018973 variable spread
#> 50  0.45958026 2.853628 heteroscedastic cylindrical  0.45958026 variable spread
#> 51  4.74176304 3.514940 heteroscedastic cylindrical -1.54142227 variable spread
#> 52  1.79699490 3.177379 heteroscedastic cylindrical  1.79699490 variable spread
#> 53  0.62865482 3.776739 heteroscedastic cylindrical  0.62865482 variable spread
#> 54  5.99459091 3.327425 heteroscedastic cylindrical -0.28859440 variable spread
#> 55  2.61133654 3.673723 heteroscedastic cylindrical  2.61133654 variable spread
#> 56  2.85949282 2.690347 heteroscedastic cylindrical  2.85949282 variable spread
#> 57  6.10132263 3.351675 heteroscedastic cylindrical -0.18186268 variable spread
#> 58  3.66930469 3.730368 heteroscedastic cylindrical -2.61388061 variable spread
#> 59  6.04570996 2.753176 heteroscedastic cylindrical -0.23747535 variable spread
#> 60  4.78591735 3.396767 heteroscedastic cylindrical -1.49726796 variable spread
#> 61  1.25798451 3.336666      multimodal cylindrical  1.25798451  multiple modes
#> 62  4.30535541 4.508400      multimodal cylindrical -1.97782989  multiple modes
#> 63  5.76090039 3.188535      multimodal cylindrical -0.52228491  multiple modes
#> 64  1.78693449 2.723287      multimodal cylindrical  1.78693449  multiple modes
#> 65  0.65753615 3.212641      multimodal cylindrical  0.65753615  multiple modes
#> 66  4.40487393 2.183217      multimodal cylindrical -1.87831138  multiple modes
#> 67  3.31727042 2.259591      multimodal cylindrical -2.96591489  multiple modes
#> 68  5.07640658 4.361914      multimodal cylindrical -1.20677872  multiple modes
#> 69  6.00986753 2.893784      multimodal cylindrical -0.27331777  multiple modes
#> 70  0.69399678 3.019336      multimodal cylindrical  0.69399678  multiple modes
#> 71  1.71709998 2.691065      multimodal cylindrical  1.71709998  multiple modes
#> 72  3.08198534 2.234926      multimodal cylindrical  3.08198534  multiple modes
#> 73  2.00059145 2.877596      multimodal cylindrical  2.00059145  multiple modes
#> 74  3.51338649 2.220495      multimodal cylindrical -2.76979882  multiple modes
#> 75  1.64992135 2.936756      multimodal cylindrical  1.64992135  multiple modes
#> 76  1.26841936 3.032915      multimodal cylindrical  1.26841936  multiple modes
#> 77  2.43489608 3.504388      multimodal cylindrical  2.43489608  multiple modes
#> 78  5.57865030 3.452522      multimodal cylindrical -0.70453500  multiple modes
#> 79  3.48668124 1.683366      multimodal cylindrical -2.79650407  multiple modes
#> 80  5.29156914 2.675893      multimodal cylindrical -0.99161617  multiple modes
#> 81  3.80929606 2.607455            seam cylindrical -2.47388925   seam crossing
#> 82  5.89137827 3.675782            seam cylindrical -0.39180704   seam crossing
#> 83  1.66097303 3.068744            seam cylindrical  1.66097303   seam crossing
#> 84  2.38820053 2.142017            seam cylindrical  2.38820053   seam crossing
#> 85  5.07356777 3.221157            seam cylindrical -1.20961754   seam crossing
#> 86  6.14543103 4.053705            seam cylindrical -0.13775428   seam crossing
#> 87  6.01887505 4.440456            seam cylindrical -0.26431025   seam crossing
#> 88  4.79238559 2.810314            seam cylindrical -1.49079971   seam crossing
#> 89  3.20221619 1.879608            seam cylindrical -3.08096912   seam crossing
#> 90  0.40511965 4.516861            seam cylindrical  0.40511965   seam crossing
#> 91  4.04368694 2.478721            seam cylindrical -2.23949836   seam crossing
#> 92  5.75482524 3.555587            seam cylindrical -0.52836006   seam crossing
#> 93  0.59836395 4.371287            seam cylindrical  0.59836395   seam crossing
#> 94  1.85588206 2.407659            seam cylindrical  1.85588206   seam crossing
#> 95  4.83762354 3.178748            seam cylindrical -1.44556177   seam crossing
#> 96  1.60782644 2.668693            seam cylindrical  1.60782644   seam crossing
#> 97  3.25403482 1.947110            seam cylindrical -3.02915049   seam crossing
#> 98  4.25905672 3.128689            seam cylindrical -2.02412858   seam crossing
#> 99  0.92505967 3.980233            seam cylindrical  0.92505967   seam crossing
#> 100 4.40153495 2.538751            seam cylindrical -1.88165035   seam crossing
```
