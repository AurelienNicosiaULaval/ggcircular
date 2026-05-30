#' @importFrom scales label_number
#' @importFrom utils globalVariables
#' @importFrom vctrs vec_recycle_common
#' @keywords internal
NULL

utils::globalVariables(c(
  ".abs_resid", ".angle", ".component", ".data", ".draw", ".dx", ".dy",
  ".fitted", ".index", ".iteration", ".model_class", ".observed",
  ".probability", ".resid", ".row", ".state", ".state_probability",
  ".variable", ".resid_plot", "activity", "angle", "bearing", "component",
  "density", "direction", "group", "hour", "id", "orientation", "sample",
  "season", "speed", "state", "step_length", "station", "time",
  "turn_angle", "x", "xend", "xmax", "xmin", "y", "yend"
))
