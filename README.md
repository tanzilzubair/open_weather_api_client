This packages provides an unofficial but comprehensive Dart library for interfacing with the OpenWeather API endpoints.  
  
## Features  
- 🚀 Cross platform: Supports iOS, Android, Mac, Windows, Linux and Web
- 💯 Supports queries via both coordinates and names of cities  
- 🛡 Powerful error handling system with support for connection checks, timeouts, unexpected errors and numerous error responses that can be sent by the Open Weather API endpoints  
- 💪 Support for querying in any of the languages supported by the OpenWeather endpoints  
- ⚙️ Robust options for unit conversions, supporting converting `temperature`, `pressure`, `speed`, `distance` and `precipitation`  
- ❤️ Simple API that maps intuitively to the OpenWeather endpoints  
- ⚡  Production tested (on my own app, check it out [here](https://play.google.com/store/apps/details?id=tanzilzubairbinzaman.caelum))  
- 🔋Batteries included  :)
  
## Getting Started  
Each separate OpenWeather endpoint has its own corresponding weather factory class and data model class that it returns.  
Note that wherever numerical data is parsed, it is returned at the highest possible accuracy.

### CurrentWeather endpoint  
The current weather endpoint can be queried using the **CurrentWeatherFactory** class, and returns a Tuple containing the request status, and an instance of **CurrentWeather**, if the request is successful  
```dart 
CurrentWeatherFactory factory = CurrentWeatherFactory(  
 apiKey: /// Your api key here 
 language: /// Defaults to English, available langauges are listed further below 
 settings: /// An instance of UnitSettings, containing your configuration of what units you want the weather data recevied to be converted to 
 locationCoords: /// An instance of LocationCoords, containing the latitude and longitude you want to query the weather for 
 cityName: /// The name of the city you want to query the weather for 
);  

/// Requesting the weather and awaiting the result  
RequestResponse<CurrentWeather?> result = await factory.getWeather();  
  
if (result.requestStatus == RequestStatus.Successful){  
 /// The request was successful 
 print(result.response!.cityName);
} else {  
 /// The request was not successful, update the UI appropraitely,
 /// according to the error that caused the failure 
 print(result.requestStatus);
 }  
```  
The **CurrentWeatherFactory** requires an `api key`, an instance of `UnitSettings`, and either an instance of `LocationCoords` or the `city name`.   It also optionally takes in an enum of type `Langauge`.

All of the fields in the JSON response from the Current Weather API endpoint are present in the CurrentWeather class, and can be found in this package's API docs.  
  
### OneCall endpoint  
The one call endpoint can be queried using the **OneCallWeatherFactory**, and returns a Tuple containing the request status, and an instance of **OneCallWeather**, if the request is successful.  
```dart 
OneCallWeatherFactory factory = OneCallWeatherFactory(  
 apiKey: /// Your api key here 
 language: /// Defaults to English, available langauges are listed further below settings: /// An instance of UnitSettings, containing your configuration of what units you want the weather data recevied to be converted to 
 locationCoords: /// An instance of LocationCoords, containing the latitude and longitude you want to query the weather for 
 exclusions: /// An array of type [ExcludeField], for the corresponding fields you want to exlcude from the query sent to the OneCall endpoint, defaults to none 
);  

/// Requesting the weather and awaiting the result  
RequestResponse<OneCallWeather?> result = await factory.getWeather();  
  
if (result.requestStatus == RequestStatus.Successful){  
 /// The request was successful 
 print(result.response!.cityName);
} else {  
 /// The request was not successful, update the UI appropraitely,
 /// according to the error that caused the failure 
 print(result.requestStatus);
}  
```  
The **OneCallWeatherFactory** requires an `api key`, an instance of `UnitSettings`, and an instance of `LocationCoords`. It also optionally takes in an enum of type `Langauge`, and an array of enums of type `ExcludeField`.
  
As mentioned in the OpenWeather docs, the OneCall API has a parameter where you can exclude fields (such as the current weather forecast or the hourly weather forecast) from the response the server sends back.  

Every field supported for exclusion by the OneCall endpoint is represented in the ExcludeField enum, and whatever fields are included in the exclusions array field in the OneCallWeatherFactory class are excluded from being queried.  
The class is capable of parsing the full request response from the server, but it is advised to only query the fields you need, as it both accelerates the parsing process and conserves the number of calls available for that API key.

All of the fields in the JSON response from the OneCall API endpoint are present in the OneCallWeather class, and can be found in this package's API docs.  
  
## TODOs:  
- [x] Better docs
- [ ] Even better docs  
- [x] Reduce dependencies
- [ ] Unit tests  
- [ ] Support for the Geocoding endpoint  
- [ ] Support for the 5 Day Forecast endpoint  
- [ ] Support for the Air Pollution endpoint  
- [ ] Support for the Weather Maps 1.0 endpoint (Including widgets to render the map)  
- [ ] Full support for error handling, including edge cases
- [x] Implement more unit settings  
  
## Note  
This package does not support the endpoints of the API that require a membership to query, partly because I don't have an API key with the required memberships and partly because not many people use the paid parts of the API.  

That being said, if you do have an API key associated with an account with the required memberships, please do send a pull request if you can, as it would really help the project out tremendously.   

You can also contact me if you do have an account with the required clearance but do not have the time to contribute, and are willing to generate an API key for me to use (solely for the few calls needed to test out the code for the premium endpoints, of course)  
  
  
   
## License 
This package is licensed under the Apache License, Version 2.0      
``` 
Copyright 2021 Tanzil Zubair Bin Zaman Licensed under the Apache License, Version 2.0 (the "License");  
you may not use this file except in compliance with the License.  
You may obtain a copy of the License at  
  
 http://www.apache.org/licenses/LICENSE-2.0  
 
Unless required by applicable law or agreed to in writing, software  
distributed under the License is distributed on an "AS IS" BASIS,  
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  
See the License for the specific language governing permissions and  
limitations under the License.  
```

