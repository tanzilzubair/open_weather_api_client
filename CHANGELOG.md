## [3.1.0] - Minor Change
* Added WeatherType enum values for the weather conditions `Freezing Rain`, `Hail`, 
  and `Sleet` 
* Added support for converting wind speed to the Beaufort Scale
* Fixed several minor bugs in the weather models
* Fixed several minor bugs in the unit conversion logic 

## [3.0.1] - Minor Change
* Redundant enum values removed
* Improved `README.md`

## [3.0.0] - Minor Breaking Changes
* BREAKING CHANGE: `RequestResponse` now uses named parameters
* A city name and coordinates cannot both be given to the same factory class anymore
* Updated samples in `README.md`
* Updated examples
* Updated dependencies

## [2.0.1] - Bug fix
* Fixed a bug where OneCallWeather would fail if parts of the request body were null
* Updated mistakes in `README.md`

## [2.0.0] - Bug fixes, QOL changes, and new features

### Breaking changes:
* Tuple2 has been deprecated, and weather factories now return data of
type RequestResponse

### New Features:
* Added support for the Beaufort scale for wind speed unit conversions

### QOL Changes:
* Reduced package dependencies greatly (resulting in breaking changes)
* All unit conversions are now done at the highest possible accuracy,
and provided as is, without truncating decimal points

### Minor changes
* Fully commented the OneCall data models
* Better documentation 
* Updated the example project to reflect API changes

## [1.0.0] - Initial Release

* Initial release