import 'package:flutter/material.dart';
import 'package:open_weather_api_client/open_weather_api_client.dart';

// This example uses the Current Weather API endpoint
class Example1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              // Setting up the weather factory
              CurrentWeatherFactory factory = CurrentWeatherFactory(
                apiKey: "Your API Key here",
                settings: UnitSettings(
                  windSpeedUnit: WindSpeedUnit.Knots,
                ),
                cityName: "London",
              );

              // Requesting the weather
              RequestResponse<CurrentWeather?> result =
                  await factory.getWeather();

              // Checking if the request was successful
              if (result.requestStatus == RequestStatus.Successful) {
                // Printing the city name from the server
                print(result.response!.cityName);
                // Printing the temperature
                print(result.response!.temp);
                // Printing the weather type
                print(result.response!.weatherType);
              } else {
                // Printing the error that occurred
                print("Error of type ${result.requestStatus} occurred");
              }
            },
            child: Container(
              width: 200,
              height: 100,
              alignment: Alignment.center,
              color: Colors.green,
              child: Text(
                "Get Weather at London",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// This example uses the One Call API endpoint
class Example2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              // Setting up the weather factory
              OneCallWeatherFactory factory = OneCallWeatherFactory(
                apiKey: "Your API Key here",
                settings: UnitSettings(
                  windSpeedUnit: WindSpeedUnit.Knots,
                ),
                locationCoords: LocationCoords(
                  longitude: 51.5074,
                  latitude: 0.1278,
                ),
                maxTimeBeforeTimeout: Duration(seconds: 10),
              );

              // Requesting the weather
              RequestResponse<OneCallWeather?> result =
                  await factory.getWeather();

              // Checking if the request was successful
              if (result.requestStatus == RequestStatus.Successful) {
                // Printing the current weather type
                print(result.response!.currentWeather!.weatherType);
                // Printing the next hour's weather type
                print(result.response!.hourlyWeather![1]!.weatherType);
                // Printing the precipitation amount 30 minutes later
                print(
                    result.response!.minutelyWeather![29]!.precipitationAmount);
              } else {
                // Printing the error that occurred
                print("Error of type ${result.requestStatus} occurred");
              }
            },
            child: Container(
              width: 200,
              height: 100,
              alignment: Alignment.center,
              color: Colors.green,
              child: Text(
                "Get Weather at London",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// This example uses the current Air pollution API endpoint
class Example3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              // Setting up the air pollution factory
              CurrentAirPollutionFactory factory = CurrentAirPollutionFactory(
                apiKey: "Your API Key here",
                locationCoords: LocationCoords(
                  latitude: 51.5072,
                  longitude: 0.1276,
                ),
              );

              // Requesting the air pollution
              RequestResponse<CurrentAirPollution?> result =
                  await factory.getAirPollution();

              // Checking if the request was successful
              if (result.requestStatus == RequestStatus.Successful) {
                // Printing the air pollution response
                print(result.response!.airPollutionItem.toString());
              } else {
                // Printing the error that occurred
                print("Error of type ${result.requestStatus} occurred");
              }
            },
            child: Container(
              width: 200,
              height: 100,
              alignment: Alignment.center,
              color: Colors.green,
              child: Text(
                "Get Air pollution at London",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
