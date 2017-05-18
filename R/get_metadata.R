#' @export
get_metadata <- function(file, keep_old_filepath = FALSE) {

    file <- .trm_file()
    read_specwiz_metadata(file, FALSE)

}

read_specwiz_metadata <- function(file, keep_old_filepath) {
    meta_data <- readLines(file, n = 2L)
    meta_data <- substr(meta_data, 2L, nchar(meta_data))
    file <- ifelse(keep_old_filepath, meta_data[1], file)



    dplyr::data_frame(
        time = regexpr(meta_data[2], "Time:", perl = TRUE)
        # avg = grep()
        # sm = grep()
        # sg = grep()
    )



    data.frame(File = file, Metadata = meta_data[2])

}
