import 'package:flutter/material.dart';

class _IconData extends IconData {
  const _IconData(int codePoint)
      : super(
          codePoint,
          fontFamily: 'WeatherIcons',
        );
}

/// Exposes specific weather icons
/// Has all weather conditions specified by open weather maps API
/// https://openweathermap.org/weather-conditions
// hex values and ttf file from https://erikflowers.github.io/weather-icons/
// 根據您提供的 Weather Icons 2.0 圖片更新了部分編碼點
class WeatherIcons {
  static const IconData clear_day = const _IconData(0xf00d); // wi-day-sunny
  static const IconData clear_night = const _IconData(0xf02e); // wi-night-clear

  static const IconData few_clouds_day =
      const _IconData(0xf002); // wi-day-cloudy
  // 更新為 wi-night-alt-cloudy (0xf022) 以符合 2.0 圖片
  static const IconData few_clouds_night = const _IconData(0xf022);

  static const IconData clouds_day = const _IconData(0xf07d); // wi-cloudy
  // 更新為 wi-night-cloudy (0xf031) 以符合 2.0 圖片
  static const IconData clouds_night = const _IconData(0xf031);

  static const IconData shower_rain_day =
      const _IconData(0xf009); // wi-day-showers
  static const IconData shower_rain_night =
      const _IconData(0xf029); // wi-night-alt-showers

  static const IconData rain_day = const _IconData(0xf008); // wi-day-rain
  static const IconData rain_night =
      const _IconData(0xf028); // wi-night-alt-rain

  static const IconData thunder_storm_day =
      const _IconData(0xf010); // wi-day-thunderstorm
  static const IconData thunder_storm_night =
      const _IconData(0xf03b); // wi-night-alt-thunderstorm

  static const IconData snow_day = const _IconData(0xf00a); // wi-day-snow
  static const IconData snow_night =
      const _IconData(0xf02a); // wi-night-alt-snow

  static const IconData mist_day = const _IconData(0xf003); // wi-day-fog
  static const IconData mist_night =
      const _IconData(0xf04a); // wi-night-alt-fog
}
