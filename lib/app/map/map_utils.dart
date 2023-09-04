// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapUtils {
  static const CAMERA_ZOOM = 13.0; // 10.0;
  static const TRAVEL_MODE = TravelMode.driving;

  static ({LatLng upper, LatLng lower}) getOffsetLat(PointLatLng ll) {
    const radius = 6378137;
    const offset = 1000;

    final lat = ll.latitude;
    final lng = ll.longitude;

    final upLat = lat + (offset / radius) * (180 / pi);
    final lowLat = lat - (offset / radius) * (180 / pi);

    return (upper: LatLng(upLat, lng), lower: LatLng(lowLat, lng));
  }
}
