import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/src/model/weather.dart';
import 'package:flutter_application_1/src/widgets/current_conditions.dart';
import 'package:flutter_application_1/src/widgets/empty_widget.dart';
import 'package:flutter_application_1/src/widgets/temperature_line_chart.dart';

class WeatherSwipePager extends StatefulWidget {
  // <--- 將 StatelessWidget 改為 StatefulWidget
  const WeatherSwipePager({
    Key? key,
    required this.weather,
  }) : super(key: key);

  final Weather weather;

  @override
  _WeatherSwipePagerState createState() =>
      _WeatherSwipePagerState(); // <--- 創建 State
}

class _WeatherSwipePagerState extends State<WeatherSwipePager> {
  // <--- State 類別
  final SwiperController _swiperController =
      SwiperController(); // <--- 創建 SwiperController

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = AppStateContainer.of(context).theme;

    return Stack(
      // <--- 使用 Stack 來疊加箭頭按鈕和 Swiper
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          child: Swiper(
            controller: _swiperController, // <--- 將控制器賦給 Swiper
            itemCount: 2,
            index: 0,
            itemBuilder: (context, index) {
              if (index == 0) {
                return CurrentConditions(
                  weather: widget.weather, // <--- 使用 widget.weather
                );
              } else if (index == 1) {
                return TemperatureLineChart(
                  widget.weather.forecast, // <--- 使用 widget.weather.forecast
                  animate: true,
                );
              }
              return EmptyWidget();
            },
            pagination: SwiperPagination(
              // <--- 這裡不需要 new
              margin: const EdgeInsets.all(5.0), // <--- 這裡不需要 new，並建議使用 const
              builder: DotSwiperPaginationBuilder(
                  // <--- 這裡不需要 new
                  size: 5,
                  activeSize: 5,
                  color: AppStateContainer.of(context)
                      .theme
                      .colorScheme
                      .secondary
                      .withOpacity(0.4),
                  activeColor: appTheme.colorScheme.secondary),
            ),
          ),
        ),
        // 左箭頭按鈕
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            // <--- 可以增加 Padding 讓箭頭不會貼邊
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios,
                  color: appTheme.colorScheme.secondary
                      .withOpacity(0.7)), // <--- 調整顏色透明度
              onPressed: () {
                _swiperController
                    .previous(); // <--- 呼叫 SwiperController 的 previous 方法
              },
            ),
          ),
        ),
        // 右箭頭按鈕
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            // <--- 可以增加 Padding 讓箭頭不會貼邊
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(Icons.arrow_forward_ios,
                  color: appTheme.colorScheme.secondary
                      .withOpacity(0.7)), // <--- 調整顏色透明度
              onPressed: () {
                _swiperController.next(); // <--- 呼叫 SwiperController 的 next 方法
              },
            ),
          ),
        ),
      ],
    );
  }
}
