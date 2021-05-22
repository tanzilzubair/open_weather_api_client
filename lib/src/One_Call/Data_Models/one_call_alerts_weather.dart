import '../../Utilities/units_settings.dart';

class OneCallAlertsWeather {
  String? senderName;
  String? alertName;
  DateTime? startTime;
  DateTime? endTime;
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
