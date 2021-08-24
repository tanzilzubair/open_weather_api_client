import 'package:open_weather_api_client/open_weather_api_client.dart';

/// The response, used to return the RequestStatus and the weather data
class RequestResponse<T> {
  /// The request status
  final RequestStatus requestStatus;

  /// The request response
  final T response;

  const RequestResponse({
    required this.requestStatus,
    required this.response,
  });
}
