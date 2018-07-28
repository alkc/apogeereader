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
