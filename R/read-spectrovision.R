# Check if values in all "Unit" columns are equal
.check_if_spectra_equal <- function(spectral_data) {

}

.get_first_unit_column <- function(spectral_data) {

  columns <- seq(1, ncol(spectral_data))
  units_missing <- TRUE

  for (col_index in columns) {
    data_type <- spectral_data[2, col_index]

    if (data_type == "Units")  {
      units_missing <- FALSE
      break()
    }
  }

  if (units_missing) {
    stop("Could not find \"Units\" column in data")
  }

  spectral_data[,col_index]

}

.find_and_coerce_numeric_columns <- function(spectral_data) {

  columns <- seq(ncol(spectral_data))

  for (column_index in columns) {
    spectral_data[,column_index] <- type.convert(spectral_data[,column_index],
                                                 as.is = TRUE)
  }
  spectral_data
}

.remove_non_data_rows <- function(spectral_data) {
  is_data_row <- !spectral_data[,1] == "Timestamp"
  spectral_data[is_data_row,]
}

#' @export
read_spectrovision <- function(file) {
  spectral_data <- read.csv(file, stringsAsFactors = FALSE, header = FALSE)
  data_header <- .get_first_unit_column(spectral_data)
  spectral_data <- as.data.frame(t(spectral_data), stringsAsFactors = FALSE)
  colnames(spectral_data) <- data_header
  spectral_data <- .remove_non_data_rows(spectral_data)
  spectral_data <- .find_and_coerce_numeric_columns(spectral_data)
  spectral_data
}
