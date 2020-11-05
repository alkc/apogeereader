#' @name get_spectrovision_metadata
#' @title Extract Metadata Columns From Spectrovision Spectra
#' @description \code{get_spectrovision_metadata()} takes a \code{data.frame} produced by \code{read_spectrovision()}
#'  and outputs a \code{data.frame} containing only non-wavelength columns.
#'
#' @export
#' @author Alexander Koc
#' @param spectrovision_data a \code{data.frame} output from \code{read_spectrovision()}
#' @return a \code{data.frame} \code{data.frame} of metadata associated with
#' @examples
#'
#' path_to_spectrovision_file <- spectrovision_file()
#' spectral_data <- read_spectrovision(path_to_spectrovision_file)
#' meta_data <- get_spectrovision_metadata(spectral_data)
#'
#' @export
get_spectrovision_metadata <- function(spectrovision_data) {
  which_meta <- colnames(spectrovision_data)
  which_meta <- !grepl("[0-9]+", which_meta)
  return(spectrovision_data[,which_meta])
}
