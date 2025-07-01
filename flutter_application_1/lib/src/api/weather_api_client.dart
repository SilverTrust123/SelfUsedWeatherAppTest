import 'dart:convert';
import 'package:flutter_application_1/src/api/http_exception.dart';
import 'package:flutter_application_1/src/model/weather.dart';
import 'package:http/http.dart' as http;

class WeatherApiClient {
  // 將 baseUrl 改為你的 Vercel Serverless Function 的 URL
  // 例如：'your-app-name.vercel.app' 或 'localhost:3000' (本地開發時)
  static const String vercelBaseUrl =
      'self-used-weather-app-test.vercel.app'; // <--- 請替換成你的 Vercel 應用程式網域
  final http.Client httpClient;

  // 構造函數不再需要 apiKey
  WeatherApiClient({
    required this.httpClient,
  });

  Uri _buildVercelUri(String apiPath, Map<String, dynamic> queryParameters) {
    return Uri(
      scheme: 'https', // 使用 HTTPS
      host: vercelBaseUrl,
      path: 'api/weather', // 指向你的 weather.js 所在的 /api 目錄
      queryParameters: queryParameters,
    );
  }

  Future<String> getCityNameFromLocation({
    required double latitude,
    required double longitude,
  }) async {
    final uri = _buildVercelUri('weather', {
      // 呼叫你的 Vercel Function
      'lat': latitude.toString(),
      'lon': longitude.toString(),
      'endpoint':
          'weather', // 告知 Vercel Function 呼叫 OpenWeatherMap 的 /weather 端點
    });

    final res = await httpClient.get(uri);

    if (res.statusCode != 200) {
      final errorData = json.decode(res.body);
      throw HTTPException(
          res.statusCode, errorData['details'] ?? "unable to fetch city name");
    }

    final weatherJson = json.decode(res.body);
    return weatherJson['name'] as String;
  }

  Future<Weather> getWeatherData(String cityName) async {
    final uri = _buildVercelUri('weather', {
      // 呼叫你的 Vercel Function
      'city': cityName,
      'endpoint':
          'weather', // 告知 Vercel Function 呼叫 OpenWeatherMap 的 /weather 端點
    });

    final res = await httpClient.get(uri);

    if (res.statusCode != 200) {
      final errorData = json.decode(res.body);
      throw HTTPException(res.statusCode,
          errorData['details'] ?? "unable to fetch weather data");
    }

    final weatherJson = json.decode(res.body);
    return Weather.fromJson(weatherJson);
  }

  Future<List<Weather>> getForecast(String cityName) async {
    final uri = _buildVercelUri('weather', {
      // 呼叫你的 Vercel Function (這裡 endpoint 不同)
      'city': cityName,
      'endpoint':
          'forecast', // 告知 Vercel Function 呼叫 OpenWeatherMap 的 /forecast 端點
    });

    final res = await httpClient.get(uri);

    if (res.statusCode != 200) {
      final errorData = json.decode(res.body);
      throw HTTPException(res.statusCode,
          errorData['details'] ?? "unable to fetch forecast data");
    }

    final forecastJson = json.decode(res.body);
    // 這裡需要根據你的 Weather.fromForecastJson 邏輯來處理，
    // 確保它能從 Vercel Function 返回的原始 forecastJson 中正確解析。
    return Weather.fromForecastJson(forecastJson);
  }
}
