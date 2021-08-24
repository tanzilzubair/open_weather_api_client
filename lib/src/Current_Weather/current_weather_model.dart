import 'package:open_weather_api_client/src/Utilities/location_coords.dart';

import '../Utilities/general_enums.dart';
import '../Utilities/unit_conversions.dart';
import '../Utilities/units_settings.dart';

/// This is the class that handles JSON deserialization and makes data for CurrentWeather queries accessible.
/// The fields in this class differ slightly to [OneCallCurrentWeather] as the API provides different fields
/// when querying the One Call API Endpoint and the Current Weather API endpoint.
class CurrentWeather {
  /// The name of the city for which the weather was queried
  String? cityName;

  /// The country code of the city for which the weather was queried
  String? countryCode;

  /// The longitude and latitude for the city for which the weather was queried
  LocationCoords? locationCoords;

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

  /// The enum for identifying what the weather condition is. The main description parameter provides one suitable
  /// for display, so this is primarily provided to aid in implementing conditional logic dependent on the weather,
  /// for example, a dynamic background. It is based on the ID and icon string sent by OpenWeather for a specific
  /// request. I recommend you use this isntead of [weatherID] or [iconID]
  WeatherType? weatherType;

  /// This is the main, concise description for the current weather
  String? mainDescription;

  /// This is the secondary, longer description for the current weather
  String? secondaryDescription;

  /// The current temperature, in Celsius by default
  num? temp;

  /// The current temperature, accounting for human perception, in Celsius by default
  num? feelsLike;

  /// The minimum temperature for that area for that moment, in Celsius by default
  num? minTemp;

  /// The maximum temperature for that area for that moment, in Celsius by default
  num? maxTemp;

  /// The visibility for that area for that moment, in Kilometres by default
  num? visibility;

  /// The humidity, in percentage
  num? humidity;

  /// The cloudiness, in percentage
  num? cloudiness;

  /// The atmospheric pressure, in hecto-pascals by default
  num? pressure;

  /// The atmospheric pressure at ground level, in hecto-pascals by default
  num? pressureGroundLevel;

  /// The atmospheric pressure at sea level, in hecto-pascals by default
  num? pressureSeaLevel;

  /// The wind speed, in km/h by default
  num? windSpeed;

  /// The direction of the wind, in degrees
  int? windDegree;

  /// The wind gust speed, in km/h by default
  num? windGustSpeed;

  /// The amount of rainfall in the past 1 hour, in mm by default
  num? rainAmountLast1h;

  /// The amount of snowfall in the past 1 hour, in mm by default
  num? rainAmountLast3h;

  /// The amount of rainfall in the past 3 hours, in mm by default
  num? snowAmountLast1h;

  /// The amount of snowfall in the past 3 hours, in mm by default
  num? snowAmountLast3h;

  /// The time of sunrise for that day, in UTC time
  DateTime? sunrise;

  /// The time of sunset for that day, in UTC time
  DateTime? sunset;

  /// The timestamp of when the data was requested, in UTC time
  DateTime? timeStamp;

  /// The timezone offset from UTC time of the location for which the weather was queried, in seconds
  int? timezoneOffset;

  CurrentWeather({
    this.cityName,
    this.countryCode,
    this.locationCoords,
    this.weatherID,
    this.iconID,
    this.weatherType,
    this.mainDescription,
    this.secondaryDescription,
    this.temp,
    this.feelsLike,
    this.minTemp,
    this.maxTemp,
    this.visibility,
    this.humidity,
    this.cloudiness,
    this.pressure,
    this.pressureGroundLevel,
    this.pressureSeaLevel,
    this.windSpeed,
    this.windDegree,
    this.windGustSpeed,
    this.rainAmountLast1h,
    this.rainAmountLast3h,
    this.snowAmountLast1h,
    this.snowAmountLast3h,
    this.sunrise,
    this.sunset,
    this.timeStamp,
    this.timezoneOffset,
  });

  /// JSON deserialization constructor
  factory CurrentWeather.fromJson(
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
      temp: json['main']['temp'],
      unit: settings.temperatureUnit,
    );

    // Formatting feels like temperature
    num? feelsLike = temperatureToSelectedUnit(
      temp: json['main']['feels_like'],
      unit: settings.temperatureUnit,
    );

    // Formatting min temperature
    num? minTemp = temperatureToSelectedUnit(
      temp: json['main']['temp_min'],
      unit: settings.temperatureUnit,
    );

    // Formatting max temperature
    num? maxTemp = temperatureToSelectedUnit(
      temp: json['main']['temp_max'],
      unit: settings.temperatureUnit,
    );

    // Formatting the visibility
    num? visibility = distanceToSelectedUnit(
      distance: json['visibility'],
      unit: settings.distanceUnit,
    );
    // Formatting the pressure
    num pressure = pressureToSelectedUnit(
      pressure: json['main']['pressure'],
      unit: settings.pressureUnit,
    );

    // Formatting the pressure at ground level
    num pressureGroundLevel = pressureToSelectedUnit(
      pressure: json['main']['grnd_level'],
      unit: settings.pressureUnit,
    );

    // Formatting the pressure at sea level
    num pressureSeaLevel = pressureToSelectedUnit(
      pressure: json['main']['sea_level'],
      unit: settings.pressureUnit,
    );

    // Formatting the wind speed
    num? windSpeed = windSpeedToSelectedUnit(
      windSpeed: json['wind']['speed'],
      unit: settings.windSpeedUnit,
    );

    // Formatting the gust speed
    num? windGustSpeed = windSpeedToSelectedUnit(
      windSpeed: json['wind']['gust'],
      unit: settings.windSpeedUnit,
    );

    // Formatting the rain amount in the past 1 hour
    num? rainAmountLast1h = precipitationToSelectedUnit(
      amount: json['rain']['1h'],
      unit: settings.precipitationUnit,
    );

    // Formatting the rain amount in the past 3 hours
    num? rainAmountLast3h = precipitationToSelectedUnit(
      amount: json['rain']['3h'],
      unit: settings.precipitationUnit,
    );

    // Formatting the snow amount in the past 1 hour
    num? snowAmountLast1h = precipitationToSelectedUnit(
      amount: json['snow']['1h'],
      unit: settings.precipitationUnit,
    );

    // Formatting the snow amount in the past 3 hour
    num? snowAmountLast3h = precipitationToSelectedUnit(
      amount: json['snow']['3h'],
      unit: settings.precipitationUnit,
    );
    return CurrentWeather(
      cityName: json['name'],
      countryCode: json['sys']['country'],
      locationCoords: LocationCoords(
        longitude: json['coord']['lon'],
        latitude: json['coord']['lat'],
      ),
      weatherID: json['weather'][0]['id'],
      iconID: json['weather'][0]['icon'],
      weatherType: weatherType,
      mainDescription: json['weather'][0]['main'],
      secondaryDescription: json['weather'][0]['description'],
      temp: temp,
      feelsLike: feelsLike,
      minTemp: minTemp,
      maxTemp: maxTemp,
      visibility: visibility,
      humidity: json['main']['humidity'],
      cloudiness: json['clouds']['all'],
      pressure: pressure,
      pressureGroundLevel: pressureGroundLevel,
      pressureSeaLevel: pressureSeaLevel,
      windSpeed: windSpeed,
      windDegree: json['wind']['deg'],
      windGustSpeed: windGustSpeed,
      rainAmountLast1h: rainAmountLast1h,
      rainAmountLast3h: rainAmountLast3h,
      snowAmountLast1h: snowAmountLast1h,
      snowAmountLast3h: snowAmountLast3h,
      sunrise: DateTime.fromMillisecondsSinceEpoch(
        (json['sys']['sunrise']) * 1000,
        isUtc: true,
      ),
      sunset: DateTime.fromMillisecondsSinceEpoch(
        (json['sys']['sunset']) * 1000,
        isUtc: true,
      ),
      timeStamp: DateTime.fromMillisecondsSinceEpoch(
        (json['dt']) * 1000,
        isUtc: true,
      ),
      timezoneOffset: json['timezone'],
    );
  }
}
