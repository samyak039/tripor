import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../map_utils.dart';
import '../../providers/location_provider.dart';
import '../../providers/polyline_coordinates_provider.dart';
import '../../providers/polyline_route_provider.dart';

class GoogleMapWidget extends HookConsumerWidget {
  const GoogleMapWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLoc = ref.watch(currentLocationProvider).value;

    final sourceLoc = ref.watch(sourceLocationProvider);
    final destinationLoc = ref.watch(destinationLocationProvider);

    ref.watch(polylineRouteProvider(sourceLoc));

    final polylinePoints = ref.watch(polylineCoordinatesProvider);
    final polygonPoints = ref.watch(polygonProvider);
    // Chronicle(StackTrace.current, 'polyPoints', [polyPoints]);

    if (currentLoc == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: currentLoc,
        zoom: MapUtils.CAMERA_ZOOM,
      ),
      markers: {
        Marker(
          markerId: const MarkerId('current'),
          position: currentLoc,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet,
          ),
        ),
        Marker(
          markerId: const MarkerId('source'),
          position: sourceLoc,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        ),
        Marker(
          markerId: const MarkerId('destination'),
          position: destinationLoc,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          ),
        ),
      },
      polylines: {
        Polyline(
          polylineId: const PolylineId('route'),
          points: polylinePoints,
          color: Theme.of(context).colorScheme.primary,
          width: 5,
        ),
      },
      polygons: {
        Polygon(
          polygonId: const PolygonId('offset'),
          points: polygonPoints,
          fillColor:
              Theme.of(context).colorScheme.inversePrimary.withAlpha(100),
          strokeColor: Theme.of(context).colorScheme.primary,
          strokeWidth: 2,
        ),
      },
    );
  }
}
