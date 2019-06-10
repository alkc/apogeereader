# CHANGELOG
## [Unreleased]

### Added
- Added read_spectrovision() for reading Apogee SpectroVision output

### Changed
- Changed name of package from spectrawizreader to apogeereader
- Moved functions from spectrawizreader.R into own files

## [0.1.0]

### Added
- New function for reading one or more SpectraWiz files: read_spectrawiz()
- Support for merging spectrawiz files with different spectral ranges
- Documentation for read_spectrawiz() and trm_file()
### Changed
- Remove old functions for reading Spectrawiz files
- Remove unfinished functions for reading metadata
- Change name of demo file function from .trm_file() to trm_file()
