import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final polylineCoordinatesProvider = StateProvider<List<LatLng>>((ref) => []);

final polylineOverview = StateProvider<String?>((ref) => null);

final polygonProvider = StateProvider<List<LatLng>>((ref) => []);
