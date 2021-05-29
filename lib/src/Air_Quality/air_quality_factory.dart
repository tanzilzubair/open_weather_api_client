import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:open_weather_api_client/src/Utilities/location_coords.dart';
import 'package:open_weather_api_client/src/Utilities/request_response.dart';
import 'package:retry/retry.dart';

import '../Utilities/general_enums.dart';
import '../Utilities/weather_factory_utilities.dart';
import 'air_quality_model.dart';

/// This class queries the Current Weather API endpoint, the docs to which can be found at [https://openweathermap.org/current]
class AirQualityFactory {
  String apiKey;

  /// The instance of [LocationCoords] that must be provided
  LocationCoords locationCoords;

  /// This is the maximum amount of time that the factory waits for a request to the server to complete, before retrying or
  /// returning an error
  Duration maxTimeBeforeTimeout;

  /// TODO: Implement check to see it doesn't cross the nvoember date
  /// This is the time a historical query for air pollution data starts from.
  /// NOTE: Historical dara is accessible from the 27th of November, 2020 onwards
  Duration? historicalQueryStartTime;

  /// This is the time a historical query for air pollution data ends at
  /// NOTE: Historical dara is accessible from the 27th of November, 2020 onwards
  Duration? historicalQueryEndTime;

  AirQualityFactory({
    required this.apiKey,
    required this.locationCoords,
    this.historicalQueryStartTime,
    this.historicalQueryEndTime,
    this.maxTimeBeforeTimeout = const Duration(seconds: 3),
  }) : assert(
          (historicalQueryStartTime == null &&
                  historicalQueryEndTime == null) ||
              (historicalQueryStartTime != null &&
                  historicalQueryEndTime != null),
          "A start time AND an end time must be provided for querying historical data",
        );

  /// Public function to get the weather for a given saved city
  Future<RequestResponse<AirQuality?>> getWeather() async {
    /// Initializing the utilities
    WeatherFactoryUtilities utilities = WeatherFactoryUtilities(
      apiKey: apiKey,
      maxTimeBeforeTimeout: maxTimeBeforeTimeout,
    );

    /// Checking whether connected to the internet
    InternetStatus status = await utilities.connectionCheck();
    if (status == InternetStatus.Connected) {
      if (locationCoords != null) {
        /// Handing info to be requested and returning the info
        return _geoRequest(
          coords: LocationCoords(
            latitude: locationCoords!.latitude,
            longitude: locationCoords!.longitude,
          ),
        );
      } else {
        if (cityName!.isEmpty == true) {
          /// Checking for empty text (This is not usually an issue if the text is provided programmatically,
          /// but if the factory is hooked up directly to a TextField widget, and the user accidentally presses
          /// send on an empty widget, an empty String may be passed here
          return RequestResponse(
            RequestStatus.EmptyError,
            null,
          );
        } else {
          /// Handing info to be requested and returning the info
          _sanitizeInput(cityName: cityName!);
          return _namedRequest(cityName: cityName!);
        }
      }
    } else {
      /// There is a connection error as connectionCheck() returned InternetStatus.Disconnected
      return RequestResponse(
        RequestStatus.ConnectionError,
        null,
      );
    }
  }

  /// Helper function for named queries
  Future<RequestResponse<AirQuality?>> _namedRequest(
      {required String cityName}) async {
    WeatherFactoryUtilities utilities = WeatherFactoryUtilities(
      apiKey: apiKey,
      language: language,
      maxTimeBeforeTimeout: maxTimeBeforeTimeout,
    );
    Uri request = utilities.buildURL(
        requestType: RequestType.AirQuality, cityName: cityName);

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
          return http.get(request).timeout(maxTimeBeforeTimeout);
        },
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
    } on SocketException {
      return RequestResponse<AirQuality?>(
        RequestStatus.UnknownError,
        null,
      );
    } on TimeoutException {
      return RequestResponse<AirQuality?>(
        RequestStatus.TimeoutError,
        null,
      );
    } catch (e) {
      return RequestResponse<AirQuality?>(
        RequestStatus.UnknownError,
        null,
      );
    }
    final payLoad = json.decode(response.body) as Map<String, dynamic>;

    /// Checking for error status codes from server response
    return _checkForErrors(payLoad: payLoad);
  }

  /// Helper function for formatting the cityName for named queries
  String _sanitizeInput({required String cityName}) {
    cityName.toLowerCase();
    cityName.trim();
    return cityName;
  }

  /// Helper function for location queries
  Future<RequestResponse<AirQuality?>> _geoRequest(
      {required LocationCoords coords}) async {
    WeatherFactoryUtilities utilities = WeatherFactoryUtilities(
      apiKey: apiKey,
      language: language,
      maxTimeBeforeTimeout: maxTimeBeforeTimeout,
    );
    Uri request = utilities.buildURL(
      requestType: RequestType.AirQuality,
      location: coords,
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
      return RequestResponse<AirQuality?>(
        RequestStatus.UnknownError,
        null,
      );
    } on TimeoutException {
      return RequestResponse<AirQuality?>(
        RequestStatus.TimeoutError,
        null,
      );
    } catch (e) {
      return RequestResponse<AirQuality?>(
        RequestStatus.UnknownError,
        null,
      );
    }

    /// Decoding the json response
    final payLoad = json.decode(response.body) as Map<String, dynamic>;

    /// Checking for error status codes from server response
    return _checkForErrors(payLoad: payLoad);
  }

  /// Error checking function for queries
  Future<RequestResponse<AirQuality?>> _checkForErrors(
      {required Map<String, dynamic> payLoad}) async {
    if (payLoad.containsValue("404")) {
      /// This error is for when a city name with a typo or a impossible value for the longitude
      /// and latitude is sent to the server, or when (rarely) the server may not support
      /// weather queries for that location
      return RequestResponse<AirQuality?>(
        RequestStatus.NonExistentError,
        null,
      );
    } else if (payLoad.containsValue("429")) {
      /// This error is for when the API Key provided has exceeded its quota
      return RequestResponse<AirQuality?>(
        RequestStatus.OverloadError,
        null,
      );
    } else {
      AirQuality weather = AirQuality.fromJson(payLoad, settings);

      /// The request is successful
      return RequestResponse<AirQuality?>(
        RequestStatus.Successful,
        weather,
      );
    }
  }
}
