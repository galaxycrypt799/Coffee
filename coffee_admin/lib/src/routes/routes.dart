import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _navKey = GlobalKey<NavigatorState>();

GoRouter router() {
  return GoRouter(
    navigatorKey: _navKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('DrinkHub Admin')),
          body: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.admin_panel_settings_rounded, size: 64),
                SizedBox(height: 16),
                Text(
                  'DrinkHub Admin',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
