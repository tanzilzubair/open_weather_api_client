import '../../Utilities/general_enums.dart';
import '../../Utilities/unit_conversions.dart';
import '../../Utilities/units_settings.dart';

/// This is the class that handles JSON deserialization and makes data for the current weather
/// forecast received from queries to the OneCall API endpoint accessible.
class OneCallCurrentWeather {
  /// The condition ID provided by OpenWeather. The table for what the values represent can be found at
  /// https://openweathermap.org/weather-conditions . I do not recommend you use this directly.
  /// Instead, use the [weatherType] parameter, which is extrapolated from both this and the icon string
  /// sent by OpenWeather for a specific request
  int? weatherID;

  /// The icon ID provided by OpenWeather. The table for what the values represent can be found at
  /// https://openweathermap.org/weather-conditions . I do not recommend you use this directly.
  /// Instead, use the [weatherType] parameter, which is extrapolated from both this and the id
  /// sent by OpenWeather for a specific request
  String? iconID;

  /// The enum for identifying what the weather condition is. The main description
  /// parameter provides one suitable for display, so this is primarily provided to
  /// aid in implementing conditional logic dependent on the weather, for example, a
  /// dynamic background
  WeatherType? weatherType;

  /// This is the main, concise description for the current weather
  String? mainDescription;

  /// This is the secondary, longer description for the current weather
  String? secondaryDescription;

  /// The current temperature, in Celsius by default
  num? temp;

  /// The current temperature, accounting for human perception, in Celsius by default
  num? feelsLikeTemp;

  /// The atmospheric temperature (varying according to the pressure and humidity)
  /// below which dew can form
  num? dewPointTemp;

  /// The humidity, in percentage
  num? humidity;

  /// The cloudiness, in percentage
  num? cloudiness;

  /// The Ultraviolet Index, an international standard with values ranging from 0-12. More
  /// information can be found at [https://en.wikipedia.org/wiki/Ultraviolet_index]
  num? uvi;

  /// The current visibility, in kilometres by default
  num? visibility;

  /// The atmospheric pressure, in hecto-pascals by default
  num? pressure;

  /// The wind speed, in km/h by default
  num? windSpeed;

  /// The direction of the wind, in degrees
  int? windDegree;

  /// The wind gust speed, in km/h by default
  num? windGustSpeed;

  /// The amount of rainfall in the past 1 hour, in mm by default
  num? rainAmountLast1h;

  /// The amount of snowfall in the past 1 hour, in mm by default
  num? snowAmountLast1h;

  /// The time of sunrise for that day, in UTC time
  DateTime? sunrise;

  /// The time of sunset for that day, in UTC time
  DateTime? sunset;

  /// The timestamp of when the data was requested, in UTC time
  DateTime? timeStamp;

  OneCallCurrentWeather({
    this.weatherID,
    this.iconID,
    this.weatherType,
    this.mainDescription,
    this.secondaryDescription,
    this.temp,
    this.feelsLikeTemp,
    this.dewPointTemp,
    this.humidity,
    this.cloudiness,
    this.uvi,
    this.visibility,
    this.pressure,
    this.windSpeed,
    this.windDegree,
    this.windGustSpeed,
    this.rainAmountLast1h,
    this.snowAmountLast1h,
    this.sunrise,
    this.sunset,
    this.timeStamp,
  });

  /// JSON deserialization constructor
  factory OneCallCurrentWeather.fromJson(
    Map<String, dynamic> json,
    UnitSettings settings,
  ) {
    // Mapping the iconId and ID to a WeatherType enum
    WeatherType weatherType = infoToWeatherType(
      id: json['weather'][0]['id'],
      iconId: json['weather'][0]['icon'],
    );

    // Formatting temperature
    num? temp = temperatureToSelectedUnit(
      temp: json['temp'],
      unit: settings.temperatureUnit,
    );

    // Formatting feels like temperature
    num? feelsLikeTemp = temperatureToSelectedUnit(
      temp: json['feels_like'],
      unit: settings.temperatureUnit,
    );

    // Formatting dew point temperature
    num? dewPointTemp = temperatureToSelectedUnit(
      temp: json['dew_point'],
      unit: settings.temperatureUnit,
    );

    // Formatting the visibility
    num? visibility = distanceToSelectedUnit(
      distance: json['visibility'],
      unit: settings.distanceUnit,
    );

    // Formatting the pressure
    num pressure = pressureToSelectedUnit(
      pressure: json['pressure'],
      unit: settings.pressureUnit,
    );

    // Formatting the wind speed
    num? windSpeed = windSpeedToSelectedUnit(
      windSpeed: json['wind_speed'],
      unit: settings.windSpeedUnit,
    );

    // Formatting the gust speed
    num? windGustSpeed = windSpeedToSelectedUnit(
      windSpeed: json['wind_gust'],
      unit: settings.windSpeedUnit,
    );

    // Formatting the amount of rain
    num? rainAmountLast1h = precipitationToSelectedUnit(
      amount: json['rain']['1h'],
      unit: settings.precipitationUnit,
    );
    // Formatting the amount of snow
    num? snowAmountLast1h = precipitationToSelectedUnit(
      amount: json['snow']['1h'],
      unit: settings.precipitationUnit,
    );

    return OneCallCurrentWeather(
      weatherID: json['weather'][0]['id'],
      iconID: json['weather'][0]['icon'],
      weatherType: weatherType,
      mainDescription: json['weather'][0]['main'],
      secondaryDescription: json['weather'][0]['description'],
      temp: temp,
      feelsLikeTemp: feelsLikeTemp,
      dewPointTemp: dewPointTemp,
      humidity: json['humidity'],
      cloudiness: json['clouds'],
      uvi: json['uvi'],
      visibility: visibility,
      pressure: pressure,
      windSpeed: windSpeed,
      windDegree: json['wind_deg'],
      windGustSpeed: windGustSpeed,
      rainAmountLast1h: rainAmountLast1h,
      snowAmountLast1h: snowAmountLast1h,
      sunrise: DateTime.fromMillisecondsSinceEpoch(
        (json['sunrise']) * 1000,
        isUtc: true,
      ),
      sunset: DateTime.fromMillisecondsSinceEpoch(
        (json['sunset']) * 1000,
        isUtc: true,
      ),
      timeStamp: DateTime.fromMillisecondsSinceEpoch(
        (json['dt']) * 1000,
        isUtc: true,
      ),
    );
  }
}
