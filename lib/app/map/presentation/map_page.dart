import 'package:chronicle/chronicle.dart';
import 'package:flutter/material.dart';

import 'widgets/google_map_widget.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    Chronicle(StackTrace.current, 'polyPoints', []);
    return Scaffold(
      appBar: AppBar(title: const Text('Google Map')),
      body: const GoogleMapWidget(),
    );
  }
}
