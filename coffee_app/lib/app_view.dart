import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:coffee_app/repositories/order_repository.dart';
import 'package:coffee_app/screens/auth/blocs/sing_in_bloc/sign_in_bloc.dart';
import 'package:coffee_app/screens/home/blocs/get_coffee_bloc/get_coffee_bloc.dart';
import 'package:coffee_app/screens/home/blocs/cart_bloc/cart_bloc.dart';
import 'package:coffee_app/screens/orders/cubit/order_history_cubit.dart';
import 'package:coffee_app/screens/orders/views/order_history_screen.dart';
import 'package:coffee_app/screens/profile/views/profile_screen.dart';
import 'package:coffee_app/theme/app_theme.dart';
import 'package:coffee_repository/coffee_repository.dart';

import 'app_bootstrap.dart';
import 'screens/onboarding/views/onboarding_screen.dart';
import 'screens/auth/views/welcome_screen.dart';
import 'screens/home/views/main_screen.dart';
import 'screens/home/views/product_detail_screen.dart';
import 'screens/home/views/cart_screen.dart';
import 'screens/home/views/checkout_screen.dart';

class MyAppView extends StatefulWidget {
  const MyAppView({
    required this.bootstrap,
    super.key,
  });

  final AppBootstrap bootstrap;

  @override
  State<MyAppView> createState() => _MyAppViewState();
}

class _MyAppViewState extends State<MyAppView> {
  bool _showOnboarding = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DrinkHub - Đặt đồ uống',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: _showOnboarding
          ? OnboardingScreen(onFinish: () => setState(() => _showOnboarding = false))
          : BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                if (state.status == AuthenticationStatus.authenticated) {
                  return RepositoryProvider<OrderRepository>.value(
                    value: widget.bootstrap.orderRepository,
                    child: MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => SignInBloc(
                            context.read<AuthenticationBloc>().userRepository,
                          ),
                        ),
                        BlocProvider(
                          create: (context) => GetCoffeeBloc(
                            widget.bootstrap.coffeeRepository,
                          )..add(GetCoffeeRequested()),
                        ),
                        BlocProvider(
                          create: (context) =>
                              CartBloc()..add(const LoadCartEvent()),
                        ),
                        BlocProvider(
                          create: (context) =>
                              OrderHistoryCubit(widget.bootstrap.orderRepository),
                        ),
                      ],
                      child: _AppNavigator(bootstrap: widget.bootstrap),
                    ),
                  );
                }

                return WelcomeScreen(bootstrap: widget.bootstrap);
              },
            ),
    );
  }
}

class _AppNavigator extends StatefulWidget {
  final AppBootstrap bootstrap;

  const _AppNavigator({required this.bootstrap});

  @override
  State<_AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<_AppNavigator> {
  late final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (settings) {
        final args = settings.arguments;

        switch (settings.name ?? '/') {
          case '/':
            return MaterialPageRoute(
              builder: (_) => MainScreen(bootstrap: widget.bootstrap),
            );
          case '/product_detail':
            if (args is Coffee) {
              return MaterialPageRoute(
                builder: (_) => ProductDetailScreen(drink: args),
              );
            }
            return _errorRoute();
          case '/cart':
            return MaterialPageRoute(
              builder: (_) => const CartScreen(),
            );
          case '/checkout':
            return MaterialPageRoute(
              builder: (_) => const CheckoutScreen(),
            );
          case '/orders':
            context.read<OrderHistoryCubit>().loadOrders(
                  context.read<AuthenticationBloc>().state.user?.userId ?? '',
                );
            return MaterialPageRoute(
              builder: (_) => const OrderHistoryScreen(),
            );
          case '/profile':
            context.read<OrderHistoryCubit>().loadOrders(
                  context.read<AuthenticationBloc>().state.user?.userId ?? '',
                );
            return MaterialPageRoute(
              builder: (_) => ProfileScreen(
                backendLabel: widget.bootstrap.statusTitle,
              ),
            );
          default:
            return _errorRoute();
        }
      },
      initialRoute: '/',
    );
  }

  Route _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Page not found')),
      ),
    );
  }
}
