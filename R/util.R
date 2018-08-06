# In case user supplies one or more non-existent paths to read_spectrawiz
# better to just print one file in err msg, rather than all of them if many
stop_if_files_are_missing <- function(file) {
  files_that_do_not_exist <- !file.exists(file)
  if(isTRUE(sum(files_that_do_not_exist) > 0)) {
    # TODO: Figure out something better instead of just printing first missing file
    first_nonexistent_file <- file[files_that_do_not_exist][1]
    error_message <- paste("No file exists at the specified path:",
                           first_nonexistent_file)
    stop(error_message)
  }
}

# Internal function for sorting merged spectral data by spectral band in
# colnames. Neccessary as merging of "uneven" spectral data sets results
# in a merged data frame where the spectral bands no longer are sorted
# numerically.
sort_spectral_data_columns <- function(merged_spectral_data) {
  filename <- merged_spectral_data[,"filename"]
  # Remove filename column so we can sort remaining columns (spectral bands)
  # numerically:
  merged_spectral_data <- subset(merged_spectral_data, select = -c(filename))
  spectral_bands <- colnames(merged_spectral_data)
  numerical_sort_indices <- spectral_bands[order(as.numeric(spectral_bands))]
  merged_spectral_data <- merged_spectral_data[,numerical_sort_indices]
  merged_spectral_data <- cbind(filename, merged_spectral_data)
  merged_spectral_data
}

# Internal function to merge rows of spectral data stored in a list.
merge_spectra <- function(spectral_list, different_spectral_ranges) {
  if (isTRUE(!different_spectral_ranges)) {
    # Merge using rbind if spectral range is identical across all input files
    spectral_data <- do.call(rbind, spectral_list)
  } else if (isTRUE(different_spectral_ranges)) {
    # Merge using Reduce-merge followed by a sort if input files differ
    # in spectral ranges.
    # Credit goes to: https://stackoverflow.com/a/8097519/7547327
    # And a shoutout to all the nice people here: https://redd.it/934o67
    spectral_data <-  Reduce(function(...) merge(..., all = TRUE), spectral_list)
    spectral_data <- sort_spectral_data_columns(spectral_data)
  }
  spectral_data
}
