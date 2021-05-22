import '../../Utilities/unit_conversions.dart';
import '../../Utilities/units_settings.dart';

class OneCallMinutelyWeather {
  DateTime? timeStamp;

  num? precipitationAmount;

  OneCallMinutelyWeather({
    this.timeStamp,
    this.precipitationAmount,
  });

  /// JSON deserialization constructor
  factory OneCallMinutelyWeather.fromJson(
    Map<String, dynamic> json,
    UnitSettings settings,
  ) {
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
