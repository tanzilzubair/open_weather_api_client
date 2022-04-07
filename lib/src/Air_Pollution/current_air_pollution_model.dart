import '../Utilities/location_coords.dart';
import '../air_pollution/air_pollution_item.dart';

/// This is the class that handles JSON deserialization and makes data for CurrentAirPollution queries accessible.
class CurrentAirPollution {
  /// The longitude and latitude for the city for which the air pollution was queried
  final LocationCoords locationCoords;

  /// The object representing air pollution data
  final AirPollutionItem airPollutionItem;

  CurrentAirPollution({
    required this.locationCoords,
    required this.airPollutionItem,
  });

  /// JSON deserialization constructor
  factory CurrentAirPollution.fromJson(
    Map<String, dynamic> json,
  ) {
    final list = json['list'] as List<dynamic>;

    return CurrentAirPollution(
      locationCoords: LocationCoords(
        longitude: json['coord']['lon'],
        latitude: json['coord']['lat'],
      ),
      airPollutionItem: AirPollutionItem.fromMap(list[0]),
    );
  }

  @override
  String toString() =>
      'CurrentAirPollution(locationCoords: $locationCoords, airPollutionItem: $airPollutionItem)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CurrentAirPollution &&
        other.locationCoords == locationCoords &&
        other.airPollutionItem == airPollutionItem;
  }

  @override
  int get hashCode => locationCoords.hashCode ^ airPollutionItem.hashCode;
}
