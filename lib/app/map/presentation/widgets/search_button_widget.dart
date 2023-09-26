import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/env.dart';

class SearchButton extends HookConsumerWidget {
  const SearchButton({
    super.key,
    required this.locationProvider,
    this.placeholder = 'Search',
  });

  final String placeholder;
  final StateProvider<LatLng> locationProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        ref.read(locationProvider.notifier).state = LatLng(loc.lat, loc.lng);
      },
    );
  }
}
