#' @name trm_file
#' @title Get file path of a sample SpectraWiz .TRM file
#' @description This function returns a path to a sample file containing a
#' spectral reading made on a winter wheat canopy, which you can use to test
#' the \code{read_spectrawiz()} function.
#' @author Alexander Koc
#' @return a character vector containing a file path to a sample file
#' @examples
#'
#' path_to_spectrawiz_file <- trm_file()
#' path_to_spectrawiz_file
#' @export
trm_file <- function() {
  system.file("extdata", "wheat.TRM", package = "apogeereader")
}

#' @name spectrovision_file
#' @title Get file path of a sample SepctroVision .csv file
#' @description This function returns a path to a sample file containing two
#' spectral reflectance readings for testing
#' the \code{read_spectrovision()} function.
#' @author Alexander Koc
#' @return a character vector containing a file path to a sample file
#' @examples
#'
#' path_to_spectrovision_file <- spectrovision_file()
#' path_to_spectrovision_file
#' @export
spectrovision_file <- function() {
  system.file("extdata", "grass.csv", package = "apogeereader")
}
