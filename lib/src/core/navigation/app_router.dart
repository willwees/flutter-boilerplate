import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/features.dart';
import '../core.dart';

/// This file contains the implementation of the AppRouter class.
/// The AppRouter class is responsible for defining and managing the app's navigation routes.
/// It provides methods to navigate to different screens within the app.
/// The routes are defined using the Flutter Navigator 2.0 API.
/// The AppRouter class is typically used as a singleton and can be accessed from anywhere in the app.
///
/// Resource:
///
/// [GoRouter Docs](https://pub.dev/documentation/go_router/latest/topics/Get%20started-topic.html)
class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    // initialLocation: AppPaths.splash,
    initialLocation: AppPaths.home,
    debugLogDiagnostics: true,
    navigatorKey: rootNavigatorKey,
    routes: <RouteBase>[
      // GoRoute(
      //   name: AppRoutes.splash,
      //   path: AppPaths.splash,
      //   builder: (BuildContext context, GoRouterState state) => const SplashPage(),
      // ),
      GoRoute(
        name: AppRoutes.home,
        path: AppPaths.home,
        builder: (BuildContext context, GoRouterState state) => const HomePage(),
      ),
    ],
  );
}
