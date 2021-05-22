import 'package:flutter/material.dart';
import 'package:open_weather_api_client/open_weather_api_client.dart';
import 'package:tuple/tuple.dart';

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
              Tuple2<RequestStatus, CurrentWeather?> result =
                  await factory.getWeather();

              // Checking if the request was successful
              if (result.item1 == RequestStatus.Successful) {
                // Printing the city name from the server
                print(result.item2!.cityName);
                // Printing the temperature
                print(result.item2!.temp);
                // Printing the weather type
                print(result.item2!.weatherType);
              } else {
                // Printing the error that occurred
                print("Error of type ${result.item1} occurred");
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
              );

              // Requesting the weather
              Tuple2<RequestStatus, OneCallWeather?> result =
                  await factory.getWeather();

              // Checking if the request was successful
              if (result.item1 == RequestStatus.Successful) {
                // Printing the current weather type
                print(result.item2!.currentWeather!.weatherType);
                // Printing the next hour's weather type
                print(result.item2!.hourlyWeather![1]!.weatherType);
                // Printing the precipitation amount 30 minutes later
                print(result.item2!.minutelyWeather![29]!.precipitationAmount);
              } else {
                // Printing the error that occurred
                print("Error of type ${result.item1} occurred");
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
