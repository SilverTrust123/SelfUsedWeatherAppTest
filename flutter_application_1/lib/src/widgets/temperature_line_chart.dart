import 'package:nimble_charts/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/src/model/weather.dart';

class TemperatureLineChart extends StatelessWidget {
  final List<Weather> weathers;
  final bool animate;

  TemperatureLineChart(this.weathers, {required this.animate});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth; // 取得可用最大寬度
        final height = 300.0; // 固定高度，也可以調整

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: AbsorbPointer(
              absorbing: false,
              child: InteractiveViewer(
                constrained: false,
                scaleEnabled: false,
                panEnabled: true,
                child: SizedBox(
                  width: width, // 使用螢幕寬度
                  height: height,
                  child: charts.TimeSeriesChart(
                    [
                      charts.Series<Weather, DateTime>(
                        id: 'Temperature',
                        colorFn: (_, __) =>
                            charts.MaterialPalette.blue.shadeDefault,
                        domainFn: (Weather weather, _) =>
                            DateTime.fromMillisecondsSinceEpoch(
                                weather.time * 1000),
                        measureFn: (Weather weather, _) => weather.temperature
                            .as(AppStateContainer.of(context).temperatureUnit),
                        data: weathers,
                      )
                    ],
                    animate: animate,
                    animationDuration: Duration(milliseconds: 500),

                    /// Y 軸刻度配置，顯示數字並非只留軸線
                    primaryMeasureAxis: charts.NumericAxisSpec(
                      tickProviderSpec: charts.BasicNumericTickProviderSpec(
                        zeroBound: false,
                        desiredTickCount: 5, // 可調整刻度數量
                      ),
                      renderSpec: charts.GridlineRendererSpec(
                        labelStyle: charts.TextStyleSpec(
                          fontSize: 20,
                          color: charts.MaterialPalette.black,
                        ),
                        lineStyle: charts.LineStyleSpec(
                          thickness: 2,
                          color: charts.MaterialPalette.gray.shade300,
                        ),
                      ),
                    ),

                    /// X 軸時間軸刻度配置，顯示日期/時間文字
                    domainAxis: charts.DateTimeAxisSpec(
                      tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                        day: charts.TimeFormatterSpec(
                          format: 'MM/dd',
                          transitionFormat: 'MM/dd/yyyy',
                        ),
                        hour: charts.TimeFormatterSpec(
                          format: 'HH:mm',
                          transitionFormat: 'HH:mm',
                        ),
                      ),
                      renderSpec: charts.SmallTickRendererSpec(
                        labelStyle: charts.TextStyleSpec(
                          fontSize: 20,
                          color: charts.MaterialPalette.black,
                        ),
                        lineStyle: charts.LineStyleSpec(
                          thickness: 2,
                          color: charts.MaterialPalette.gray.shade300,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
