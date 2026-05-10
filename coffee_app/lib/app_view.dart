import 'package:flutter/material.dart';
import 'package:coffee_app/theme/app_theme.dart';

import 'app_bootstrap.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({
    required this.bootstrap,
    super.key,
  });

  final AppBootstrap bootstrap;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DrinkHub - Đặt đồ uống',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(title: const Text('DrinkHub')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.local_drink_rounded, size: 64),
              const SizedBox(height: 16),
              Text(
                'DrinkHub',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                bootstrap.statusMessage,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
