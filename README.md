# spectrawizreader

## Hello world!

spectrawizreader is a package for reading files containing spectral measurements made
using the Stellarnet SpectraWiz Spectrometer software. It is inspired by the
[asdreader](https://github.com/cran/asdreader) package in its basic functionality.

## Installation 

To install spectrawiz, please use the `install_github()` function from the 
[devtools package](https://github.com/r-lib/devtools/), like so:

```
devtools::install_github("alkc/spectrawizreader")
```

## Usage

### Basic file input

```
# Get path to demo file included in the package:
path_to_spectrawiz_file <- trm_file()

# Read the file into a data.frame
spectral_data <- read_spectrawiz(file)

# Print first five columns:
print(spectral_data[,1:5])
```

The first column in the `data.frame` returned by `read_spectrawiz` is always
the filename associated with the input file. To remove it, just subset away
the first column:

```
spectral_data <- spectral_data[,-1]
```

### Getting the wavelengths

The wavelengths are stored in the column name of the returned `data.frame`. 

To extract them, call `colnames()` on the `data.frame` containing the spectral
data, and then `as.numeric()`. 

**Just remember to remove the `filename` column first!**

```
path_to_spectrawiz_file <- trm_file()
spectral_data <- read_spectrawiz(path_to_spectrawiz_file)

# The first column in spectral_data contains file paths, so we remove it 
# before we extract the colnames
wavelengths <- colnames(spectral_data[,-1])
wavelengths <- as.numeric(wavelengths)
head(wavelengths)
# [1] 339.0 339.5 340.0 340.5 341.0 341.5
```

### Merging files containing different spectral ranges?

spectrawizreader can take a vector of file paths as input and return a single 
data frame containing the multiple spectra, provided that all files passed in
to the same `read_spectrawiz` function call have the exact same spectral range.

If you try to merge spectrawiz files with different spectral bands/ranges this 
way, spectrawizreader will throw the following error:

```
Error in rbind(deparse.level, ...) : 
  numbers of columns of arguments do not match
```

To work your way around this, use your vector of file paths in combination with
`lapply` to create a list of unmerged data frames, and then use one of the
solutions listed at the following [StackOverflow question dealing with merging data frames with different columns](https://stackoverflow.com/q/3402371)

Here is my suggested way to do it, using dplyr's `bind_rows()` function:

```
# Create a vector of paths to your spectral files that you wish to merge:
paths_to_spectrawiz_files <- c("path/to/file1.trm","path/to/file2.trm")

# Create a list of unmerged data frames:
unmerged_spectral_data <- lapply(path_to_spectrawiz_files, read_spectrawiz)

# Merge list into a single data frame using bind_rows. 
spectral_data <- dplyr::bind_rows(unmerged_spectral_data)
```

Rows that are missing data for some specific wavelength will contain `NA` values,
as is customary.
