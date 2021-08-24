import '../../Utilities/general_enums.dart';
import '../../Utilities/unit_conversions.dart';
import '../../Utilities/units_settings.dart';

/// This is the class that handles JSON deserialization and makes data for the daily weather
/// forecast received from queries to the OneCall API endpoint accessible.
class OneCallDailyWeather {
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

  /// The temperature in the morning, in Celsius by default
  num? tempMorning;

  /// The temperature during the day, in Celsius by default
  num? tempDay;

  /// The temperature in the evening, in Celsius by default
  num? tempEvening;

  /// The temperature at night, in Celsius by default
  num? tempNight;

  /// The minimum temperature on that day
  num? tempMin;

  /// The maximum temperature on that day
  num? tempMax;

  /// The temperature in the morning, accounting for human perception, in Celsius by default
  num? feelsLikeTempMorning;

  /// The temperature during the day, accounting for human perception, in Celsius by default
  num? feelsLikeTempDay;

  /// The temperature in the evening, accounting for human perception, in Celsius by default
  num? feelsLikeTempEvening;

  /// The temperature at night, accounting for human perception, in Celsius by default
  num? feelsLikeTempNight;

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

  /// The atmospheric pressure, in hecto-pascals by default
  num? pressure;

  /// The wind speed, in km/h by default
  num? windSpeed;

  /// The direction of the wind, in degrees
  int? windDegree;

  /// The wind gust speed, in km/h by default
  num? windGustSpeed;

  /// The probability of precipitation on that day, as a percentage
  int? precipitationChance;

  /// The amount of predicted rainfall that day, in millimetres by default
  num? rainAmount;

  /// The amount of predicted snowfall that day, in millimetres by default
  num? snowAmount;

  /// The time of sunrise for that day, in UTC time
  DateTime? sunrise;

  /// The time of sunset for that day, in UTC time
  DateTime? sunset;

  /// The time when the moon rises, in UTC time
  DateTime? moonrise;

  /// The time when the moon sets, in UTC time
  DateTime? moonset;

  /// The phase of the moon.
  /// - A value of 0 or 1 is a new moon.
  /// - A value between 0 and 0.25 is a waxing crescent
  /// - A value of 0.25 is a first quarter moon
  /// - A value between 0.25 and 0.5 is a waxing gibbous
  /// - A value of 0.5 is a full moon
  /// - A value between 0.5 and 0.75 is a waning gibbous
  /// - A value of 0.75 is a last quarter moon
  /// - A value between 0.75 and 1 is a waning crescent
  double? moonPhase;

  /// The timestamp of when the data was requested, in UTC time
  DateTime? timeStamp;

  OneCallDailyWeather({
    this.weatherID,
    this.iconID,
    this.weatherType,
    this.mainDescription,
    this.secondaryDescription,
    this.tempMorning,
    this.tempDay,
    this.tempEvening,
    this.tempNight,
    this.tempMin,
    this.tempMax,
    this.feelsLikeTempMorning,
    this.feelsLikeTempDay,
    this.feelsLikeTempEvening,
    this.feelsLikeTempNight,
    this.dewPointTemp,
    this.humidity,
    this.cloudiness,
    this.uvi,
    this.pressure,
    this.windSpeed,
    this.windDegree,
    this.windGustSpeed,
    this.precipitationChance,
    this.rainAmount,
    this.snowAmount,
    this.sunrise,
    this.sunset,
    this.moonrise,
    this.moonset,
    this.moonPhase,
    this.timeStamp,
  });

  /// JSON deserialization constructor
  factory OneCallDailyWeather.fromJson(
    Map<String, dynamic> json,
    UnitSettings settings,
  ) {
    // Mapping the iconId and ID to a WeatherType enum
    WeatherType weatherType = infoToWeatherType(
      id: json['weather'][0]['id'],
      iconId: json['weather'][0]['icon'],
    );

    // Formatting temperature
    num? tempMorning = temperatureToSelectedUnit(
      temp: json['temp']['morn'],
      unit: settings.temperatureUnit,
    );

    // Formatting temperature
    num? tempDay = temperatureToSelectedUnit(
      temp: json['temp']['day'],
      unit: settings.temperatureUnit,
    );

    // Formatting temperature
    num? tempEvening = temperatureToSelectedUnit(
      temp: json['temp']['eve'],
      unit: settings.temperatureUnit,
    );

    // Formatting temperature
    num? tempNight = temperatureToSelectedUnit(
      temp: json['temp']['night'],
      unit: settings.temperatureUnit,
    );

    // Formatting temperature
    num? tempMin = temperatureToSelectedUnit(
      temp: json['temp']['min'],
      unit: settings.temperatureUnit,
    );

    // Formatting temperature
    num? tempMax = temperatureToSelectedUnit(
      temp: json['temp']['max'],
      unit: settings.temperatureUnit,
    );

    // Formatting feels like temperature
    num? feelsLikeTempMorning = temperatureToSelectedUnit(
      temp: json['feels_like']['morn'],
      unit: settings.temperatureUnit,
    );

    // Formatting feels like temperature
    num? feelsLikeTempDay = temperatureToSelectedUnit(
      temp: json['feels_like']['day'],
      unit: settings.temperatureUnit,
    );

    // Formatting feels like temperature
    num? feelsLikeTempEvening = temperatureToSelectedUnit(
      temp: json['feels_like']['eve'],
      unit: settings.temperatureUnit,
    );

    // Formatting feels like temperature
    num? feelsLikeTempNight = temperatureToSelectedUnit(
      temp: json['feels_like']['night'],
      unit: settings.temperatureUnit,
    );

    // Formatting feels like temperature
    num? dewPointTemp = temperatureToSelectedUnit(
      temp: json['dew_point'],
      unit: settings.temperatureUnit,
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

    // Formatting the probability of precipitation
    int? pop = (json['pop']) * 100;
    int? precipitationChance = int.parse(pop!.toStringAsFixed(0));

    // Formatting the amount of rain
    num? rainAmount = precipitationToSelectedUnit(
      amount: json['rain'],
      unit: settings.precipitationUnit,
    );
    // Formatting the amount of snow
    num? snowAmount = precipitationToSelectedUnit(
      amount: json['snow'],
      unit: settings.precipitationUnit,
    );

    return OneCallDailyWeather(
      weatherID: json['weather'][0]['id'],
      iconID: json['weather'][0]['icon'],
      weatherType: weatherType,
      mainDescription: json['weather'][0]['main'],
      secondaryDescription: json['weather'][0]['description'],
      tempMorning: tempMorning,
      tempDay: tempDay,
      tempEvening: tempEvening,
      tempNight: tempNight,
      tempMin: tempMin,
      tempMax: tempMax,
      feelsLikeTempMorning: feelsLikeTempMorning,
      feelsLikeTempDay: feelsLikeTempDay,
      feelsLikeTempEvening: feelsLikeTempEvening,
      feelsLikeTempNight: feelsLikeTempNight,
      dewPointTemp: dewPointTemp,
      humidity: json['humidity'],
      cloudiness: json['clouds'],
      uvi: json['uvi'],
      pressure: pressure,
      windSpeed: windSpeed,
      windDegree: json['wind_deg'],
      windGustSpeed: windGustSpeed,
      precipitationChance: precipitationChance,
      rainAmount: rainAmount,
      snowAmount: snowAmount,
      sunrise: DateTime.fromMillisecondsSinceEpoch(
        (json['sunrise']) * 1000,
        isUtc: true,
      ),
      sunset: DateTime.fromMillisecondsSinceEpoch(
        (json['sunset']) * 1000,
        isUtc: true,
      ),
      moonrise: DateTime.fromMillisecondsSinceEpoch(
        (json['moonrise']) * 1000,
        isUtc: true,
      ),
      moonset: DateTime.fromMillisecondsSinceEpoch(
        (json['moonset']) * 1000,
        isUtc: true,
      ),
      moonPhase: json['moon_phase'],
      timeStamp: DateTime.fromMillisecondsSinceEpoch(
        (json['dt']) * 1000,
        isUtc: true,
      ),
    );
  }
}
