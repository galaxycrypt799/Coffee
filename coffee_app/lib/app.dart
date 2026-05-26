import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:user_repository/user_repository.dart';

import 'app_bootstrap.dart';
import 'app_view.dart';
import 'blocs/authentication_bloc/authentication_bloc.dart';
import 'screens/home/blocs/get_coffee_bloc/get_coffee_bloc.dart';
import 'screens/home/blocs/cart_bloc/cart_bloc.dart';
import 'screens/orders/cubit/order_history_cubit.dart';
import 'repositories/order_repository.dart';

class MyApp extends StatelessWidget {
  final AppBootstrap bootstrap;
  const MyApp(this.bootstrap, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>.value(
            value: bootstrap.userRepository),
        RepositoryProvider<CoffeeRepo>.value(value: bootstrap.coffeeRepository),
        RepositoryProvider<OrderRepository>.value(
            value: bootstrap.orderRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(
              userRepository: bootstrap.userRepository,
            ),
          ),
          BlocProvider<GetCoffeeBloc>(
            create: (context) => GetCoffeeBloc(
              bootstrap.coffeeRepository,
            )..add(const GetCoffeeRequested()),
          ),
          BlocProvider<CartBloc>(
            create: (context) => CartBloc()..add(const LoadCartEvent()),
          ),
          BlocProvider<OrderHistoryCubit>(
            create: (context) => OrderHistoryCubit(bootstrap.orderRepository),
          ),
        ],
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listenWhen: (previous, current) =>
              previous.user?.userId != current.user?.userId,
          listener: (context, state) {
            context.read<OrderHistoryCubit>().loadOrders(
                  state.user?.userId ?? '',
                );
          },
          child: MyAppView(bootstrap: bootstrap),
        ),
      ),
    );
  }
}
