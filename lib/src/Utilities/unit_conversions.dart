import 'package:open_weather_api_client/src/Utilities/settings_enums.dart';

import 'general_enums.dart';

num pressureToSelectedUnit({
  required num pressure,
  required PressureUnit unit,
}) {
  String result = "";
  if (unit == PressureUnit.HectoPascals) {
    result = "${pressure.toStringAsFixed(3)}";
  } else if (unit == PressureUnit.KiloPascals) {
    result = "${(pressure * 0.1).toStringAsFixed(3)}";
  } else if (unit == PressureUnit.MillimetersMercury) {
    result = "${(pressure * 0.7500615759).toStringAsFixed(3)}";
  } else if (unit == PressureUnit.InchesMercury) {
    result = "${(pressure / 33.864).toStringAsFixed(3)}";
  } else if (unit == PressureUnit.Millibars) {
    result = "${pressure.toStringAsFixed(3)}";
  }
  return num.parse(result);
}

num? distanceToSelectedUnit({
  required num distance,
  required DistanceUnit unit,
}) {
  String result = "";
  if (unit == DistanceUnit.Kilometers) {
    distance = distance / 1000;
    result = distance.toStringAsFixed(3);
  } else if (unit == DistanceUnit.Miles) {
    distance = (distance * 0.000621371);
    result = distance.toStringAsFixed(3);
  }
  return num.parse(result);
}

num? windSpeedToSelectedUnit({
  required num? windSpeed,
  required WindSpeedUnit unit,
}) {
  String result = "";
  // This null check exists as if a weather phenomenon does not occur, Open Weather Map returns null as its value
  if (windSpeed != null) {
    if (unit == WindSpeedUnit.Miles_Hour) {
      result = "${(windSpeed * 2.2369363).toStringAsFixed(3)}";
    } else if (unit == WindSpeedUnit.Kilometres_Hour) {
      result = "${(windSpeed * 3.6).toStringAsFixed(3)}";
    } else if (unit == WindSpeedUnit.Metres_Second) {
      result = "${windSpeed.toStringAsFixed(3)}";
    } else if (unit == WindSpeedUnit.Knots) {
      result = "${(windSpeed * 1.9438445).toStringAsFixed(3)}";
    } else if (unit == WindSpeedUnit.Beaufort) {
      if (windSpeed < 0.3) {
        result = "0";
      } else if (windSpeed >= 0.3 && windSpeed < 1.5) {
        result = "1";
      } else if (windSpeed >= 1.5 && windSpeed < 3.3) {
        result = "2";
      } else if (windSpeed >= 3.3 && windSpeed < 5.5) {
        result = "3";
      } else if (windSpeed >= 5.5 && windSpeed < 8.0) {
        result = "4";
      } else if (windSpeed >= 8.0 && windSpeed < 10.8) {
        result = "5";
      } else if (windSpeed >= 10.8 && windSpeed < 13.9) {
        result = "6";
      } else if (windSpeed >= 13.9 && windSpeed < 17.2) {
        result = "7";
      } else if (windSpeed >= 17.2 && windSpeed < 20.7) {
        result = "8";
      } else if (windSpeed >= 20.7 && windSpeed < 24.5) {
        result = "9";
      } else if (windSpeed >= 24.5 && windSpeed < 28.4) {
        result = "10";
      } else if (windSpeed >= 28.4 && windSpeed < 32.6) {
        result = "11";
      } else if (windSpeed >= 32.6) {
        result = "12";
      }
    }
    return num.parse(result);
  } else {
    return 0.0;
  }
}

num? temperatureToSelectedUnit({
  required num temp,
  required TemperatureUnit unit,
}) {
  String result = "";
  if (unit == TemperatureUnit.Kelvin) {
    result = "${temp.toStringAsFixed(3)}";
  } else if (unit == TemperatureUnit.Celsius) {
    temp -= 273.15;
    result = "${temp.toStringAsFixed(3)}";
  } else if (unit == TemperatureUnit.Fahrenheit) {
    temp = ((temp - 273.15) * (9 / 5)) + 32;
    result = "${temp.toStringAsFixed(0)}";
  }
  return num.parse(result);
}

num? precipitationToSelectedUnit({
  required double? amount,
  required PrecipitationUnit unit,
}) {
  String result = "";
  if (amount != null) {
    if (unit == PrecipitationUnit.Inches) {
      num precipAmount = amount / 25.4;
      result = "${precipAmount.toStringAsFixed(3)}";
    } else {
      result = "${amount.toStringAsFixed(3)}";
    }
    return num.parse(result);
  } else {
    return 0.0;
  }
}

WeatherType infoToWeatherType({required int id, required String iconId}) {
  WeatherType weatherType = WeatherType.ClearDay;

  /// These switch statements work together, one of them covering a certain number of scenarios, the other the rest. They overlap
  /// in their output. I could not find a better way.
  switch (iconId) {
    case "01d":
      {
        weatherType = WeatherType.ClearDay;
      }
      break;
    case "01n":
      {
        weatherType = WeatherType.ClearNight;
      }
      break;
    case "02d":
      {
        weatherType = WeatherType.LightCloudyDay;
      }
      break;
    case "02n":
      {
        weatherType = WeatherType.LightCloudyNight;
      }
      break;
    case "03d":
      {
        weatherType = WeatherType.MediumCloudyDay;
      }
      break;

    case "03n":
      {
        weatherType = WeatherType.MediumCloudyNight;
      }
      break;
    case "04d":
      {
        weatherType = WeatherType.HeavyCloudyDay;
      }
      break;
    case "04n":
      {
        weatherType = WeatherType.HeavyCloudyNight;
      }
      break;
    case "11d":
    case "11n":
      {
        weatherType = WeatherType.Thunder;
      }
      break;
    default:
      {}
      break;
  }
  switch (id) {
    case 771:
    case 781:
      {
        weatherType = WeatherType.Overcast;
      }
      break;
    case 731:
    case 751:
    case 761:
      {
        weatherType = WeatherType.Dusty;
      }
      break;
    case 741:
    case 701:
      {
        weatherType = WeatherType.Foggy;
      }
      break;
    case 721:
    case 711:
    case 762:
      {
        weatherType = WeatherType.Hazy;
      }
      break;
    case 300:
    case 310:
    case 313:
    case 500:
    case 520:
      {
        weatherType = WeatherType.LightRain;
      }
      break;
    case 301:
    case 311:
    case 321:
    case 501:
    case 521:
    case 531:
      {
        weatherType = WeatherType.MediumRain;
      }
      break;
    case 302:
    case 312:
    case 314:
    case 502:
    case 503:
    case 504:
    case 522:
      {
        weatherType = WeatherType.HeavyRain;
      }
      break;
    case 600:
    case 620:
      {
        weatherType = WeatherType.LightSnow;
      }
      break;
    case 601:
    case 621:
      {
        weatherType = WeatherType.MediumSnow;
      }
      break;
    case 602:

    case 622:
      {
        weatherType = WeatherType.HeavySnow;
      }
      break;
    case 511:
    case 615:
      {
        weatherType = WeatherType.FreezingRain;
      }
      break;
    case 616:
      {
        weatherType = WeatherType.Hail;
      }
      break;
    case 611:
    case 612:
    case 613:
      {
        weatherType = WeatherType.Sleet;
      }
      break;
    default:
      {}
      break;
  }
  return weatherType;
}
