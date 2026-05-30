#' Simulated wind directions
#'
#' A reproducible simulated dataset of wind directions with station, speed and
#' season variables. Angles are stored in radians.
#'
#' @format A tibble with 500 rows and 4 variables:
#' \describe{
#'   \item{station}{Station identifier.}
#'   \item{direction}{Wind direction in radians.}
#'   \item{speed}{Wind speed in arbitrary units.}
#'   \item{season}{Season label.}
#' }
#' @source Simulated for package examples.
"wind_directions"

#' Simulated animal movement steps
#'
#' Simulated tracks for three individuals with derived step length, bearing and
#' turn angle features.
#'
#' @format A tibble with 600 rows and 8 variables:
#' \describe{
#'   \item{id}{Animal identifier.}
#'   \item{time}{Step index.}
#'   \item{x, y}{Cartesian coordinates.}
#'   \item{step_length}{Euclidean step length.}
#'   \item{bearing}{Movement bearing in radians under the mathematical convention.}
#'   \item{turn_angle}{Signed turn angle in radians.}
#'   \item{state}{Latent movement state label.}
#' }
#' @source Simulated for package examples.
"animal_steps"

#' Simulated hourly activity
#'
#' A reproducible simulated dataset of hourly activity converted to circular
#' angles.
#'
#' @format A tibble with 240 rows and 5 variables:
#' \describe{
#'   \item{id}{Individual identifier.}
#'   \item{hour}{Hour of day.}
#'   \item{angle}{Hour converted to radians.}
#'   \item{activity}{Activity level.}
#'   \item{group}{Group label.}
#' }
#' @source Simulated for package examples.
"hourly_activity"

#' Simulated axial orientations
#'
#' Simulated axial orientation data, such as fiber or fault orientations, stored
#' modulo `pi`.
#'
#' @format A tibble with 300 rows and 3 variables:
#' \describe{
#'   \item{sample}{Sample identifier.}
#'   \item{orientation}{Axial orientation in radians, modulo `pi`.}
#'   \item{group}{Group label.}
#' }
#' @source Simulated for package examples.
"axial_orientations"
