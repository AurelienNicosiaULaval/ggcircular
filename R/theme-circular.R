#' Circular plot themes
#'
#' Lightweight themes for circular plots. They keep a restrained grid and avoid
#' imposing a strong visual identity.
#'
#' @param base_size Base font size.
#' @param base_family Base font family.
#'
#' @return A ggplot2 theme.
#' @export
#' @family circular themes
#'
#' @examples
#' theme_circular()
theme_circular <- function(base_size = 12, base_family = "") {
  ggplot2::theme_minimal(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      axis.title = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.y = ggplot2::element_line(linewidth = 0.25, colour = "grey85"),
      panel.grid.major.x = ggplot2::element_line(linewidth = 0.25, colour = "grey80"),
      legend.position = "right"
    )
}

#' @rdname theme_circular
#' @export
theme_rose <- function(base_size = 12, base_family = "") {
  theme_circular(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      panel.grid.major.y = ggplot2::element_line(linewidth = 0.2, colour = "grey88")
    )
}

#' @rdname theme_circular
#' @export
theme_compass <- function(base_size = 12, base_family = "") {
  theme_circular(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      panel.grid.major.x = ggplot2::element_line(linewidth = 0.35, colour = "grey75")
    )
}
