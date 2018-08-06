#' @include process-spectra.R

#' @title Simple loading of SpectraWiz output files in R.
#'
#' @description
#'
#' Use the \code{read_spectrawiz()} to load SpectraWiz output files into wide
#' format data frames in R.
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
#' @param different_spectral_ranges logical (TRUE/FALSE). Do the input files
#' contain different spectral ranges? If yes set this to TRUE. If not leave as
#' FALSE for faster performance. If you attempt to load files with different
#' spectral ranges while this is set to false, spectrawizreader will stop with
#' an error.
#' @return a \code{data.frame} of filenames and spectra associated with the
#' input files in \code{file}
#' @examples
#'
#' # Get the path to the demo file
#'
#' path_to_spectrawiz_file <- trm_file()
#'
#' spectral_data <- read_spectrawiz(path_to_spectrawiz_file)
#'
#' # Print the five first columns:
#' print(spectral_data[1,1:5])
#'
#' @export
read_spectrawiz <- function(file, different_spectral_ranges=FALSE) {

  # Throw error if one or more files are missing at specified path
  stop_if_files_are_missing(file)

    # No need for complicated merge and sort if there is only one input file:
  if (isTRUE(length(file) == 1)) {
    different_spectral_ranges <- FALSE
  }

  # Filepaths to data frames:
  spectral_data <- lapply(file, process_spectra)
  spectral_data <- merge_spectra(spectral_data, different_spectral_ranges)
  spectral_data
}

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
  system.file("extdata", "wheat.TRM", package = "spectrawizreader")
}
