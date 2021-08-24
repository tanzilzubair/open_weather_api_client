import 'package:open_weather_api_client/src/Current_Weather/current_weather_model.dart';
import 'package:open_weather_api_client/src/Utilities/location_coords.dart';
import '../Utilities/units_settings.dart';
import 'Data_Models/one_call_components.dart';

/// This is the class that handles JSON deserialization and makes data for OneCall weather queries accessible.
/// The fields in this class differ slightly to [CurrentWeather] as the API provides different fields
/// when querying the Current Weather API endpoint and the One Call API Endpoint.
class OneCallWeather {
  /// The longitude and latitude for the city for which the weather was queried
  LocationCoords? locationCoords;

  /// The name of the timezone
  /// the queried location is in
  String? timeZoneName;

  /// The timezone offset from UTC time of the location for which the weather was queried, in seconds
  int? timeZoneOffset;

  /// The current weather forecast for the queried location. The fields in this class differ slightly to [CurrentWeather]
  /// as the API provides different fields when querying the Current Weather API endpoint and the One Call API Endpoint
  OneCallCurrentWeather? currentWeather;

  /// The minute by minute weather forecast for the next hour. Each item in the list is a minute, with the instance at index 0 being
  /// chronologically the first minute, and the instance at index 59 chronologically the last minute
  List<OneCallMinutelyWeather?>? minutelyWeather;

  /// The hour by hour forecast for the next 48 hours. Each item in the list is an hour, with the instance at index 0 being
  /// chronologically the first hour, and the instance at index 47 being chronologically the last hour
  List<OneCallHourlyWeather?>? hourlyWeather;

  /// The day by day forecast for the next 7 days, including the current day. Each item in the list is a day, with the instance at index 0 being
  /// today, and the instance at index 7 being chronologically the 7th day
  List<OneCallDailyWeather?>? dailyWeather;

  /// National weather alerts provided by different major national weather warning systems
  OneCallAlertsWeather? alertsWeather;

  OneCallWeather({
    this.locationCoords,
    this.timeZoneName,
    this.timeZoneOffset,
    this.currentWeather,
    this.minutelyWeather,
    this.hourlyWeather,
    this.dailyWeather,
    this.alertsWeather,
  });

  /// JSON deserialization constructor
  factory OneCallWeather.fromJson(
    Map<String, dynamic> json,
    UnitSettings settings,
  ) {
    // Looping through the array of minutely weather JSON and parsing them into a list, but only if
    // the JSON is not null, as some requests sometimes don't include specific parts
    List? minutelyPayload = json['minutely'];
    List<OneCallMinutelyWeather?>? minutelyWeather;
    if (minutelyPayload != null) {
      minutelyWeather = minutelyPayload.map(
        (e) {
          return OneCallMinutelyWeather.fromJson(
            e,
            settings,
          );
        },
      ).toList();
    } else {
      minutelyWeather = null;
    }

    // Looping through the array of hourly weather JSON and parsing them into a list, but only if
    // the JSON is not null, as some requests sometimes don't include specific parts
    List? hourlyPayload = json['hourly'];
    List<OneCallHourlyWeather?>? hourlyWeather;
    if (hourlyPayload != null) {
      hourlyWeather = hourlyPayload.map(
        (e) {
          return OneCallHourlyWeather.fromJson(
            e,
            settings,
          );
        },
      ).toList();
    } else {
      hourlyWeather = null;
    }

    // Looping through the array of daily weather JSON and parsing them into a list, but only if
    // the JSON is not null, as some requests sometimes don't include specific parts
    List? dailyPayload = json['daily'];
    List<OneCallDailyWeather?>? dailyWeather;

    if (dailyPayload != null) {
      dailyWeather = dailyPayload.map((e) {
        return OneCallDailyWeather.fromJson(
          e,
          settings,
        );
      }).toList();
    } else {
      dailyWeather = null;
    }

    return OneCallWeather(
      locationCoords: LocationCoords(
        latitude: json['lat'],
        longitude: json['lon'],
      ),
      timeZoneName: json['timezone'],
      timeZoneOffset: json['timezone_offset'],
      currentWeather: OneCallCurrentWeather.fromJson(
        json['current'],
        settings,
      ),
      minutelyWeather: minutelyWeather,
      hourlyWeather: hourlyWeather,
      dailyWeather: dailyWeather,
      alertsWeather: OneCallAlertsWeather.fromJson(
        json['alerts'],
        settings,
      ),
    );
  }
}
