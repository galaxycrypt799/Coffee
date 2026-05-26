import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coffee_app/blocs/authentication_bloc/authentication_bloc.dart';
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
  static const String _onboardingSeenKey = 'coffee_app_onboarding_seen_v2';

  bool? _showOnboarding;

  @override
  void initState() {
    super.initState();
    _loadOnboardingPreference();
  }

  Future<void> _loadOnboardingPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool(_onboardingSeenKey) ?? false;
    if (!mounted) {
      return;
    }
    setState(() {
      _showOnboarding = !seenOnboarding;
    });
  }

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingSeenKey, true);
    if (!mounted) {
      return;
    }
    setState(() {
      _showOnboarding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final showOnboarding = _showOnboarding;

    return MaterialApp(
      title: 'Coffee App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: showOnboarding == null
          ? const _StartupScreen()
          : showOnboarding
              ? OnboardingScreen(onFinish: _finishOnboarding)
              : BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    if (state.status == AuthenticationStatus.authenticated) {
                      return _AppNavigator(bootstrap: widget.bootstrap);
                    }
                    return WelcomeScreen(bootstrap: widget.bootstrap);
                  },
                ),
    );
  }
}

class _StartupScreen extends StatelessWidget {
  const _StartupScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
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
            final initialIndex = args is int ? args : MainScreen.homeTabIndex;
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => MainScreen(
                bootstrap: widget.bootstrap,
                initialIndex: initialIndex,
              ),
            );
          case '/product_detail':
            if (args is Coffee) {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => ProductDetailScreen(drink: args),
              );
            }
            return _errorRoute();
          case '/cart':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const CartScreen(),
            );
          case '/checkout':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const CheckoutScreen(),
            );
          case '/orders':
            final userId =
                context.read<AuthenticationBloc>().state.user?.userId ?? '';
            context.read<OrderHistoryCubit>().loadOrders(userId);
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const OrderHistoryScreen(),
            );
          case '/profile':
            return MaterialPageRoute(
              settings: settings,
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
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Page not found')),
      ),
    );
  }
}
