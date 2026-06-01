import 'dart:developer';

import 'package:coffee_repository/coffee_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:user_repository/user_repository.dart';

import 'firebase_options.dart';
import 'repositories/order_repository.dart';

enum BackendMode { firebase, local }

class AppBootstrap {
  const AppBootstrap._({
    required this.userRepository,
    required this.coffeeRepository,
    required this.orderRepository,
    required this.backendMode,
  });

  final UserRepository userRepository;
  final CoffeeRepo coffeeRepository;
  final OrderRepository orderRepository;
  final BackendMode backendMode;

  bool get usesFirebase => backendMode == BackendMode.firebase;

  static Future<AppBootstrap> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      return AppBootstrap._(
        userRepository: FirebaseUserRepo(),
        coffeeRepository: FirebaseCoffeeRepo(),
        orderRepository: FirebaseOrderRepository(),
        backendMode: BackendMode.firebase,
      );
    } catch (error, stackTrace) {
      log(
        'Firebase initialization failed',
        error: error,
        stackTrace: stackTrace,
      );

      return _local();
    }
  }

  static AppBootstrap _local() {
    return AppBootstrap._(
      userRepository: LocalUserRepo(),
      coffeeRepository: const LocalCoffeeRepo(),
      orderRepository: LocalOrderRepository(),
      backendMode: BackendMode.local,
    );
  }
}
