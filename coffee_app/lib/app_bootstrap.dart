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
    required this.statusTitle,
    required this.statusMessage,
    this.warning,
  });

  final UserRepository userRepository;
  final CoffeeRepo coffeeRepository;
  final OrderRepository orderRepository;
  final BackendMode backendMode;
  final String statusTitle;
  final String statusMessage;
  final String? warning;

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
        statusTitle: 'Online',
        statusMessage:
            'Tài khoản và thực đơn đang được đồng bộ hóa trực tiếp từ hệ thống Coffee App.',
      );
    } catch (error, stackTrace) {
      log(
        'Firebase initialization failed',
        error: error,
        stackTrace: stackTrace,
      );

      return _local(
        statusMessage:
            'Không thể kết nối máy chủ. App đã tự động chuyển sang chế độ hoạt động ngoại tuyến.',
        warning: error.toString(),
      );
    }
  }

  static AppBootstrap _local({
    required String statusMessage,
    String? warning,
  }) {
    return AppBootstrap._(
      userRepository: LocalUserRepo(),
      coffeeRepository: const LocalCoffeeRepo(),
      orderRepository: LocalOrderRepository(),
      backendMode: BackendMode.local,
      statusTitle: 'Offline',
      statusMessage: statusMessage,
      warning: warning,
    );
  }
}
