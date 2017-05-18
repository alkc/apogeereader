get_spectrawiz_file_list <- function(dir_path, type = 'all') {

    if(!dir.exists(dir_path)) {
        stop(paste("The following directory could not be found:", dir_path))
    }


    file_endings <-  c("scope" = "SSM",
                       "absorbance" = "ABS",
                       "transmission" = "TRM",
                       "radiometer" = "IRR",
                       "reference" = "REF",
                       "dark" =  "DRK")

    build_pattern <- function(x) paste0("\\.", x, "$")

    if(type != 'all') {

        if(any(is.na(type))) {

            e <- paste("One or more specified types is invalid. Allowed filetypes are:",
                       paste(c("all", names(file_endings)), collapse = ", "))
            stop(e)
        }

        file_endings <- file_endings[type]
    }

    pattern <- vapply(file_endings, build_pattern, FUN.VALUE = character(1))
    pattern <- paste0(pattern, collapse = "|")

    file_list <- list.files(dir_path, pattern = pattern, ignore.case = TRUE, full.names = TRUE)

    if(length(file_list) == 0) {
        stop("No files of the selected type(s) could be found in the specified directory.")
    }

    file_list

}
