# Function for processing a single spectrawiz file
process_file <- function(file) {
  file_contents <- scan(file, what = character(), sep = "\n", quiet = TRUE,
                        comment.char = "\"")
  # Remove whitespace
  file_contents <- trimws(file_contents)

  # Split by a single space and remove any empty columns per row
  # TODO: Investigate if this is needed or if spectrawiz *always* uses the
  # TODO: same column delim spacing, if yes, adjust split arg accordingly and skip
  file_contents <- strsplit(file_contents, split = " ")
  file_contents <- lapply(file_contents, function(entry) entry[!entry == ""])

  # Combine all wavelength rows into a matrix, transpose and convert into
  # a data frame
  file_contents <- do.call(rbind, file_contents)
  wavelengths <- as.character(file_contents[,1])
  spectral_data <- t(as.double(file_contents[,2]))
  colnames(spectral_data) <- wavelengths
  spectral_data <- as.data.frame(spectral_data)
  # Add filename of loaded file as a column
  # TODO: Make this optional
  spectral_data <- cbind(data.frame(filename=file,stringsAsFactors = FALSE),
                         spectral_data)
  spectral_data
}

#' @export
read_spectrawiz <- function(file) {
  multiple_files <- length(file) > 1
  # Yell at user if one or more files defined in file don't exist
  check_if_files_are_there(file)

  if(isTRUE(multiple_files)) {
    spectral_data <- lapply(file, process_file)
    spectral_data <- do.call(rbind, spectral_data)
  } else {
    spectral_data <- process_file(file)
  }
  spectral_data
}
