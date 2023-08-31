// ignore_for_file: prefer_const_constructors

import 'package:chronicle/chronicle.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/location_provider.dart';
import '../providers/polyline_coordinates_provider.dart';
import '../providers/polyline_route_provider.dart';

class MapPage extends HookConsumerWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLoc = ref.watch(currentLocationProvider).value;
    final sourceLoc = ref.watch(sourceLocationProvider);
    final destinationLoc = ref.watch(destinationLocationProvider);

    ref.watch(polylineRouteProvider(sourceLoc));

    final polyPoints = ref.watch(polylineCoordinatesProvider);
    Chronicle(StackTrace.current, 'polyPoints', [polyPoints]);

    return Scaffold(
      appBar: AppBar(title: const Text('Google Map')),
      body: currentLoc == null
          ? const Center(child: Text('loading...'))
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentLoc,
                zoom: 10,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('current'),
                  position: currentLoc,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueViolet,
                  ),
                ),
                Marker(
                  markerId: MarkerId('source'),
                  position: sourceLoc,
                ),
                Marker(
                  markerId: MarkerId('destination'),
                  position: destinationLoc,
                ),
              },
              polylines: {
                Polyline(
                  polylineId: PolylineId('route'),
                  points: polyPoints,
                  color: Theme.of(context).primaryColor,
                  width: 5,
                ),
              },
            ),
    );
  }
}
