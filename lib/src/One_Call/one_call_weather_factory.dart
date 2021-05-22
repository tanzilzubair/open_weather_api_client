import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:open_weather_api_client/src/Utilities/languages.dart';
import 'package:open_weather_api_client/src/Utilities/location_coords.dart';
import 'package:open_weather_api_client/src/Utilities/units_settings.dart';
import 'package:retry/retry.dart';
import 'package:tuple/tuple.dart';

import '../Utilities/general_enums.dart';
import '../Utilities/weather_factory_utilities.dart';
import 'one_call_weather_model.dart';

/// This class queries the OneCall Weather API endpoint, the docs to which can be found here [https://openweathermap.org/api/one-call-api]
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

  OneCallWeatherFactory({
    required this.apiKey,
    this.language = Language.ENGLISH,
    required this.settings,
    this.locationCoords,
    this.exclusions,
  }) : assert(
          locationCoords != null,
          "A city name or an instance of LocationCoords must be provided",
        );

  /// Public function to get the weather for a given latitude and longitude
  Future<Tuple2<RequestStatus, OneCallWeather?>> getWeather() async {
    /// Initializing the utilities
    WeatherFactoryUtilities utilities = WeatherFactoryUtilities(
      apiKey: apiKey,
      language: language,
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
      return Tuple2(RequestStatus.ConnectionError, null);
    }
  }

  /// Helper function for location queries
  Future<Tuple2<RequestStatus, OneCallWeather?>> _oneCallRequest(
      {required LocationCoords coords}) async {
    WeatherFactoryUtilities utilities = WeatherFactoryUtilities(
      apiKey: apiKey,
      language: language,
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
        maxDelay: Duration(seconds: 2),
        randomizationFactor: 0.2);

    dynamic response;
    try {
      response = await r.retry(
        () {
          return http.get(request).timeout(
                Duration(seconds: 3),
              );
        },
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
    } on SocketException {
      return Tuple2(RequestStatus.UnknownError, null);
    } on TimeoutException {
      return Tuple2(RequestStatus.TimeoutError, null);
    } catch (e) {
      return Tuple2(RequestStatus.UnknownError, null);
    }
    final payLoad = json.decode(response.body) as Map<String, dynamic>;

    /// Checking for error status codes from server response
    return _checkForErrors(payLoad: payLoad);
  }

  /// Error checking function for queries
  Future<Tuple2<RequestStatus, OneCallWeather?>> _checkForErrors(
      {required Map<String, dynamic> payLoad}) async {
    if (payLoad.containsValue("404")) {
      /// This error is for when a city name with a typo or a impossible value for the longitude
      /// and latitude is sent to the server, or when (rarely) the server may not support
      /// weather queries for that location
      return Tuple2(RequestStatus.NonExistentError, null);
    } else if (payLoad.containsValue("429")) {
      /// This error is for when the API Key provided has exceeded its quota
      return Tuple2(RequestStatus.OverloadError, null);
    } else {
      OneCallWeather weather = OneCallWeather.fromJson(payLoad, settings);

      /// The request is successful
      return Tuple2(RequestStatus.Successful, weather);
    }
  }
}
