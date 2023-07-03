import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:world_time/screens/choose_location.dart';
import 'package:world_time/screens/favorites.dart';
import 'package:world_time/screens/home.dart';
import 'package:world_time/services/world_time_provider.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

void main() {
  runApp(WorldTimeApp());
}

class WorldTimeApp extends StatelessWidget {
  WorldTimeApp({
    super.key,
  });

  final GoRouter _router = GoRouter(
      initialLocation: '/home',
      navigatorKey: _rootNavigatorKey,
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) {
            return const Home();
          },
        ),
        GoRoute(
          path: '/location',
          builder: (context, state) {
            return const ChooseLocation();
          },
        ),
        GoRoute(
          path: '/favorites',
          builder: (context, state) {
            return const Favorites();
          },
        ),
      ]);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WorldTimeProvider(),
      child: MaterialApp.router(
        title: 'World Time Application',
        routerConfig: _router,
      ),
    );
  }
}
