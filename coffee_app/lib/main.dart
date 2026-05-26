import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:coffee_app/app.dart';
import 'package:coffee_app/app_bootstrap.dart';
import 'package:coffee_app/simple_bloc_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khóa hướng màn hình dọc để giao diện luôn ổn định
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

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

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          // Áp dụng ThemeData như bạn mong muốn để đồng bộ màu sắc
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF7B4B34), // Màu nâu cà phê chủ đạo
              brightness: Brightness.light,
            ),
          ),
          home: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle
                .dark, // Hiển thị pin/sóng rõ ràng trên nền sáng
            child: Scaffold(
              backgroundColor: const Color(0xFFF3ECE5), // Màu Cream
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.coffee_rounded,
                      size: 72,
                      color: Color(0xFF7B4B34),
                    ),
                    const SizedBox(height: 24),
                    const CircularProgressIndicator(),
                    const SizedBox(height: 24),
                    Text(
                      "COFFEE APP",
                      style: TextStyle(
                        color: const Color(0xFF7B4B34).withValues(alpha: 0.6),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
