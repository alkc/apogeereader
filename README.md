# apogreereader

## Early development!

This package is still in early development. Function names and such _might_ be 
subject to change!

The first stable version of this package will (hopefully) be available via CRAN.
Until then, follow the instructions below to install the development version.

## Hello world!

apogeereader is a package for reading files containing spectral measurements 
made using the Stellarnet SpectraWiz and Spectrovision Spectroradiometer software. 
It is inspired by the [asdreader](https://github.com/cran/asdreader) package 
(for ASD Fieldspec data) in its basic functionality.

## Installation 

To install this development version of spectrawizreader, please use the 
`install_github()` function from the  
[devtools package](https://github.com/r-lib/devtools/), like so:

```{r}
devtools::install_github("alkc/apogeereader")
```

## Usage

### Spectrawiz

#### Basic file input

```{r}
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

```{r}
spectral_data <- spectral_data[,-1]
```

#### Getting the wavelengths

The wavelengths are stored in the column names of the `data.frame` returned by
`read_spectrawiz()`. 

Use the base function `colnames()` to extract the wavelengths, followed by
`as.numeric()` to convert the wavelength vector from characters to numbers.

Here is an example:

```{r}
path_to_spectrawiz_file <- trm_file()
spectral_data <- read_spectrawiz(path_to_spectrawiz_file)

# The first column in spectral_data contains file paths, so we remove it 
# before we extract the colnames
wavelengths <- colnames(spectral_data[,-1])

# The wavelengths are stored as characters in the column names. To convert them
# back to numeric format, use as.numeric():
wavelengths <- as.numeric(wavelengths)

# Done!
# Preview the first six values:
head(wavelengths)
# [1] 339.0 339.5 340.0 340.5 341.0 341.5
```

### Spectrovision

#### Basic file input

```{r}
spectrovision_file <- spectrovision_file()
spectral_data <- read_spectrovision(spectrovision_file)
```
The first column of the resulting `data.frame` is the timestamp
associated with each measurement. If you wish to split the timestamp into
separate `Date`, `Time` and `Sensor` for each row them set the `split_timestamp`
argument to `TRUE` in `read_spectrovision`:

```{r}
spectrovision_file <- spectrovision_file()
spectral_data <- read_spectrovision(spectrovision_file, split_timestamp = TRUE)
```


#### Merging multiple spectrovision files into a single `data.frame`

```{r}
library(purrr)

spectrovision_files <- c(path_to_spectrovision_1, path_to_spectrovision_2, 
path_to_spectrovision_3)

spectral_data <- map_dfr(spectrovision_files, read_spectrovision)
```

