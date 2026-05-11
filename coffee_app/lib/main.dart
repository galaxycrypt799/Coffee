import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:coffee_app/app.dart';
import 'package:coffee_app/app_bootstrap.dart';
import 'package:coffee_app/simple_bloc_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  runApp(const _BootstrapLoaderApp());
}

class _BootstrapLoaderApp extends StatefulWidget {
  const _BootstrapLoaderApp();

  @override
  State<_BootstrapLoaderApp> createState() => _BootstrapLoaderAppState();
}

class _BootstrapLoaderAppState extends State<_BootstrapLoaderApp> {
  late final Future<AppBootstrap> _bootstrapFuture;

  @override
  void initState() {
    super.initState();
    _bootstrapFuture = AppBootstrap.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppBootstrap>(
      future: _bootstrapFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyApp(snapshot.data!);
        }

        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: Color(0xFFF3ECE5),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_drink_rounded,
                    size: 56,
                    color: Color(0xFF7B4B34),
                  ),
                  SizedBox(height: 16),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
