import 'package:go_router/go_router.dart';

import '../app/map/presentation/map_page.dart';
import '../app/root/presentation/root.dart';

enum Route { gMap, home, root }

final router = GoRouter(
  redirect: (context, state) => '/gMap',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: Route.root.name,
      builder: (context, state) => const RootPage(),
    ),
    GoRoute(
      path: '/gMap',
      name: Route.gMap.name,
      builder: (context, state) => const MapPage(),
    ),
  ],
);
