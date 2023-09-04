// ignore_for_file: non_constant_identifier_names

import 'package:flutter_config/flutter_config.dart';

class Env {
  static T _getKey<T>(String key) {
    final value = FlutterConfig.get(key) as T?;
    if (value == null) throw Exception('$key not found');
    return value;
  }

  static String get MAPS_API_KEY => _getKey('GOOGLE_MAPS_API_KEY');
  static String get MAPS_API_KEY_OLD => _getKey('GOOGLE_MAPS_API_KEY_OLD');
}
