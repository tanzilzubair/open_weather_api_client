import 'dart:convert';

import '/src/air_pollution/components.dart';

/// This class represents base air pollution data
class AirPollutionItem {
  /// This field represents air quality index
  final int aqi;

  /// This field represents specific components of air pollution
  final Components components;

  /// This field represents utc date time
  final int dt;

  const AirPollutionItem({
    required this.aqi,
    required this.components,
    required this.dt,
  });

  /// From map constructor used for JSON deserialization
  factory AirPollutionItem.fromMap(Map<String, dynamic> map) {
    return AirPollutionItem(
      aqi: map['main']['aqi'].toInt(),
      components: Components.fromMap(map['components']),
      dt: map['dt'].toInt(),
    );
  }

  /// JSON deserialization constructor
  factory AirPollutionItem.fromJson(String source) =>
      AirPollutionItem.fromMap(json.decode(source));

  @override
  String toString() =>
      'AirPollutionItem(aqi: $aqi, components: $components, dt: $dt)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AirPollutionItem &&
        other.aqi == aqi &&
        other.components == components &&
        other.dt == dt;
  }

  @override
  int get hashCode => aqi.hashCode ^ components.hashCode ^ dt.hashCode;
}
