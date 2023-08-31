import 'package:flutter_config/flutter_config.dart';

class Env {
  static T _getKey<T>(String key) {
    final value = FlutterConfig.get(key) as T?;
    if (value == null) throw Exception('$key not found');
    return value;
  }

  static String get googleMapsApiKey => _getKey('GOOGLE_MAPS_API_KEY');
  static String get oldGoogleMapsApiKey => _getKey('GOOGLE_MAPS_API_KEY_OLD');
}
