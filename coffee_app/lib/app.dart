import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_bootstrap.dart';
import 'app_view.dart';
import 'blocs/authentication_bloc/authentication_bloc.dart';

class MyApp extends StatelessWidget {
  final AppBootstrap bootstrap;
  const MyApp(this.bootstrap, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create: (context) =>
          AuthenticationBloc(userRepository: bootstrap.userRepository),
      child: MyAppView(bootstrap: bootstrap),
    );
  }
}
