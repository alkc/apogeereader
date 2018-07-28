#' @include process-spectra.R

#' @title Simple loading of SpectraWiz output files in R.
#'
#' @description
#'
#' Use the \code{read_spectrawiz()} to load SpectraWiz output files into wide format data frames in R.
#'
#' @docType package
#' @author Alexander Koc
#' @name spectrawizreader
NULL

#' @export
read_spectrawiz <- function(file) {
  multiple_files <- length(file) > 1
  # Yell at user if one or more files defined in file don't exist
  stop_if_files_are_missing(file)

  if(isTRUE(multiple_files)) {
    spectral_data <- lapply(file, process_file)
    spectral_data <- do.call(rbind, spectral_data)
  } else {
    spectral_data <- process_spectra(file)
  }
  spectral_data
}
