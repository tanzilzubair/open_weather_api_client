import '../../Utilities/unit_conversions.dart';
import '../../Utilities/units_settings.dart';

class OneCallMinutelyWeather {
  /// The amount of precipitation in that minute, in mm by default
  num? precipitationAmount;

  /// The timestamp of when the data was requested, in UTC time
  DateTime? timeStamp;

  OneCallMinutelyWeather({
    this.timeStamp,
    this.precipitationAmount,
  });

  /// JSON deserialization constructor
  factory OneCallMinutelyWeather.fromJson(
    Map<String, dynamic> json,
    UnitSettings settings,
  ) {
    // Formatting the amount of rain
    num? precipitationAmount = precipitationToSelectedUnit(
      amount: json['precipitation'],
      unit: settings.precipitationUnit,
    );
    return OneCallMinutelyWeather(
      timeStamp: DateTime.fromMillisecondsSinceEpoch(
        (json['dt']) * 1000,
        isUtc: true,
      ),
      precipitationAmount: precipitationAmount,
    );
  }
}
