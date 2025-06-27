import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/src/bloc/weather_event.dart';
import 'package:flutter_application_1/src/bloc/weather_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/src/widgets/weather_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../bloc/weather_bloc.dart';

enum OptionsMenu { changeCity, settings }

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>
    with TickerProviderStateMixin {
  late WeatherBloc _weatherBloc;
  String _cityName = 'yunlin';
  late Animation<double> _fadeAnimation;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _weatherBloc = BlocProvider.of<WeatherBloc>(context);
    _initLocationOrCity();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = AppStateContainer.of(context).theme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTheme.primaryColor,
        elevation: 0,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              DateFormat('EEEE, d MMMM yyyy').format(DateTime.now()),
              style: TextStyle(
                color: appTheme.colorScheme.secondary.withAlpha(80),
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          PopupMenuButton<OptionsMenu>(
            child: Icon(
              Icons.brightness_4,
              color: appTheme.colorScheme.secondary,
            ),
            onSelected: _onOptionMenuItemSelected,
            itemBuilder: (context) => <PopupMenuEntry<OptionsMenu>>[
              PopupMenuItem<OptionsMenu>(
                value: OptionsMenu.changeCity,
                child: Text("change city"),
              ),
              PopupMenuItem<OptionsMenu>(
                value: OptionsMenu.settings,
                child: Text("settings"),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Material(
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(color: appTheme.primaryColor),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: BlocBuilder<WeatherBloc, WeatherState>(
              builder: (_, WeatherState weatherState) {
                _fadeController.reset();
                _fadeController.forward();

                if (weatherState is WeatherLoaded) {
                  _cityName = weatherState.weather.cityName;
                  return WeatherWidget(weather: weatherState.weather);
                } else if (weatherState is WeatherError ||
                    weatherState is WeatherEmpty) {
                  String errorText = 'Error fetching weather data.';
                  if (weatherState is WeatherError &&
                      weatherState.errorCode == 404) {
                    errorText = 'Cannot fetch weather for $_cityName';
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.error_outline, color: Colors.redAccent),
                      SizedBox(height: 10),
                      Text(errorText, style: TextStyle(color: Colors.red)),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: appTheme.colorScheme.secondary,
                          elevation: 1,
                        ),
                        child: Text("Try Again"),
                        onPressed: _fetchWeatherWithCity,
                      )
                    ],
                  );
                } else if (weatherState is WeatherLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: appTheme.primaryColor,
                    ),
                  );
                }
                return Center(child: Text('No city set'));
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _initLocationOrCity() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        await _fetchWeatherWithLocation();
      } else {
        _fetchWeatherWithCity();
      }
    } catch (e) {
      print("Error checking location: $e");
      _fetchWeatherWithCity();
    }
  }

  void _onOptionMenuItemSelected(OptionsMenu item) {
    switch (item) {
      case OptionsMenu.changeCity:
        _showCityChangeDialog();
        break;
      case OptionsMenu.settings:
        Navigator.of(context).pushNamed("/settings");
        break;
    }
  }

  void _showCityChangeDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        ThemeData appTheme = AppStateContainer.of(context).theme;

        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Change city', style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              style: TextButton.styleFrom(
                foregroundColor: appTheme.colorScheme.secondary,
                elevation: 1,
              ),
              onPressed: () {
                _fetchWeatherWithCity();
                Navigator.of(context).pop();
              },
            ),
          ],
          content: TextField(
            autofocus: true,
            onChanged: (text) {
              _cityName = text;
            },
            decoration: InputDecoration(
              hintText: 'Name of your city',
              hintStyle: TextStyle(color: Colors.black),
              suffixIcon: GestureDetector(
                onTap: () {
                  _fetchWeatherWithLocation().catchError((error) {
                    _fetchWeatherWithCity();
                  });
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.my_location,
                  color: Colors.black,
                  size: 16,
                ),
              ),
            ),
            style: TextStyle(color: Colors.black),
            cursorColor: Colors.black,
          ),
        );
      },
    );
  }

  void _fetchWeatherWithCity() {
    _weatherBloc.add(FetchWeather(cityName: _cityName));
  }

  Future<void> _fetchWeatherWithLocation() async {
    print('Requesting current location...');
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: Duration(seconds: 5),
      );

      print("Location retrieved: ${position.latitude}, ${position.longitude}");

      _weatherBloc.add(FetchWeather(
        longitude: position.longitude,
        latitude: position.latitude,
      ));
    } catch (e) {
      print("Failed to get location: $e");
      _fetchWeatherWithCity();
    }
  }
}
