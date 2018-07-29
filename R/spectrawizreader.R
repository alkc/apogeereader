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

#' @name read_spectrawiz
#' @title Read one or more SpectraWiz output files into a dataframe
#' @description \code{read_spectrawiz()} takes a single .TRM, .IRR, .ABS, and
#' .SSM file or a vector of file paths as input and outputs a \code{data.frame}
#' containing the spectra and the file paths of the input files.
#' @export
#' @author Alexander Koc
#' @param file a vector of paths to SpectraWiz file(s)
#' @return a \code{data.frame} of filenames and spectra associated with the input files in \code{file}
#' @examples
#'
#' # Get the path to the demo file
#'
#' path_to_spectrawiz_file <- trm_file()
#'
#' # Example with one file name
#'
#' spectral_data <- read_spectrawiz(path_to_spectrawiz_file)
#'
#' # Print the five first columns:
#' print(spectral_data[1,1:5])
#'
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

#' @name trm_file
#' @title Get file path of a sample SpectraWiz .TRM file
#' @description This function returns a path to a sample file that you can use
#' to test the \code{read_spectrawiz()} function.
#' @author Alexander Koc
#' @return a character vector containing a file path to a sample file
#' @examples
#'
#' path_to_spectrawiz_file <- trm_file()
#' path_to_spectrawiz_file
#' @export
trm_file <- function() {
  system.file("extdata", "wheat.TRM", package = "spectrawizreader")
}

