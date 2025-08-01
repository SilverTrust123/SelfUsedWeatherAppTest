import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/src/model/weather.dart';
import 'package:flutter_application_1/src/widgets/forecast_horizontal_widget.dart';
import 'package:flutter_application_1/src/widgets/value_tile.dart';
import 'package:flutter_application_1/src/widgets/weather_swipe_pager.dart';
import 'package:intl/intl.dart';

class WeatherWidget extends StatelessWidget {
  final Weather weather;

  // Removed redundant null check since `weather` is required.
  WeatherWidget({required this.weather});

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = AppStateContainer.of(context).theme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            this.weather.cityName.toUpperCase(),
            style: TextStyle(
              fontSize: 25,
              letterSpacing: 5,
              color: appTheme.colorScheme.secondary,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 20),
          Text(
            this.weather.description.toUpperCase(),
            style: TextStyle(
              fontSize: 15,
              letterSpacing: 5,
              fontWeight: FontWeight.w100,
              color: appTheme.colorScheme.secondary,
            ),
          ),
          WeatherSwipePager(weather: weather),
          Padding(
            child: Divider(
              color: appTheme.colorScheme.secondary.withAlpha(50),
            ),
            padding: EdgeInsets.all(10),
          ),
          ForecastHorizontal(weathers: weather.forecast),
          Padding(
            child: Divider(
              color: appTheme.colorScheme.secondary.withAlpha(50),
            ),
            padding: EdgeInsets.all(10),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            ValueTile(
              label: "wind speed",
              value: '${this.weather.windSpeed} m/s',
              iconData: Icons.wind_power,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Center(
                child: Container(
                  width: 1,
                  height: 30,
                  color: AppStateContainer.of(context)
                      .theme
                      .colorScheme
                      .secondary
                      .withAlpha(50),
                ),
              ),
            ),
            ValueTile(
              label: "sunrise",
              value: DateFormat('h:m a').format(
                  DateTime.fromMillisecondsSinceEpoch(
                      this.weather.sunrise * 1000)),
              iconData: Icons.wb_sunny,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Center(
                child: Container(
                  width: 1,
                  height: 30,
                  color: AppStateContainer.of(context)
                      .theme
                      .colorScheme
                      .secondary
                      .withAlpha(50),
                ),
              ),
            ),
            ValueTile(
              label: "sunset",
              value: DateFormat('h:m a').format(
                  DateTime.fromMillisecondsSinceEpoch(
                      this.weather.sunset * 1000)),
              iconData: Icons.nightlight_round,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Center(
                child: Container(
                  width: 1,
                  height: 30,
                  color: AppStateContainer.of(context)
                      .theme
                      .colorScheme
                      .secondary
                      .withAlpha(50),
                ),
              ),
            ),
            ValueTile(
              label: "humidity",
              value: '${this.weather.humidity}%',
              iconData: Icons.water_drop,
            ),
          ]),
        ],
      ),
    );
  }
}
