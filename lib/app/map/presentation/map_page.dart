import 'package:chronicle/chronicle.dart';
import 'package:flutter/material.dart';

import '../providers/location_provider.dart';
import 'widgets/google_map_widget.dart';
import 'widgets/search_button_widget.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    Chronicle(StackTrace.current, 'polyPoints', []);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Google Map'),
        actions: [
          SearchButton(
            placeholder: 'Source',
            locationProvider: sourceLocationProvider,
          ),
          SearchButton(
            placeholder: 'Destination',
            locationProvider: destinationLocationProvider,
          ),
        ],
      ),
      body: const GoogleMapWidget(),
    );
  }
}
