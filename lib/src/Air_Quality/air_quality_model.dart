import '../../open_weather_api_client.dart';

/// This is the class that handles JSON deserialization and makes data for AirPollution queries accessible.
class AirQuality {
  /// The longitude and latitude for the city for which the weather was queried
  LocationCoords? locationCoords;

  /// The air quality index gives a measure of the quality of the air
  /// - A value of 1 means the air quality is good
  /// - A value of 2 means the air quality is fair
  /// - A value of 3 means the air quality is moderate
  /// - A value of 4 means the air quality is poor
  /// - A value of 5 means the air quality is very poor
  int? airQualityIndex;

  /// The concentration of carbon monoxide (CO) present in the air, in micrograms per cubic metre
  num? carbonMonoxideConc;

  /// The concentration of nitrogen oxide (NO) present in the air, in micrograms per cubic metre
  num? nitrogenOxideConc;

  /// The concentration of nitrogen dioxide (NO2) present in the air, in micrograms per cubic metre
  num? nitrogenDioxideConc;

  /// The concentration of ozone (O3) present in the air, in micrograms per cubic metre
  num? ozoneConc;

  /// The concentration of sulphur dioxide (SO2) present in the air, in micrograms per cubic metre
  num? sulphurDioxideConc;

  /// The concentration of fine particulate matter (particles with a diameter of 2.5 micrometres or less)
  /// present in the air, in micrograms per cubic metre
  num? fineParticulatesConc;

  /// The concentration of coarse particulate matter (particles with a diameter of 10 micrometres or less)
  /// present in the air, in micrograms per cubic metre
  num? coarseParticulatesConc;

  /// The concentration of ammonia (NH3) present in the air, in micrograms per cubic metre
  num? ammoniaConc;

  /// The timestamp of when the data was requested, in UTC time
  DateTime? timeStamp;

  AirQuality({
    this.locationCoords,
    this.airQualityIndex,
    this.carbonMonoxideConc,
    this.nitrogenOxideConc,
    this.nitrogenDioxideConc,
    this.ozoneConc,
    this.sulphurDioxideConc,
    this.fineParticulatesConc,
    this.coarseParticulatesConc,
    this.ammoniaConc,
    this.timeStamp,
  });

  factory AirQuality.fromJson(
    Map<String, dynamic> mainJson,
    Map<String, dynamic> json,
    UnitSettings settings,
  ) {
    return AirQuality(
      locationCoords: LocationCoords(
        longitude: mainJson['coord']['lon'],
        latitude: mainJson['coord']['lat'],
      ),
      airQualityIndex: json['main']['aqi'],
      carbonMonoxideConc: json['components']['co'],
      nitrogenOxideConc: json['components']['no'],
      nitrogenDioxideConc: json['components']['no2'],
      ozoneConc: json['components']['o3'],
      sulphurDioxideConc: json['components']['so2'],
      fineParticulatesConc: json['components']['pm2_5'],
      coarseParticulatesConc: json['components']['pm10'],
      ammoniaConc: json['components']['nh3'],
      timeStamp: json['dt'],
    );
  }
}
