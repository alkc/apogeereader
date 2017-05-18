#' @export
get_spectra <- function(file) {

    if(length(file) > 1) {
        data <- dplyr::bind_rows(lapply(file, read_specwiz_spectral_data))
    } else {
        data <- read_specwiz_spectral_data(file)
    }

    data

}

read_specwiz_spectral_data <- function(file) {

    data <- read.table(file, skip = 2, header = FALSE)
    reflectance <- data.frame(t(data[,2]))
    colnames(reflectance) <- data[,1]
    reflectance

}
