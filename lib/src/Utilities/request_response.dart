import 'package:open_weather_api_client/open_weather_api_client.dart';

/// The response, used to return the RequestStatus and the data model
class RequestResponse<T> {
  /// The request status
  final RequestStatus requestStatus;

  /// The request response
  final T response;

  const RequestResponse(
    this.requestStatus,
    this.response,
  );
}
