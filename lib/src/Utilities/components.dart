import 'dart:convert';

/// This class represents specific components of air pollution
class Components {
  /// This field represents Carbon monoxide (CO) in μg/m3
  final double co;

  /// This field represents Nitrogen monoxide (NO) in μg/m3
  final double no;

  /// This field represents Nitrogen dioxide (NO2) in μg/m3
  final double no2;

  /// This field represents Ozone (O3) in μg/m3
  final double o3;

  /// This field represents Sulphur dioxide (SO2) in μg/m3
  final double so2;

  /// This field represents Fine particles matter (PM2.5) in μg/m3
  final double pm25;

  /// This field represents Coarse particulate matter (PM10) in μg/m3
  final double pm10;

  /// This field represents Ammonia (NH3) in μg/m3
  final double nh3;

  const Components({
    required this.co,
    required this.no,
    required this.no2,
    required this.o3,
    required this.so2,
    required this.pm25,
    required this.pm10,
    required this.nh3,
  });

  /// To map function used for JSON serialization
  Map<String, dynamic> toMap() {
    return {
      'co': co,
      'no': no,
      'no2': no2,
      'o3': o3,
      'so2': so2,
      'pm2_5': pm25,
      'pm10': pm10,
      'nh3': nh3,
    };
  }

  /// From map constructor used for JSON deserialization
  factory Components.fromMap(Map<String, dynamic> map) {
    return Components(
      co: map['co'].toDouble(),
      no: map['no'].toDouble(),
      no2: map['no2'].toDouble(),
      o3: map['o3'].toDouble(),
      so2: map['so2'].toDouble(),
      pm25: map['pm2_5'].toDouble(),
      pm10: map['pm10'].toDouble(),
      nh3: map['nh3'].toDouble(),
    );
  }

  /// JSON serialization constructor
  String toJson() => json.encode(toMap());

  /// JSON deserialization constructor
  factory Components.fromJson(String source) =>
      Components.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Components(co: $co, no: $no, no2: $no2, o3: $o3, so2: $so2, pm25: $pm25, pm10: $pm10, nh3: $nh3)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Components &&
        other.co == co &&
        other.no == no &&
        other.no2 == no2 &&
        other.o3 == o3 &&
        other.so2 == so2 &&
        other.pm25 == pm25 &&
        other.pm10 == pm10 &&
        other.nh3 == nh3;
  }

  @override
  int get hashCode {
    return co.hashCode ^
        no.hashCode ^
        no2.hashCode ^
        o3.hashCode ^
        so2.hashCode ^
        pm25.hashCode ^
        pm10.hashCode ^
        nh3.hashCode;
  }
}
