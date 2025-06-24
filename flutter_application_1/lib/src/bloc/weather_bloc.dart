import 'package:bloc/bloc.dart';
import 'package:flutter_application_1/src/model/weather.dart';

import 'package:flutter_application_1/src/bloc/weather_event.dart';
import 'package:flutter_application_1/src/bloc/weather_state.dart';
import 'package:flutter_application_1/src/repository/weather_repository.dart';
import 'package:flutter_application_1/src/api/http_exception.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc({required this.weatherRepository}) : super(WeatherEmpty());

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is FetchWeather) {
      yield WeatherLoading();
      try {
        String cityName;
        double latitude;
        double longitude;

        if (event.cityName != null) {
          cityName = event.cityName!;
          latitude = event.latitude ?? 0; // 如果你能給預設值可這樣
          longitude = event.longitude ?? 0;
        } else if (event.latitude != null && event.longitude != null) {
          latitude = event.latitude!;
          longitude = event.longitude!;
          // 如果 cityName 是空，透過座標反查城市名
          cityName =
              await weatherRepository.weatherApiClient.getCityNameFromLocation(
            latitude: latitude,
            longitude: longitude,
          );
        } else {
          yield WeatherError(errorCode: 400); // 參數錯誤
          return;
        }

        final Weather weather = await weatherRepository.getWeather(
          cityName,
          latitude: latitude,
          longitude: longitude,
        );

        yield WeatherLoaded(weather: weather);
      } catch (exception) {
        print(exception);
        if (exception is HTTPException) {
          yield WeatherError(errorCode: exception.code);
        } else {
          yield WeatherError(errorCode: 500);
        }
      }
    }
  }
}
