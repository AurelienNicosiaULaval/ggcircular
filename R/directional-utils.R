directional_numeric <- function(x, name, allow_na = FALSE) {
  if (!is.numeric(x)) {
    rlang::abort(paste0("`", name, "` must be numeric."))
  }
  if (!allow_na && any(!is.finite(x))) {
    rlang::abort(paste0("`", name, "` must contain only finite values."))
  }
  if (allow_na && any(!is.finite(x) & !is.na(x))) {
    rlang::abort(paste0("`", name, "` must contain only finite values or `NA`."))
  }
  x
}

directional_positive_scalar <- function(x, name) {
  if (!is.numeric(x) || length(x) != 1L || !is.finite(x) || x <= 0) {
    rlang::abort(paste0("`", name, "` must be a single positive number."))
  }
  x
}

directional_probability_scalar <- function(x, name) {
  if (!is.numeric(x) || length(x) != 1L || !is.finite(x) || x < 0 || x > 1) {
    rlang::abort(paste0("`", name, "` must be a single number between 0 and 1."))
  }
  x
}

directional_count <- function(x, name, minimum = 1L) {
  if (!is.numeric(x) || length(x) != 1L || !is.finite(x) || x < minimum) {
    rlang::abort(paste0("`", name, "` must be a single integer greater than or equal to ", minimum, "."))
  }
  as.integer(x)
}

directional_check_pair <- function(first, second, first_name, second_name) {
  if (length(first) != length(second)) {
    rlang::abort(paste0("`", first_name, "` and `", second_name, "` must have the same length."))
  }
  invisible(NULL)
}

directional_wrap <- function(theta) {
  normalize_angle(theta)
}

directional_signed_angle <- function(theta) {
  normalize_angle(theta, origin = -pi)
}

directional_signed_difference <- function(a, b) {
  angular_difference(a, b)
}

stable_vm_weight <- function(delta, kappa) {
  exp(kappa * (cos(delta) - 1))
}

gaussian_kernel <- function(u, h) {
  exp(-0.5 * (u / h)^2) / (sqrt(2 * pi) * h)
}

default_linear_bandwidth <- function(x) {
  s <- stats::sd(x, na.rm = TRUE)
  n <- sum(stats::complete.cases(x))
  if (!is.finite(s) || s <= 0) {
    s <- 1
  }
  h <- 1.06 * s * n^(-1 / 5)
  if (!is.finite(h) || h <= 0) {
    h <- 1
  }
  h
}

directional_angle_grid <- function(n) {
  n <- directional_count(n, "n", minimum = 2L)
  edges <- seq(0, 2 * pi, length.out = n + 1L)
  edges[-length(edges)] + diff(edges) / 2
}

directional_safe_linear_grid <- function(x, n) {
  n <- directional_count(n, "n_x", minimum = 2L)
  range_x <- range(x)
  span <- diff(range_x)
  if (!is.finite(span) || span <= 0) {
    center <- mean(range_x)
    return(seq(center - 1, center + 1, length.out = n))
  }
  pad <- 0.08 * span
  seq(range_x[1] - pad, range_x[2] + pad, length.out = n)
}

directional_safe_breaks <- function(x, n) {
  n <- directional_count(n, "n", minimum = 1L)
  range_x <- range(x)
  span <- diff(range_x)
  if (!is.finite(span) || span <= 0) {
    center <- mean(range_x)
    return(seq(center - 0.5, center + 0.5, length.out = n + 1L))
  }
  seq(range_x[1], range_x[2], length.out = n + 1L)
}

signed_angle_breaks_labels <- function() {
  list(
    breaks = c(-pi, -pi / 2, 0, pi / 2, pi),
    labels = expression(-pi, -pi/2, 0, pi/2, pi)
  )
}

polar_angle_label_data <- function(radius) {
  data.frame(
    x = c(0, pi / 2, pi, 3 * pi / 2),
    y = radius,
    angle_label = c("0", "pi/2", "pi", "3*pi/2"),
    stringsAsFactors = FALSE
  )
}

polar_label_radius <- function(x, expand = 0.08) {
  x <- x[is.finite(x)]
  if (!length(x)) {
    return(1)
  }
  rng <- range(x)
  span <- diff(rng)
  if (!is.finite(span) || span <= 0) {
    span <- max(abs(rng), 1)
  }
  rng[2] + expand * span
}

topography_palette <- function() {
  c("#16304f", "#1f6fa8", "#25a9c7", "#65c96f", "#f2df4f", "#f08a35", "#cf2f2f")
}

flow_palette <- function() {
  c("#5b2a86", "#2c5aa0", "#1f9eb7", "#57c785", "#f2df4f")
}

ridge_palette <- function() {
  c("#2a50c4", "#20a7b5", "#4fc36b", "#f0cf3a", "#d73f31")
}

theme_directional_dependence <- function(base_size = 12, base_family = "", legend_position = "right") {
  ggplot2::theme_minimal(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      panel.grid.minor = ggplot2::element_blank(),
      legend.position = legend_position
    )
}

theme_directional_void <- function(base_size = 12, base_family = "", legend_position = "right") {
  ggplot2::theme_void(base_size = base_size, base_family = base_family) +
    ggplot2::theme(legend.position = legend_position)
}

legend_setting <- function(show_legend, legend_position) {
  if (isTRUE(show_legend)) {
    legend_position
  } else {
    "none"
  }
}

combine_aes <- function(default, mapping) {
  if (is.null(mapping)) {
    default
  } else {
    utils::modifyList(default, mapping)
  }
}

directional_rvonmises <- function(n, mu, kappa) {
  n <- directional_count(n, "n", minimum = 1L)
  if (length(mu) == 1L) {
    mu <- rep(mu, n)
  }
  if (length(kappa) == 1L) {
    kappa <- rep(kappa, n)
  }
  directional_check_pair(mu, kappa, "mu", "kappa")
  if (length(mu) != n) {
    rlang::abort("`mu` and `kappa` must have length 1 or `n`.")
  }

  out <- numeric(n)
  for (j in seq_len(n)) {
    if (kappa[j] < 1e-8) {
      out[j] <- stats::runif(1, 0, 2 * pi)
    } else {
      a <- 1 + sqrt(1 + 4 * kappa[j]^2)
      b <- (a - sqrt(2 * a)) / (2 * kappa[j])
      r <- (1 + b^2) / (2 * b)
      repeat {
        u1 <- stats::runif(1)
        z <- cos(pi * u1)
        f <- (1 + r * z) / (r + z)
        c_value <- kappa[j] * (r - f)
        u2 <- stats::runif(1)
        if (c_value * (2 - c_value) - u2 > 0 || log(c_value / u2) + 1 - c_value >= 0) {
          break
        }
      }
      u3 <- stats::runif(1)
      s <- ifelse(u3 > 0.5, 1, -1)
      out[j] <- mu[j] + s * acos(f)
    }
  }
  directional_wrap(out)
}

log_vm_stable_normalizing_constant <- function(kappa) {
  -log(2 * pi) - log(base::besselI(kappa, nu = 0, expon.scaled = TRUE))
}
