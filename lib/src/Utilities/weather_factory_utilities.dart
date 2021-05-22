import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_icmp_ping/flutter_icmp_ping.dart';
import 'package:open_weather_api_client/src/Utilities/languages.dart';
import 'package:open_weather_api_client/src/Utilities/location_coords.dart';
import 'general_enums.dart';

class WeatherFactoryUtilities {
  late String apiKey;
  late Language language;

  WeatherFactoryUtilities({required this.apiKey, required this.language});

  /// Helper function for queries
  Uri buildURL({
    required RequestType requestType,
    List<ExcludeField>? exclusions,
    String? cityName,
    LocationCoords? location,
  }) {
    String tag = _findRequestType(requestType: requestType);
    String url = 'https://api.openweathermap.org/data/2.5/' + '$tag?';
    if (cityName != null) {
      url += 'q=$cityName&';
    } else if (location != null) {
      url += 'lat=${location.latitude}&lon=${location.longitude}&';
      if (requestType == RequestType.OneCall && exclusions != null) {
        url += _computeExclusion(exclusions: exclusions);
      }
    }
    url += 'appid=$apiKey&';
    url += 'lang=${languageCode[language]}';
    return Uri.parse(url);
  }

  /// Connectivity checker
  Future<InternetStatus> connectionCheck() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    InternetStatus status = InternetStatus.Undetermined;
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      bool internetPresent = false;
      Ping ping = Ping(
        'google.com',
        count: 1,
      );
      await for (PingData event in ping.stream) {
        if (event.response != null) {
          internetPresent = true;
        } else if (event.response == null && event.summary == null) {
          internetPresent = false;
        }
        if (internetPresent == true) {
          status = InternetStatus.Connected;
        } else {
          status = InternetStatus.Disconnected;
        }
      }
    } else if (result == ConnectivityResult.none) {
      status = InternetStatus.Disconnected;
    }
    return status;
  }

  /// Helper function for queries
  String _findRequestType({required RequestType requestType}) {
    String request = '';
    if (requestType == RequestType.CurrentWeather) {
      request = 'weather';
    } else if (requestType == RequestType.OneCall) {
      request = "onecall";
    }
    return request;
  }

  /// Helper function for finding which fields are to be excluded from the request
  String _computeExclusion({required List<ExcludeField> exclusions}) {
    String url = 'exclude=';
    if (exclusions.contains(ExcludeField.CurrentForecast)) {
      url += 'current,';
    }
    if (exclusions.contains(ExcludeField.MinutelyForecast)) {
      url += 'minutely,';
    }
    if (exclusions.contains(ExcludeField.HourlyForecast)) {
      url += 'hourly,';
    }
    if (exclusions.contains(ExcludeField.DailyForecast)) {
      url += 'daily';
    }
    if (exclusions.contains(ExcludeField.Alerts)) {
      url += 'alerts';
    }
    url += '&';
    return url;
  }
}
