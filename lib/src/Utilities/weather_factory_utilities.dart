import 'dart:async';
import 'package:universal_io/io.dart';

import 'package:connectivity/connectivity.dart';
import 'package:open_weather_api_client/src/Utilities/languages.dart';
import 'package:open_weather_api_client/src/Utilities/location_coords.dart';
import 'general_enums.dart';

class WeatherFactoryUtilities {
  final String apiKey;
  final Language? language;
  final Duration maxTimeBeforeTimeout;
  final Duration? airQualityHistoricalQueryStartTime;
  final Duration? airQualityHistoricalQueryEndTime;

  WeatherFactoryUtilities({
    required this.apiKey,
    this.language,
    required this.maxTimeBeforeTimeout,
    this.airQualityHistoricalQueryStartTime,
    this.airQualityHistoricalQueryEndTime,
  });

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

    /// Note: The language property has no effect on Air Pollution queries, as all of the data the server
    /// sends is numerical in nature
    url += 'lang=${languageCode[language]}';
    print(url);
    return Uri.parse(url);
  }

  /// Connectivity checker
  Future<InternetStatus> connectionCheck() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    InternetStatus status = InternetStatus.Undetermined;
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      bool internetPresent = false;
      try {
        final result = await InternetAddress.lookup('example.com')
            .timeout(maxTimeBeforeTimeout);
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          internetPresent = true;
        } else {
          internetPresent = false;
        }
      } on SocketException {
        internetPresent = false;
      } on TimeoutException {
        internetPresent = false;
      } catch (e) {
        internetPresent = false;
      }
      if (internetPresent == true) {
        status = InternetStatus.Connected;
      } else {
        status = InternetStatus.Disconnected;
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
    } else if (requestType == RequestType.AirQuality) {
      request = "air_pollution";
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

/// TODO: You were in the middle of implementing the basis for Air Quality queries
