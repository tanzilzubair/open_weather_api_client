import 'package:open_weather_api_client/src/Utilities/settings_enums.dart';

/// This class is ued to provide the configuration for which units you want the queried data to be converted to,
/// to a weather factory
class UnitSettings {
  /// The unit the temperature is provided in, defaults to Celsius
  TemperatureUnit temperatureUnit;

  /// The unit the wind speed is provided in, defaults to kilometres per hour
  WindSpeedUnit windSpeedUnit;

  /// The unit the pressure is provided in, defaults to millibars
  PressureUnit pressureUnit;

  /// The unit distance is provided in, defaults to kilometres
  DistanceUnit distanceUnit;

  /// The unit precipitation (Rain and Snow) is provided in, defaults to millimetres
  PrecipitationUnit precipitationUnit;

  UnitSettings({
    this.temperatureUnit = TemperatureUnit.Celsius,
    this.windSpeedUnit = WindSpeedUnit.Kilometres_Hour,
    this.pressureUnit = PressureUnit.Millibars,
    this.distanceUnit = DistanceUnit.Kilometers,
    this.precipitationUnit = PrecipitationUnit.Millimetres,
  });
}
