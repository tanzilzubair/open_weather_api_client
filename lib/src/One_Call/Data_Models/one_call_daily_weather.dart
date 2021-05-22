import '../../Utilities/general_enums.dart';
import '../../Utilities/unit_conversions.dart';
import '../../Utilities/units_settings.dart';

class OneCallDailyWeather {
  WeatherType? weatherType;
  String? mainDescription;
  String? secondaryDescription;

  num? tempMorning;
  num? tempDay;
  num? tempEvening;
  num? tempNight;
  num? tempMin;
  num? tempMax;

  num? feelsLikeTempMorning;
  num? feelsLikeTempDay;
  num? feelsLikeTempEvening;
  num? feelsLikeTempNight;

  num? dewPoint;

  num? humidity;
  num? cloudiness;

  num? uvi;
  num? pressure;

  num? windSpeed;
  int? windDegree;
  num? windGustSpeed;

  int? precipitationChance;
  num? rainAmount;

  num? snowAmount;

  DateTime? sunrise;
  DateTime? sunset;
  DateTime? moonrise;
  DateTime? moonset;
  double? moonPhase;
  DateTime? timeStamp;

  OneCallDailyWeather({
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
    this.dewPoint,
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
    num? dewPoint = temperatureToSelectedUnit(
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
      dewPoint: dewPoint,
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
