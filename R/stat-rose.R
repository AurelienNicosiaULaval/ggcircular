#' Rose diagram statistic
#'
#' Bins circular angles over a full period and returns counts, densities and
#' proportions for rose diagrams.
#'
#' @param mapping,data,geom,position,show.legend,inherit.aes Standard ggplot2
#'   layer arguments.
#' @param ... Additional arguments passed to the layer.
#' @param bins Number of bins over the circular period.
#' @param binwidth Optional bin width in radians. If supplied, `bins` is ignored
#'   after the number of bins is inferred from the period.
#' @param boundary Lower boundary for the first bin.
#' @param closed Included for API compatibility. Values on the upper period
#'   boundary are wrapped into the first bin.
#' @param area If `TRUE`, radial heights are square-root transformed so that
#'   visual area is closer to the selected frequency scale.
#' @param normalize Which scale should be used for the computed radial `y`
#'   value: counts, densities or proportions.
#' @param axial Should angles be treated as axial, modulo `pi`?
#' @param na.rm Should missing values be silently removed?
#'
#' @return A ggplot2 layer. Computed variables are `xmin`, `xmax`, `x`, `count`,
#'   `density`, `proportion`, `width` and `y`.
#' @export
#' @family rose diagram layers
#'
#' @examples
#' ggplot2::ggplot(wind_directions, ggplot2::aes(x = direction)) +
#'   stat_rose(bins = 16) +
#'   coord_circular()
stat_rose <- function(
  mapping = NULL,
  data = NULL,
  geom = "col",
  position = "identity",
  ...,
  bins = 30,
  binwidth = NULL,
  boundary = 0,
  closed = TRUE,
  area = FALSE,
  normalize = c("count", "density", "proportion"),
  axial = FALSE,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
) {
  normalize <- match.arg(normalize)
  ggplot2::layer(
    stat = StatRose,
    geom = geom,
    mapping = mapping,
    data = data,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      bins = bins,
      binwidth = binwidth,
      boundary = boundary,
      closed = closed,
      area = area,
      normalize = normalize,
      axial = axial,
      na.rm = na.rm,
      ...
    )
  )
}

StatRose <- ggplot2::ggproto(
  "StatRose",
  ggplot2::Stat,
  required_aes = "x",
  default_aes = ggplot2::aes(
    y = ggplot2::after_stat(y),
    width = ggplot2::after_stat(width)
  ),
  compute_group = function(
    data,
    scales,
    bins = 30,
    binwidth = NULL,
    boundary = 0,
    closed = TRUE,
    area = FALSE,
    normalize = "count",
    axial = FALSE,
    na.rm = FALSE
  ) {
    period <- angle_period(axial)
    if (!is.null(binwidth)) {
      if (!is.numeric(binwidth) || length(binwidth) != 1L || is.na(binwidth) || binwidth <= 0) {
        rlang::abort("`binwidth` must be a single positive number.")
      }
      bins <- ceiling(period / binwidth)
      binwidth <- period / bins
    } else {
      if (!is.numeric(bins) || length(bins) != 1L || is.na(bins) || bins < 1) {
        rlang::abort("`bins` must be a single positive integer.")
      }
      bins <- as.integer(bins)
      binwidth <- period / bins
    }

    boundary <- normalize_angle(boundary, period = period)
    x <- data$x
    weights <- if ("weight" %in% names(data)) data$weight else rep(1, length(x))
    keep <- !is.na(x) & !is.na(weights)
    x <- x[keep]
    weights <- weights[keep]

    if (!isTRUE(na.rm) && any(!keep)) {
      rlang::warn("Removed missing values from `stat_rose()`.")
    }

    x_norm <- normalize_angle(x, period = period, origin = boundary)
    rel <- x_norm - boundary
    bin_id <- floor(rel / binwidth) + 1L
    bin_id[bin_id < 1L | bin_id > bins] <- 1L

    count <- numeric(bins)
    if (length(bin_id) > 0L) {
      tab <- rowsum(weights, bin_id, reorder = FALSE)
      count[as.integer(rownames(tab))] <- as.numeric(tab[, 1])
    }

    total <- sum(count)
    density <- if (total > 0) count / (total * binwidth) else rep(0, bins)
    proportion <- if (total > 0) count / total else rep(0, bins)
    selected <- switch(
      normalize,
      count = count,
      density = density,
      proportion = proportion
    )
    y <- if (isTRUE(area)) sqrt(selected) else selected

    xmin <- boundary + (seq_len(bins) - 1L) * binwidth
    xmax <- xmin + binwidth
    tibble::tibble(
      xmin = xmin,
      xmax = xmax,
      x = xmin + binwidth / 2,
      count = count,
      density = density,
      proportion = proportion,
      width = binwidth,
      y = y
    )
  }
)
