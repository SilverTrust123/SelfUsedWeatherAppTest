/// Converts values of type int or double to double.
/// Intended to be used while parsing JSON values where type is dynamic.
/// Returns value of type double.
double intToDouble(dynamic val) {
  if (val is double) {
    return val;
  } else if (val is int) {
    return val.toDouble();
  } else {
    throw Exception(
        "Value is not of type 'int' or 'double', got type '${val.runtimeType}'");
  }
}

enum TemperatureUnit { kelvin, celsius, fahrenheit }

class Temperature {
  final double _celsius;

  Temperature(this._celsius);

  double get celsius => _celsius;

  double get kelvin => _celsius + 273.15;

  double get fahrenheit => _celsius * 9 / 5 + 32;

  double as(TemperatureUnit unit) {
    switch (unit) {
      case TemperatureUnit.kelvin:
        return kelvin;
      case TemperatureUnit.celsius:
        return celsius;
      case TemperatureUnit.fahrenheit:
        return fahrenheit;
    }
  }
}
