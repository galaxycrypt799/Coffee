import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_app/app.dart';
import 'package:coffee_app/app_bootstrap.dart';
import 'package:coffee_app/simple_bloc_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();

  final bootstrap = await AppBootstrap.initialize();
  runApp(MyApp(bootstrap));
}
