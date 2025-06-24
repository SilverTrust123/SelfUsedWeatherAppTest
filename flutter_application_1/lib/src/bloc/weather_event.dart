import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
}

class FetchWeather extends WeatherEvent {
  final String? cityName; // 允許為 null
  final double? latitude; // 允許為 null
  final double? longitude; // 允許為 null

  // 建構子，保證 cityName 不為 null 或 latitude 和 longitude 都不為 null
  const FetchWeather({
    this.cityName,
    this.latitude,
    this.longitude,
  }) : assert(
          cityName != null || (latitude != null && longitude != null),
          'You must provide either cityName or both latitude and longitude.',
        );

  @override
  List<Object?> get props => [cityName, latitude, longitude];
}
