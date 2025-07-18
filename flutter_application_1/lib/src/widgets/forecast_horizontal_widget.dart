import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/src/model/weather.dart';
import 'package:flutter_application_1/src/widgets/value_tile.dart';
import 'package:intl/intl.dart';

/// Renders a horizontal scrolling list of weather conditions
class ForecastHorizontal extends StatelessWidget {
  const ForecastHorizontal({
    Key? key,
    required this.weathers,
  }) : super(key: key);

  final List<Weather> weathers;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: this.weathers.length,
          separatorBuilder: (context, index) => Divider(
            height: 70,
            color: Colors.white,
          ),
          padding: EdgeInsets.only(left: 10, right: 10),
          itemBuilder: (context, index) {
            final item = this.weathers[index];
            return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Center(
                child: ValueTile(
                  label: DateFormat('E, ha').format(
                      DateTime.fromMillisecondsSinceEpoch(item.time * 1000)),
                  value:
                      '${item.temperature.as(AppStateContainer.of(context).temperatureUnit).round()}°',
                  iconData: item.getIconData(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
