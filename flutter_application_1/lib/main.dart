import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_application_1/src/api/api_keys.dart';
import 'package:flutter_application_1/src/bloc/weather_bloc_observre.dart';
import 'package:flutter_application_1/src/screens/routes.dart';
import 'package:flutter_application_1/src/screens/weather_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_application_1/src/themes.dart';
import 'package:flutter_application_1/src/utils/constants.dart';
import 'package:flutter_application_1/src/utils/converters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

import 'src/api/weather_api_client.dart';
import 'src/bloc/weather_bloc.dart';
import 'src/repository/weather_repository.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();

  final WeatherRepository weatherRepository = WeatherRepository(
    weatherApiClient: WeatherApiClient(
      httpClient: http.Client(),
      // apiKey: ApiKey.OPEN_WEATHER_MAP,
    ),
  );

  runApp(AppStateContainer(
    child: WeatherApp(weatherRepository: weatherRepository),
  ));
}

class WeatherApp extends StatelessWidget {
  final WeatherRepository weatherRepository;

  WeatherApp({required this.weatherRepository}) : super();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Weather App',
      theme: AppStateContainer.of(context).theme,
      home: BlocProvider(
        create: (context) => WeatherBloc(weatherRepository: weatherRepository),
        child: WeatherScreen(),
      ),
      routes: Routes.mainRoute,
    );
  }
}

/// Top-level widget to hold application state
/// State is passed down with an inherited widget
/// Inherited widget state is mainly used to hold app theme and temperature unit
class AppStateContainer extends StatefulWidget {
  final Widget child;

  AppStateContainer({required this.child});

  @override
  _AppStateContainerState createState() => _AppStateContainerState();

  static _AppStateContainerState of(BuildContext context) {
    var widget =
        context.dependOnInheritedWidgetOfExactType<_InheritedStateContainer>();
    return widget!.data;
  }
}

class _AppStateContainerState extends State<AppStateContainer> {
  ThemeData _theme = Themes.getTheme(Themes.DARK_THEME_CODE);
  int themeCode = Themes.DARK_THEME_CODE;
  TemperatureUnit temperatureUnit = TemperatureUnit.celsius;

  @override
  void initState() {
    super.initState();
    _loadAppSettings();
  }

  Future<void> _loadAppSettings() async {
    final sharedPref = await SharedPreferences.getInstance();
    setState(() {
      themeCode = sharedPref.getInt(CONSTANTS.SHARED_PREF_KEY_THEME) ??
          Themes.DARK_THEME_CODE;
      temperatureUnit = TemperatureUnit.values[
          sharedPref.getInt(CONSTANTS.SHARED_PREF_KEY_TEMPERATURE_UNIT) ??
              TemperatureUnit.celsius.index];
      _theme = Themes.getTheme(themeCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }

  ThemeData get theme => _theme;

  void updateTheme(int themeCode) {
    setState(() {
      _theme = Themes.getTheme(themeCode);
      this.themeCode = themeCode;
    });
    SharedPreferences.getInstance().then((sharedPref) {
      sharedPref.setInt(CONSTANTS.SHARED_PREF_KEY_THEME, themeCode);
    });
  }

  void updateTemperatureUnit(TemperatureUnit unit) {
    setState(() {
      this.temperatureUnit = unit;
    });
    SharedPreferences.getInstance().then((sharedPref) {
      sharedPref.setInt(CONSTANTS.SHARED_PREF_KEY_TEMPERATURE_UNIT, unit.index);
    });
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final _AppStateContainerState data;

  const _InheritedStateContainer({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer oldWidget) {
    return oldWidget.data.theme != data.theme ||
        oldWidget.data.temperatureUnit != data.temperatureUnit;
  }
}

Future<void> requestPermissions() async {
  // 請求位置權限
  PermissionStatus locationStatus = await Permission.location.request();
  if (locationStatus.isGranted) {
    print('位置權限已授予');
  } else {
    print('位置權限被拒絕');
  }

  // 請求網路權限（通常不需要請求，因為 INTERNET 權限是靜態權限）
  // 如果你需要連接網路，可以在此處執行相關操作
}

Future<void> getLocation() async {
  // 確保位置權限已獲得
  PermissionStatus locationStatus = await Permission.location.status;
  if (locationStatus.isGranted) {
    // 獲取位置
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    print('當前位置：${position.latitude}, ${position.longitude}');
  } else {
    print('需要位置權限');
  }
}
