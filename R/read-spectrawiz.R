#' @include util.R

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
read_spectrawiz <- function(file) {

  # Throw error if one or more files are missing at specified path
  stop_if_files_are_missing(file)

    # No need for complicated merge and sort if there is only one input file:
  if (isTRUE(length(file) == 1)) {
    different_spectral_ranges <- FALSE
  }

  # Filepaths to data frames:
  spectral_data <- lapply(file, process_spectrawiz_spectra)
  spectral_data <- merge_spectra(spectral_data, FALSE)
  spectral_data
}

# Internal function for processing a single spectrawiz file
process_spectrawiz_spectra <- function(file) {
  file_contents <- scan(file, what = character(), sep = "\n",
                        quiet = TRUE, comment.char = "\"")

  # Remove whitespace from all lines:
  file_contents <- trimws(file_contents)

  # Split by a single space and remove any empty columns per row
  # TODO: Investigate if this is needed or if spectrawiz *always* uses the [...]
  # ... same column delim spacing
  file_contents <- strsplit(file_contents, split = " ")
  file_contents <- lapply(file_contents, function(entry) entry[!entry == ""])

  # Combine all wavelength rows into a matrix, transpose into wide form and
  # convert into a data frame
  file_contents <- do.call(rbind, file_contents)

  # Wavelengths are converted to char to be used as column names
  wavelengths <- as.character(file_contents[, 1])
  spectral_data <- t(as.double(file_contents[, 2]))
  colnames(spectral_data) <- wavelengths
  spectral_data <- as.data.frame(spectral_data)

  # Add filename of loaded file as a column
  # TODO: Make filename column optional?
  spectral_data <- cbind(data.frame(filename = file, stringsAsFactors = FALSE),
                         spectral_data)
  spectral_data
}
