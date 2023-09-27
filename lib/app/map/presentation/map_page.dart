import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/env.dart';
import '../map_utils.dart';
import '../providers/location_provider.dart';
import '../providers/nearby_provider.dart';
import '../providers/polyline_coordinates_provider.dart';
import '../providers/polyline_route_provider.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  GoogleMapController? mapController;

  // late final currentLoc = ref.watch(currentLocationProvider).value;
  // late final sourceLoc = ref.watch(sourceLocationProvider);
  // late final destinationLoc = ref.watch(destinationLocationProvider);

  // late final polylinePoints = ref.watch(polylineCoordinatesProvider);
  // late final nearbyCoordinates = ref.watch(nearbyCoordinatesProvider);

  @override
  Widget build(BuildContext context) {
    final currentLoc = ref.watch(currentLocationProvider).value;
    // if (currentLoc == null) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    final sourceLoc = ref.watch(sourceLocationProvider);
    final destinationLoc = ref.watch(destinationLocationProvider);

    ref.watch(polylineRouteProvider(sourceLoc));

    final polylinePoints = ref.watch(polylineCoordinatesProvider);
    // final polygonPoints = ref.watch(polygonProvider);

    ref.watch(nearbyCoordinatesController(polylinePoints));
    final nearbyCoordinates = ref.watch(nearbyCoordinatesProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Google Map'),
        actions: [
          searchButton(
            placeholder: 'Source',
            locationProvider: sourceLocationProvider,
          ),
          searchButton(
            placeholder: 'Destination',
            locationProvider: destinationLocationProvider,
          ),
        ],
      ),
      body: currentLoc == null
          ? const Center(child: CircularProgressIndicator())
          : googleMapWidget(
              currentLoc: currentLoc,
              sourceLoc: sourceLoc,
              destinationLoc: destinationLoc,
              polylinePoints: polylinePoints,
              nearbyCoordinates: nearbyCoordinates,
            ),
    );
  }

  Widget googleMapWidget({
    required LatLng currentLoc,
    required LatLng sourceLoc,
    required LatLng destinationLoc,
    required List<LatLng> polylinePoints,
    required List<LatLng> nearbyCoordinates,
  }) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: currentLoc,
        zoom: MapUtils.CAMERA_ZOOM,
      ),
      onMapCreated: (controller) => setState(() => mapController = controller),
      markers: {
        Marker(
          markerId: const MarkerId('current'),
          position: currentLoc,
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
            BitmapDescriptor.hueGreen,
          ),
        ),
        ...nearbyCoordinates.map(
          (e) => Marker(
            markerId: MarkerId('${e.latitude}, ${e.longitude}'),
            position: e,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueViolet,
            ),
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
      // polygons: {
      //   Polygon(
      //     polygonId: const PolygonId('offset'),
      //     points: polygonPoints,
      //     fillColor:
      //         Theme.of(context).colorScheme.inversePrimary.withAlpha(100),
      //     strokeColor: Theme.of(context).colorScheme.primary,
      //     strokeWidth: 2,
      //   ),
      // },
    );
  }

  Widget searchButton({
    required StateProvider<LatLng> locationProvider,
    String placeholder = 'Search',
  }) {
    return TextButton(
      child: Text(placeholder),
      onPressed: () async {
        final Prediction? place = await PlacesAutocomplete.show(
          context: context,
          apiKey: Env.MAPS_API_KEY,
          mode: Mode.overlay,
        );
        log('$place', name: 'searchLocation');

        if (place == null) {
          log(
            'place: $place',
            error: 'place is null :(',
            name: 'searchLocation',
          );
          return;
        }

        final plist = GoogleMapsPlaces(
          apiKey: Env.MAPS_API_KEY,
          apiHeaders: await const GoogleApiHeaders().getHeaders(),
        );

        final placeIdDetails =
            await plist.getDetailsByPlaceId(place.placeId ?? '0');
        final loc = placeIdDetails.result.geometry!.location;
        final latLng = LatLng(loc.lat, loc.lng);
        ref.read(locationProvider.notifier).state = latLng;

        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: latLng, zoom: MapUtils.CAMERA_ZOOM),
          ),
        );
      },
    );
  }
}
