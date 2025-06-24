import 'package:flutter_application_1/src/api/weather_api_client.dart';
import 'package:flutter_application_1/src/model/weather.dart';

class WeatherRepository {
  final WeatherApiClient weatherApiClient;
  WeatherRepository({required this.weatherApiClient});

  Future<Weather> getWeather(String? cityName,
      {required double latitude, required double longitude}) async {
    cityName ??= await weatherApiClient.getCityNameFromLocation(
        latitude: latitude, longitude: longitude);
    final weather = await weatherApiClient.getWeatherData(cityName);
    final weathers = await weatherApiClient.getForecast(cityName);
    weather.forecast = weathers;
    return weather;
  }
}
