import 'package:chronicle/chronicle.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/env.dart';
import 'location_provider.dart';
import 'polyline_coordinates_provider.dart';

final polylineRouteProvider =
    FutureProvider.family<void, LatLng>((ref, sourceLoc) async {
  final polylinePoints = PolylinePoints();
  final destinationLoc = ref.read(destinationLocationProvider);

  Chronicle(StackTrace.current, 'polylinePoints', [
    Env.googleMapsApiKey,
    sourceLoc,
    destinationLoc,
  ]);

  final PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    Env.oldGoogleMapsApiKey,
    PointLatLng(sourceLoc.latitude, sourceLoc.longitude),
    PointLatLng(destinationLoc.latitude, destinationLoc.longitude),
    optimizeWaypoints: true,
  );
  Chronicle(StackTrace.current, 'result', [result]);

  if (result.points.isNotEmpty) {
    final polylineCoordinates = <LatLng>[];
    for (final point in result.points) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    }

    ref.read(polylineCoordinatesProvider.notifier).state = polylineCoordinates;
  }
});
