find_angle_column <- function(data, angle = NULL) {
  if (!is.null(angle)) {
    if (!angle %in% names(data)) {
      rlang::abort(paste0("Column `", angle, "` was not found in `data`."))
    }
    return(angle)
  }
  candidates <- c("turnAngle", "angle", "bearing", "turn_angle", "direction")
  found <- candidates[candidates %in% names(data)]
  if (length(found) == 0L) {
    rlang::abort("Could not infer an angle column. Supply `angle` explicitly.")
  }
  found[1]
}

validate_momentuHMM_alignment <- function(data, state, probs = NULL) {
  n_data <- nrow(data)
  n_state <- length(state)
  if (n_data != n_state) {
    rlang::abort(paste0(
      "`data` and decoded states have incompatible lengths: ",
      n_data,
      " rows in `data`, but ",
      n_state,
      " states."
    ))
  }
  if (!is.null(probs)) {
    n_probs <- nrow(probs)
    if (is.null(n_probs) || n_probs != n_data) {
      rlang::abort(paste0(
        "`stateProbs()` returned incompatible probabilities: ",
        n_probs %||% "unknown",
        " rows in the probability matrix, but ",
        n_data,
        " rows in `data`."
      ))
    }
  }
  invisible(NULL)
}

#' Augment momentuHMM fits with angular states
#'
#' Extracts an angle column and inferred states from a fitted `momentuHMM` model.
#' The function uses `momentuHMM::viterbi()` by default and adds state
#' probabilities when `momentuHMM::stateProbs()` is available.
#'
#' @param object A fitted `momentuHMM` object.
#' @param data Optional data frame. If `NULL`, `object$data` is used.
#' @param angle Optional name of the angle column.
#' @param state_method State extraction method.
#' @param ... Reserved for future methods.
#'
#' @return A tibble with `.angle`, `.state` and optional state probabilities.
#' @export
#' @family movement helpers
augment_momentuHMM_angles <- function(
  object,
  data = NULL,
  angle = NULL,
  state_method = c("viterbi", "stateProbs"),
  ...
) {
  if (!requireNamespace("momentuHMM", quietly = TRUE)) {
    rlang::abort("Package `momentuHMM` is required for `augment_momentuHMM_angles()`.")
  }
  state_method <- match.arg(state_method)
  data <- tibble::as_tibble(data %||% object$data)
  if (nrow(data) == 0L) {
    rlang::abort("No model data were found. Supply `data` explicitly.")
  }
  angle_col <- find_angle_column(data, angle = angle)

  state <- if (identical(state_method, "viterbi")) {
    tryCatch(momentuHMM::viterbi(object), error = function(e) NULL)
  } else {
    NULL
  }
  probs <- tryCatch(momentuHMM::stateProbs(object), error = function(e) NULL)
  if (is.null(state) && !is.null(probs)) {
    state <- max.col(probs, ties.method = "first")
  }
  if (is.null(state)) {
    rlang::abort("Could not extract states with `momentuHMM::viterbi()` or `momentuHMM::stateProbs()`.")
  }
  validate_momentuHMM_alignment(data, state = state, probs = probs)

  out <- dplyr::bind_cols(
    data,
    tibble::tibble(
      .angle = normalize_angle(data[[angle_col]]),
      .state = factor(state)
    )
  )
  if (!is.null(probs)) {
    probs <- as.data.frame(probs)
    names(probs) <- paste0(".state_probability_", seq_along(probs))
    out <- dplyr::bind_cols(out, tibble::as_tibble(probs))
  }
  out
}

#' @method autoplot momentuHMM
#' @export
autoplot.momentuHMM <- function(
  object,
  angle = NULL,
  type = c("rose", "density"),
  bins = 24,
  ...
) {
  type <- match.arg(type)
  augmented <- augment_momentuHMM_angles(object, angle = angle)
  plot_state_angles(augmented, angle = .angle, state = .state, type = type, bins = bins)
}
