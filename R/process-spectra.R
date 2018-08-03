#' @include util.R


# Function for processing a single spectrawiz file
process_spectra <- function(file) {
  file_contents <- scan(file, what = character(), sep = "\n",
                        quiet = TRUE, comment.char = "\"")

  # Remove whitespace from all lines:
  file_contents <- trimws(file_contents)

  # Split by a single space and remove any empty columns per row
  # TODO: Investigate if this is needed or if spectrawiz *always* uses the [...]
  # ... same column delim spacing, if yes, adjust split arg accordingly and skip
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
