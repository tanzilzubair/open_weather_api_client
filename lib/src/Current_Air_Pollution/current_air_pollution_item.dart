import 'dart:convert';

import '/src/air_pollution/components.dart';

/// This class represents base air pollution data
class CurrentAirPollutionItem {
  /// This field represents air quality index
  final int aqi;

  /// This field represents specific components of air pollution
  final Components components;

  /// This field represents utc date time
  final DateTime? timeStamp;

  const CurrentAirPollutionItem({
    required this.aqi,
    required this.components,
    required this.timeStamp,
  });

  /// From map constructor used for JSON deserialization
  factory CurrentAirPollutionItem.fromMap(Map<String, dynamic> map) {
    return CurrentAirPollutionItem(
      aqi: map['main']['aqi'].toInt(),
      components: Components.fromMap(map['components']),
      timeStamp: DateTime.fromMillisecondsSinceEpoch(
        (map['dt']) * 1000,
        isUtc: true,
      ),
    );
  }

  /// JSON deserialization constructor
  factory CurrentAirPollutionItem.fromJson(String source) =>
      CurrentAirPollutionItem.fromMap(json.decode(source));

  @override
  String toString() =>
      'AirPollutionItem(aqi: $aqi, components: $components, dt: $timeStamp)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CurrentAirPollutionItem &&
        other.aqi == aqi &&
        other.components == components &&
        other.timeStamp == timeStamp;
  }

  @override
  int get hashCode => aqi.hashCode ^ components.hashCode ^ timeStamp.hashCode;
}
