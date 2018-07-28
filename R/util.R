# In case user supplies one or more non-existent paths to read_spectrawiz
# better to just print one file in err msg, rather than all of them if many
stop_if_files_are_missing <- function(file) {
  files_that_do_not_exist <- !file.exists(file)
  if(isTRUE(sum(files_that_do_not_exist) > 0)) {
    first_nonexistent_file <- file[files_that_do_not_exist][1]
    error_message <- paste("Hey now, the following file does not exist:",
                           first_nonexistent_file)
    stop(error_message)
  }
}
