import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:open_weather_api_client/src/Utilities/location_coords.dart';
import 'package:open_weather_api_client/src/Utilities/request_response.dart';
import 'package:open_weather_api_client/src/Utilities/units_settings.dart';
import 'package:retry/retry.dart';

import '../Utilities/general_enums.dart';
import '../Utilities/weather_factory_utilities.dart';
import 'one_call_weather_model.dart';

/// This class queries the OneCall Weather API endpoint, the docs to which can be found at [https://openweathermap.org/api/one-call-api]
class OneCallWeatherFactory {
  String apiKey;

  /// The language defaults to English
  Language language;

  /// The unit settings determine the data from the server is converted to
  UnitSettings settings;

  /// The instance of [LocationCoords] that must be provided if you want to obtain
  /// the weather using longitude and latitude
  LocationCoords? locationCoords;

  /// This takes an array of type ExcludeField. Any fields, such as the daily weather, the hourly weather, weather alertss
  /// that you do not want to query, include them here by providing the corresponding [ExcludeField] enum
  List<ExcludeField>? exclusions;

  /// This is the maximum amount of time that the factory waits for a request to the server to complete, before retrying or
  /// returning an error
  Duration maxTimeBeforeTimeout;

  OneCallWeatherFactory({
    required this.apiKey,
    this.language = Language.ENGLISH,
    required this.settings,
    this.locationCoords,
    this.exclusions,
    this.maxTimeBeforeTimeout = const Duration(seconds: 20),
  }) : assert(
          locationCoords != null,
          "A city name or an instance of LocationCoords must be provided",
        );

  /// Public function to get the weather for a given latitude and longitude
  Future<RequestResponse<OneCallWeather?>> getWeather() async {
    /// Initializing the utilities
    WeatherFactoryUtilities utilities = WeatherFactoryUtilities(
      apiKey: apiKey,
      language: language,
      maxTimeBeforeTimeout: maxTimeBeforeTimeout,
    );

    /// Checking whether connected to the internet
    InternetStatus status = await utilities.connectionCheck();
    if (status == InternetStatus.Connected) {
      /// Handing info to be requested and returning the info
      return _oneCallRequest(
        coords: LocationCoords(
          latitude: locationCoords!.latitude,
          longitude: locationCoords!.longitude,
        ),
      );
    } else {
      /// There is a connection error as connectionCheck() returned InternetStatus.Disconnected
      return RequestResponse<OneCallWeather?>(
        RequestStatus.ConnectionError,
        null,
      );
    }
  }

  /// Helper function for location queries
  Future<RequestResponse<OneCallWeather?>> _oneCallRequest(
      {required LocationCoords coords}) async {
    WeatherFactoryUtilities utilities = WeatherFactoryUtilities(
      apiKey: apiKey,
      language: language,
      maxTimeBeforeTimeout: maxTimeBeforeTimeout,
    );
    Uri request = utilities.buildURL(
      requestType: RequestType.OneCall,
      location: coords,
      exclusions: exclusions,
    );

    /// Handling timeout error
    RetryOptions r = RetryOptions(
      delayFactor: Duration(
        milliseconds: 150,
      ),
      maxAttempts: 4,
      maxDelay: Duration(seconds: maxTimeBeforeTimeout.inSeconds),
      randomizationFactor: 0.2,
    );

    dynamic response;
    try {
      response = await r.retry(
        () {
          return http.get(request).timeout(
                maxTimeBeforeTimeout,
              );
        },
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
    } on SocketException {
      return RequestResponse<OneCallWeather?>(
        RequestStatus.UnknownError,
        null,
      );
    } on TimeoutException {
      return RequestResponse<OneCallWeather?>(
        RequestStatus.TimeoutError,
        null,
      );
    } catch (e) {
      return RequestResponse<OneCallWeather?>(
        RequestStatus.UnknownError,
        null,
      );
    }
    final payLoad = json.decode(response.body) as Map<String, dynamic>;
    print("Json in part 1: ${payLoad['minutely'][4]['dt']}");

    /// Checking for error status codes from server response
    return _checkForErrors(payLoad: payLoad);
  }

  /// Error checking function for queries
  Future<RequestResponse<OneCallWeather?>> _checkForErrors(
      {required Map<String, dynamic> payLoad}) async {
    if (payLoad.containsValue("404")) {
      /// This error is for when a city name with a typo or a impossible value for the longitude
      /// and latitude is sent to the server, or when (rarely) the server may not support
      /// weather queries for that location
      return RequestResponse<OneCallWeather?>(
        RequestStatus.NonExistentError,
        null,
      );
    } else if (payLoad.containsValue("429")) {
      /// This error is for when the API Key provided has exceeded its quota
      return RequestResponse<OneCallWeather?>(
        RequestStatus.OverloadError,
        null,
      );
    } else {
      OneCallWeather weather = OneCallWeather.fromJson(payLoad, settings);

      /// The request is successful
      return RequestResponse<OneCallWeather?>(
        RequestStatus.Successful,
        weather,
      );
    }
  }
}
