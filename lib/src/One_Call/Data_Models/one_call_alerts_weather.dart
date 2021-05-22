import '../../Utilities/units_settings.dart';

/// This is the class that handles JSON deserialization and makes data for alerts received from
/// queries to the OneCall API endpoint accessible.
class OneCallAlertsWeather {
  /// The name of the alert source
  String? senderName;

  /// The name of the alert
  String? alertName;

  /// The start time of the alert, in UTC time
  DateTime? startTime;

  /// The send time of the alert, in UTC time
  DateTime? endTime;

  /// A large description of the alert
  String? description;

  OneCallAlertsWeather({
    this.senderName,
    this.alertName,
    this.startTime,
    this.endTime,
    this.description,
  });

  factory OneCallAlertsWeather.fromJson(
    Map<String, dynamic> json,
    UnitSettings settings,
  ) {
    return OneCallAlertsWeather(
      senderName: json['sender_name'],
      alertName: json['event'],
      startTime: DateTime.fromMillisecondsSinceEpoch(
        (json['start']) * 1000,
        isUtc: true,
      ),
      endTime: DateTime.fromMillisecondsSinceEpoch(
        (json['end']) * 1000,
        isUtc: true,
      ),
      description: json['description'],
    );
  }
}
