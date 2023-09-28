import 'package:chronicle/chronicle.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/env.dart';
import '../map_utils.dart';
import 'location_provider.dart';
import 'nearby_provider.dart';
import 'polyline_coordinates_provider.dart';

final polylineRouteProvider =
    FutureProvider.family<void, LatLng>((ref, destinationLoc) async {
  final sourceLoc = ref.watch(sourceLocationProvider);

  final polylinePoints = PolylinePoints();

  Chronicle(StackTrace.current, 'polylinePoints', [
    Env.MAPS_API_KEY,
    sourceLoc,
    destinationLoc,
  ]);

  final PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    Env.MAPS_API_KEY_OLD,
    PointLatLng(sourceLoc.latitude, sourceLoc.longitude),
    PointLatLng(destinationLoc.latitude, destinationLoc.longitude),
    // ignore: avoid_redundant_argument_values
    travelMode: MapUtils.TRAVEL_MODE,
    optimizeWaypoints: true,
  );
  Chronicle(StackTrace.current, 'result', [result.toString]);

  if (result.points.isNotEmpty) {
    ref.read(nearbyCoordinatesProvider.notifier).state = [];

    final polylineCoordinates = <LatLng>[];

    final upperPolypoints = <LatLng>[];
    final lowerPolypoints = <LatLng>[];

    for (final PointLatLng point in result.points) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));

      final offsetPoint = MapUtils.getOffsetLat(point);
      upperPolypoints.add(offsetPoint.upper);
      lowerPolypoints.add(offsetPoint.lower);
    }

    ref.read(polylineCoordinatesProvider.notifier).state = polylineCoordinates;

    // ref.read(polygonProvider.notifier).state =
    //     upperPolypoints + lowerPolypoints.reversed.toList();
  }

  ref.read(polylineOverview.notifier).state = result.overviewPolyline;
});
