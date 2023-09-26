import 'dart:developer';

import 'package:chronicle/chronicle.dart';
import 'package:dio/dio.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final nearbyCoordinatesProvider = StateProvider<List<LatLng>>((ref) => []);

final nearbyCoordinatesController =
    FutureProvider.family<void, List<LatLng>>((ref, polyline) async {
  final dio = Dio();
  final n = polyline.length;
  log('length: $n', name: 'nearbyCoordinatesController:polyline');
  for (int i = 0; i < n; i += 10) {
    log(
      'LatLng: ${polyline[i].latitude},${polyline[i].longitude}',
      name: 'nearbyCoordinatesController',
    );
    try {
      final res = await dio.get(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json',
        queryParameters: {
          'key': FlutterConfig.get('GOOGLE_MAPS_API_KEY_OLD'),
          'location': '${polyline[i].latitude},${polyline[i].longitude}',
          'radius': 20000,
          'type': 'restaurant',
        },
      );

      // TODO: fix his dynamic_calls
      // ignore: avoid_dynamic_calls
      res.data['results'].forEach((e) {
        // ignore: avoid_dynamic_calls
        final double lat = e['geometry']['location']['lat'] as double;
        // ignore: avoid_dynamic_calls
        final double lng = e['geometry']['location']['lng'] as double;
        final latLng = LatLng(lat, lng);
        ref.read(nearbyCoordinatesProvider.notifier).state.add(latLng);
      });

      Chronicle(
        StackTrace.current,
        'nearbyCoordinatesController',
        [res.data.toString()],
      );
    } on DioException catch (e) {
      log(
        '${e.error}, ${e.message}',
        name: 'nearbyCoordinatesController',
        error: e,
      );
      Chronicle(
        StackTrace.current,
        'nearbyCoordinatesController',
        [e],
        isError: true,
      );
      break;
    }
  }
});
