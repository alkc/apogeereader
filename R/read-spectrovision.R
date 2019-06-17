#' @name read_spectrovision
#' @title Read one or more SpectraWiz output files into a dataframe
#' @description \code{read_spectrovision()} takes a single SpectroVision .csv file
#'  and outputs a \code{data.frame} containing the spectra and metadata associated
#'  with \code{file}
#'
#' @export
#' @author Alexander Koc
#' @param file a vector of paths to SpectraWiz file(s)
#' @param split_timestamp If \code{TRUE}, the timestamp of each measurement
#' contained in \code{file} will be split into three character columns in the
#' resulting \code{data.frame}: \code{date}, \code{time} and \code{sensor}.
#' @return a \code{data.frame} spectral data and any metadata associated with
#' input file  \code{file}
#' @examples
#'
#' # TODO: Update example
#'
#' path_to_spectrovision_file <- spectrovision_file()
#'
#' spectral_data <- read_spectrawiz(path_to_spectrovision_file)
#'
#' # Print the first row and five first columns:
#' print(spectral_data[1,1:5])
#'
#' @export
read_spectrovision <- function(file, split_timestamp = FALSE) {
  spectral_data <- read.csv(file, stringsAsFactors = FALSE, header = FALSE)
  data_header <- .get_first_unit_column(spectral_data)
  spectral_data <- as.data.frame(t(spectral_data), stringsAsFactors = FALSE)
  colnames(spectral_data) <- data_header
  spectral_data <- .remove_non_data_rows(spectral_data)
  spectral_data <- .find_and_coerce_numeric_columns(spectral_data)

  if (split_timestamp) {
    timestamp_column <- spectral_data[,"Timestamp",drop = FALSE]
    timestamp_column <- .split_timestamp(timestamp_column)
    spectral_data <- spectral_data[,-1]
    spectral_data <- cbind(timestamp_column, spectral_data)
  }

  row.names(spectral_data) <- c()
  spectral_data
}

# Find first unit column and extract it as column header
.get_first_unit_column <- function(spectral_data) {

  columns <- seq(1, ncol(spectral_data))
  units_missing <- TRUE

  # Return only the first Unit column.
  # Will obviously have to be changed when support added for irregular
  # spectral ranges in same file
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

# Convert all numeric values to numeric format
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

.split_timestamp <- function(timestamp_column) {
  split_timestamps <- strsplit(unlist(timestamp_column), " ")
  split_timestamps <- lapply(split_timestamps, function(timestamp_row) {
    data.frame(Date = timestamp_row[2],
               Time = timestamp_row[1],
               Sensor = timestamp_row[3],
               stringsAsFactors = FALSE)
  })

  split_timestamps <- do.call(rbind, split_timestamps)
  split_timestamps
}
