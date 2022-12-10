import 'package:flutter/foundation.dart';

import '../Utilities/air_pollution_item.dart';
import '../Utilities/location_coords.dart';

/// This is the class that handles JSON deserialization and makes data for CurrentAirPollution queries accessible.
class HistoryAirPollution {
  /// The longitude and latitude for the city for which the air pollution was queried
  final LocationCoords locationCoords;

  /// The object representing air pollution data list
  final List<AirPollutionItem> airPollutionItem;

  HistoryAirPollution({
    required this.locationCoords,
    required this.airPollutionItem,
  });

  /// JSON deserialization constructor
  factory HistoryAirPollution.fromJson(
    Map<String, dynamic> json,
  ) {
    final list = json['list'] as List<dynamic>;

    return HistoryAirPollution(
      locationCoords: LocationCoords(
        longitude: json['coord']['lon'],
        latitude: json['coord']['lat'],
      ),
      airPollutionItem: list.map((e) => AirPollutionItem.fromMap(e)).toList(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HistoryAirPollution &&
        other.locationCoords == locationCoords &&
        listEquals(other.airPollutionItem, airPollutionItem);
  }

  @override
  int get hashCode => locationCoords.hashCode ^ airPollutionItem.hashCode;
}
