import 'package:flutter/foundation.dart';

final conf = kReleaseMode ? ProdConfig() : DevConfig();

abstract class Config {
  String googleApiUrl = '';
}

class DevConfig implements Config {
  @override
  String googleApiUrl = 'https://maps.googleapis.com/maps/api/';
}

class ProdConfig implements Config {
  @override
  String googleApiUrl = 'https://maps.googleapis.com/maps/api/';
}
