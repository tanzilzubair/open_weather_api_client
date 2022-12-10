/// This class is used to provide the start and end time of history data to a weather factory
class StartEnd {
  StartEnd({required this.start, required this.end});

  /// The start of historical data
  final int start;

  /// The end of historical data
  final int end;
}
