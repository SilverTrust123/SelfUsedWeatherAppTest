import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/utils/WeatherIconMapper.dart';
import 'package:flutter_application_1/src/utils/converters.dart';

class Weather {
  int id;
  int time;
  int sunrise;
  int sunset;
  int humidity;

  String description;
  String iconCode;
  String main;
  String cityName;

  double windSpeed;

  Temperature temperature;
  Temperature maxTemperature;
  Temperature minTemperature;

  List<Weather> forecast;

  // 主建構子
  Weather({
    required this.id,
    required this.time,
    required this.sunrise,
    required this.sunset,
    required this.humidity,
    required this.description,
    required this.iconCode,
    required this.main,
    required this.cityName,
    required this.windSpeed,
    required this.temperature,
    required this.maxTemperature,
    required this.minTemperature,
    this.forecast = const [],
  });

  // 用於 forecast 預測資料的簡化建構子
  Weather.simpleForecast({
    required this.time,
    required this.temperature,
    required this.iconCode,
  })  : id = 0,
        sunrise = 0,
        sunset = 0,
        humidity = 0,
        description = '',
        main = '',
        cityName = '',
        windSpeed = 0,
        maxTemperature = temperature,
        minTemperature = temperature,
        forecast = const [];

  // 一般 JSON 轉換
  static Weather fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0];
    return Weather(
      id: weather['id'],
      time: json['dt'],
      description: weather['description'],
      iconCode: weather['icon'],
      main: weather['main'],
      cityName: json['name'],
      temperature: Temperature(intToDouble(json['main']['temp'])),
      maxTemperature: Temperature(intToDouble(json['main']['temp_max'])),
      minTemperature: Temperature(intToDouble(json['main']['temp_min'])),
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
      humidity: json['main']['humidity'],
      windSpeed: intToDouble(json['wind']['speed']),
    );
  }

  // 預測資料轉換
  static List<Weather> fromForecastJson(Map<String, dynamic> json) {
    final List<Weather> weathers = [];
    for (final item in json['list']) {
      weathers.add(Weather.simpleForecast(
        time: item['dt'],
        temperature: Temperature(intToDouble(item['main']['temp'])),
        iconCode: item['weather'][0]['icon'],
      ));
    }
    return weathers;
  }

  IconData getIconData() {
    switch (this.iconCode) {
      case '01d':
        return WeatherIcons.clear_day;
      case '01n':
        return WeatherIcons.clear_night;
      case '02d':
        return WeatherIcons.few_clouds_day;
      case '02n':
        // 修正：02n 應該對應到夜間的「少雲」圖示
        return WeatherIcons.few_clouds_night;
      case '03d':
      case '04d':
        return WeatherIcons.clouds_day;
      case '03n':
      case '04n':
        // 修正：03n 和 04n 應該對應到夜間的「多雲」圖示
        return WeatherIcons.clouds_night;
      case '09d':
        return WeatherIcons.shower_rain_day;
      case '09n':
        return WeatherIcons.shower_rain_night;
      case '10d':
        return WeatherIcons.rain_day;
      case '10n':
        return WeatherIcons.rain_night;
      case '11d':
        return WeatherIcons.thunder_storm_day;
      case '11n':
        return WeatherIcons.thunder_storm_night;
      case '13d':
        return WeatherIcons.snow_day;
      case '13n':
        return WeatherIcons.snow_night;
      case '50d':
        return WeatherIcons.mist_day;
      case '50n':
        return WeatherIcons.mist_night;
      default:
        // 預設值，例如當iconCode不匹配任何已知情況時
        return WeatherIcons.clear_day;
    }
  }
}
