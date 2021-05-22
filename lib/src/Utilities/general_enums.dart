/// The enum for identifying the status of the weather factory
enum RequestStatus {
  Undetermined,
  Successful,
  InProgress,
  NonExistentError,
  EmptyError,
  TimeoutError,
  ConnectionError,
  ConnectionErrorNoCache,
  ConnectionErrorCacheAvailable,
  OverloadError,
  UnknownError,
}

/// The enum for identifying what the weather condition is. The main description parameter provides one suitable
/// for display, so this is primarily provided to aid in implementing conditional logic dependent on the weather,
/// for example, a dynamic background
enum WeatherType {
  ClearDay,
  ClearNight,
  LightCloudyDay,
  LightCloudyNight,
  MediumCloudyDay,
  MediumCloudyNight,
  HeavyCloudyDay,
  HeavyCloudyNight,
  Overcast,
  Dusty,
  Foggy,
  Hazy,
  Thunder,
  LightRain,
  MediumRain,
  HeavyRain,
  LightSnow,
  MediumSnow,
  HeavySnow,
}

/// The enum for specifying the status of the internet connection
enum InternetStatus {
  Undetermined,
  Connected,
  Disconnected,
}

/// The enum for identifying the type of request made to the weather factory
enum RequestType {
  CurrentWeather,
  OneCall,
}

/// The enum for specifying which fields you want excluded from a query to the One Call API endpoint
enum ExcludeField {
  CurrentForecast,
  MinutelyForecast,
  HourlyForecast,
  DailyForecast,
  Alerts,
}
