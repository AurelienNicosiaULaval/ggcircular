# Circular coordinate system

Convenience wrapper around
[`ggplot2::coord_polar()`](https://ggplot2.tidyverse.org/reference/coord_radial.html)
with arguments expressed in circular-data language.

## Usage

``` r
coord_circular(
  zero = c("east", "north", "west", "south"),
  direction = c("counterclockwise", "clockwise"),
  start = NULL,
  clip = "on"
)
```

## Arguments

- zero:

  Direction corresponding to angle zero.

- direction:

  Direction in which angles increase.

- start:

  Optional start offset in radians. If supplied, it overrides `zero`.

- clip:

  Should drawing be clipped to the plot panel?

## Value

A ggplot2 coordinate object.

## Details

`zero = "east"` and `direction = "counterclockwise"` gives the usual
mathematical convention: zero points east and positive angles rotate
toward north. `zero = "north"` and `direction = "clockwise"` gives the
usual bearing convention used for compass directions.

## See also

Other circular scales:
[`scale_x_circular_radians()`](https://aureliennicosiaulaval.github.io/ggcircular/reference/scale_x_circular_radians.md)

## Examples

``` r
coord_circular()
#> <ggproto object: Class CoordPolar, Coord, gg>
#>     aspect: function
#>     backtransform_range: function
#>     clip: on
#>     default: FALSE
#>     direction: -1
#>     distance: function
#>     draw_panel: function
#>     is_free: function
#>     is_linear: function
#>     labels: function
#>     modify_scales: function
#>     r: y
#>     range: function
#>     render_axis_h: function
#>     render_axis_v: function
#>     render_bg: function
#>     render_fg: function
#>     reverse: none
#>     setup_data: function
#>     setup_layout: function
#>     setup_panel_guides: function
#>     setup_panel_params: function
#>     setup_params: function
#>     start: -1.5707963267949
#>     theta: x
#>     train_panel_guides: function
#>     transform: function
#>     super:  <ggproto object: Class CoordPolar, Coord, gg>
coord_circular(zero = "north", direction = "clockwise")
#> <ggproto object: Class CoordPolar, Coord, gg>
#>     aspect: function
#>     backtransform_range: function
#>     clip: on
#>     default: FALSE
#>     direction: 1
#>     distance: function
#>     draw_panel: function
#>     is_free: function
#>     is_linear: function
#>     labels: function
#>     modify_scales: function
#>     r: y
#>     range: function
#>     render_axis_h: function
#>     render_axis_v: function
#>     render_bg: function
#>     render_fg: function
#>     reverse: none
#>     setup_data: function
#>     setup_layout: function
#>     setup_panel_guides: function
#>     setup_panel_params: function
#>     setup_params: function
#>     start: 0
#>     theta: x
#>     train_panel_guides: function
#>     transform: function
#>     super:  <ggproto object: Class CoordPolar, Coord, gg>
```
