import 'dart:convert';
import 'package:flutter_application_1/src/api/http_exception.dart';
import 'package:flutter_application_1/src/model/weather.dart';
import 'package:http/http.dart' as http;

class WeatherApiClient {
  static const baseUrl = 'api.openweathermap.org';
  final String apiKey;
  final http.Client httpClient;

  WeatherApiClient({
    required this.httpClient,
    required this.apiKey,
  });

  Uri _buildUri(String endpoint, Map<String, dynamic> queryParameters) {
    final query = {
      'appid': apiKey,
      ...queryParameters,
    };

    return Uri(
      scheme: 'http',
      host: baseUrl,
      path: 'data/2.5/$endpoint',
      queryParameters: query,
    );
  }

  Future<String> getCityNameFromLocation({
    required double latitude,
    required double longitude,
  }) async {
    final uri = _buildUri('weather', {
      'lat': latitude.toString(),
      'lon': longitude.toString(),
    });

    final res = await httpClient.get(uri);

    if (res.statusCode != 200) {
      throw HTTPException(res.statusCode, "unable to fetch weather data");
    }

    final weatherJson = json.decode(res.body);
    return weatherJson['name'] as String;
  }

  Future<Weather> getWeatherData(String cityName) async {
    final uri = _buildUri('weather', {'q': cityName});

    final res = await httpClient.get(uri);

    if (res.statusCode != 200) {
      throw HTTPException(res.statusCode, "unable to fetch weather data");
    }

    final weatherJson = json.decode(res.body);
    return Weather.fromJson(weatherJson);
  }

  Future<List<Weather>> getForecast(String cityName) async {
    final uri = _buildUri('forecast', {'q': cityName});

    final res = await httpClient.get(uri);

    if (res.statusCode != 200) {
      throw HTTPException(res.statusCode, "unable to fetch weather data");
    }

    final forecastJson = json.decode(res.body);
    return Weather.fromForecastJson(forecastJson);
  }
}
