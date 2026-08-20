#' @importFrom scales label_number
#' @importFrom utils globalVariables
#' @importFrom vctrs vec_recycle_common
#' @keywords internal
NULL

utils::globalVariables(c(
  ".abs_resid", ".angle", ".component", ".data", ".draw", ".dx", ".dy",
  ".fitted", ".index", ".iteration", ".model_class", ".observed",
  ".probability", ".resid", ".row", ".state", ".state_probability",
  ".variable", ".resid_plot", "activity", "angle", "angle_label", "bearing",
  "component", "density", "direction", "group", "hour", "id", "level",
  "linewidth", "lower", "mass", "mu", "mu_lower", "mu_upper", "orientation",
  "phi", "phi_center_signed", "phi_lower", "phi_plot", "phi_signed", "phi_upper", "relative_support",
  "rho", "rho_lower", "rho_upper", "ridge_group", "sample", "scenario_label", "season",
  "sigma", "sigma_lower", "sigma_upper", "source_y", "speed", "state",
  "step_length", "station", "target_y", "theta", "theta_plot", "theta_sector",
  "theta_signed", "time", "turn_angle", "upper", "value", "x", "x_mid",
  "xend", "xmax", "xmin", "y", "yend", "ymax", "ymin"
))
