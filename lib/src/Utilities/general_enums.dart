/// The enum for identifying the status of the weather factory
enum RequestStatus {
  Undetermined,
  Successful,
  NonExistentError,
  EmptyError,
  TimeoutError,
  ConnectionError,
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
  FreezingRain,
  Hail,
  Sleet,
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
  CurrentAirPollution,
  ForecastAirPollution,
  HistoryAirPollution,
}

/// The enum for specifying which fields you want excluded from a query to the One Call API endpoint
enum ExcludeField {
  CurrentForecast,
  MinutelyForecast,
  HourlyForecast,
  DailyForecast,
  Alerts,
}

/// This enum contains all the languages that are supported by OpenWeather
enum Language {
  AFRIKAANS,
  ALBANIAN,
  ARABIC,
  AZERBAIJANI,
  BASQUE,
  BULGARIAN,
  CATALAN,
  CHINESE_SIMPLIFIED,
  CHINESE_TRADITIONAL,
  CROATIAN,
  CZECH,
  DANISH,
  DUTCH,
  ENGLISH,
  FARSI,
  FINNISH,
  FRENCH,
  GERMAN,
  GREEK,
  GALICIAN,
  HEBREW,
  HINDI,
  HUNGARIAN,
  INDONESIAN,
  ITALIAN,
  JAPANESE,
  KOREAN,
  LATVIAN,
  LITHUANIAN,
  MACEDONIAN,
  NORWEGIAN,
  PERSIAN,
  POLISH,
  PORTUGUESE,
  PORTUGUESE_BRAZIL,
  ROMANIAN,
  RUSSIAN,
  SWEDISH,
  SLOVAK,
  SLOVENIAN,
  SPANISH,
  SERBIAN,
  THAI,
  TURKISH,
  UKRAINIAN,
  VIETNAMESE,
  ZULU,
}
