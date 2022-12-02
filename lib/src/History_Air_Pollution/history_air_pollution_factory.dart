import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:open_weather_api_client/src/Utilities/location_coords.dart';
import 'package:open_weather_api_client/src/Utilities/start_end.dart';
import 'package:open_weather_api_client/src/Utilities/request_response.dart';
import 'package:retry/retry.dart';

import '../Utilities/general_enums.dart';
import '../Utilities/weather_factory_utilities.dart';
import 'history_air_pollution_model.dart';

/// This class queries the Current Air pollution API endpoint, the docs to which can be found at [https://openweathermap.org/api/air-pollution]
class HistoryAirPollutionFactory {
  /// The field representing apikey for openweathermap api
  String apiKey;

  /// The language defaults to English
  Language language;

  /// The instance of [LocationCoords] that must be provided if you want to obtain
  /// the weather using longitude and latitude
  LocationCoords locationCoords;

  /// Interval
  StartEnd interval;

  /// This is the maximum amount of time that the factory waits for a request to the server to complete, before retrying or
  /// returning an error
  Duration maxTimeBeforeTimeout;

  HistoryAirPollutionFactory({
    required this.apiKey,
    this.language = Language.ENGLISH,
    required this.locationCoords,
    required this.interval,
    this.maxTimeBeforeTimeout = const Duration(seconds: 3),
  });

  /// Public function to get the air pollution for a given saved location
  Future<RequestResponse<HistoryAirPollution?>>
      getForecastAirPollution() async {
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
      return _geoRequest(
        coords: LocationCoords(
          latitude: locationCoords.latitude,
          longitude: locationCoords.longitude,
        ),
        interval: interval,
      );
    } else {
      /// There is a connection error as connectionCheck() returned InternetStatus.Disconnected
      return RequestResponse(
        requestStatus: RequestStatus.ConnectionError,
        response: null,
      );
    }
  }

  /// Helper function for location queries
  Future<RequestResponse<HistoryAirPollution?>> _geoRequest({
    required LocationCoords coords,
    required StartEnd       interval,
  }) async {
    WeatherFactoryUtilities utilities = WeatherFactoryUtilities(
      apiKey: apiKey,
      language: language,
      maxTimeBeforeTimeout: maxTimeBeforeTimeout,
    );
    Uri request = utilities.buildURL(
      requestType: RequestType.HistoryAirPollution,
      location: coords,
      duration: interval,
    );

    /// Handling timeout error
    RetryOptions r = RetryOptions(
      delayFactor: Duration(
        milliseconds: 150,
      ),
      maxAttempts: 4,
      maxDelay: Duration(seconds: 2),
      randomizationFactor: 0.2,
    );

    dynamic response;
    try {
      response = await r.retry(
        () {
          return http.get(request).timeout(maxTimeBeforeTimeout);
        },
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
    } on SocketException {
      return RequestResponse<HistoryAirPollution?>(
        requestStatus: RequestStatus.UnknownError,
        response: null,
      );
    } on TimeoutException {
      return RequestResponse<HistoryAirPollution?>(
        requestStatus: RequestStatus.TimeoutError,
        response: null,
      );
    } catch (e) {
      return RequestResponse<HistoryAirPollution?>(
        requestStatus: RequestStatus.UnknownError,
        response: null,
      );
    }

    /// Decoding the json response
    final payLoad = json.decode(response.body) as Map<String, dynamic>;

    /// Checking for error status codes from server response
    return _checkForErrors(payLoad: payLoad);
  }

  /// Error checking function for queries
  Future<RequestResponse<HistoryAirPollution?>> _checkForErrors({
    required Map<String, dynamic> payLoad,
  }) async {
    if (payLoad.containsValue("404")) {
      /// This error is for when impossible value for the longitude
      /// and latitude is sent to the server, or when (rarely) the server may not support
      /// weather queries for that location
      return RequestResponse<HistoryAirPollution?>(
        requestStatus: RequestStatus.NonExistentError,
        response: null,
      );
    } else if (payLoad.containsValue("429")) {
      /// This error is for when the API Key provided has exceeded its quota
      return RequestResponse<HistoryAirPollution?>(
        requestStatus: RequestStatus.OverloadError,
        response: null,
      );
    } else {
      final airPollution = HistoryAirPollution.fromJson(payLoad);

      /// The request is successful
      return RequestResponse<HistoryAirPollution?>(
        requestStatus: RequestStatus.Successful,
        response: airPollution,
      );
    }
  }
}
