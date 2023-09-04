import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum Locations {
  blrGoogle(LatLng(12.9938179, 77.6580512)),
  blrBengaluruPalace(LatLng(13.0019955, 77.5848364)),
  dlhRedFort(LatLng(28.6561639, 77.2384454)),
  blrP1(LatLng(12.9054376, 77.6294875)),
  blrP2(LatLng(12.8893797, 77.6407192)),
  ;

  const Locations(this.ll);
  final LatLng ll;
}

final currentLocationProvider = FutureProvider<LatLng>((ref) async {
  // Test if location services are enabled.
  final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error('Location permissions are permanently denied, '
        'we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  final currentPosition = await Geolocator.getCurrentPosition();
  return LatLng(currentPosition.latitude, currentPosition.longitude);
});

final sourceLocationProvider = Provider<LatLng>((ref) {
  return Locations.blrP2.ll;
});

final destinationLocationProvider = Provider<LatLng>((ref) {
  return Locations.blrP1.ll;
});
