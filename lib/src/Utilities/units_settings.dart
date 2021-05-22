import 'package:open_weather_api_client/src/Utilities/settings_enums.dart';

/// This class stores the configuration for which units you want the queried data to be converted to
class UnitSettings {
  TemperatureUnit temperatureUnit;

  WindSpeedUnit windSpeedUnit;

  PressureUnit pressureUnit;

  DistanceUnit distanceUnit;

  PrecipitationUnit precipitationUnit;

  UnitSettings({
    this.temperatureUnit = TemperatureUnit.Celsius,
    this.windSpeedUnit = WindSpeedUnit.Kilometres_Hour,
    this.pressureUnit = PressureUnit.Millibars,
    this.distanceUnit = DistanceUnit.Kilometers,
    this.precipitationUnit = PrecipitationUnit.Millimetres,
  });
}
