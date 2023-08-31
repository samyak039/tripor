import 'package:chronicle/chronicle.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import 'core/router.dart';

class Tripor extends StatelessWidget {
  const Tripor({super.key});

  Future<void> setPermissions() async {
    const location = Permission.location;

    await location.request();
    if (await location.request().isGranted) {
      Chronicle(
        StackTrace.current,
        'location permission',
        [await location.status.isGranted],
      );
    } else {
      await location.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    setPermissions();

    return ProviderScope(
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        title: 'Tripor',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}
