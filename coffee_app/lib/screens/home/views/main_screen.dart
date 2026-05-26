import 'package:coffee_app/app_bootstrap.dart';
import 'package:coffee_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:coffee_app/screens/home/views/home_screen.dart';
import 'package:coffee_app/screens/orders/cubit/order_history_cubit.dart';
import 'package:coffee_app/screens/orders/views/order_history_screen.dart';
import 'package:coffee_app/screens/profile/views/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'menu_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    required this.bootstrap,
    this.initialIndex = homeTabIndex,
    super.key,
  });

  static const int homeTabIndex = 0;
  static const int activityTabIndex = 2;

  final AppBootstrap bootstrap;
  final int initialIndex;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex.clamp(0, 3);
    _pages = [
      HomeScreen(
        bootstrap: widget.bootstrap,
        onOpenMenu: () => _onItemTapped(1),
      ),
      MenuScreen(bootstrap: widget.bootstrap),
      const OrderHistoryScreen(),
      ProfileScreen(backendLabel: widget.bootstrap.statusTitle),
    ];
    if (_selectedIndex == MainScreen.activityTabIndex) {
      _loadOrders();
    }
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      return;
    }

    if (index == MainScreen.activityTabIndex) {
      _loadOrders();
    }
    setState(() => _selectedIndex = index);
  }

  void _loadOrders() {
    final userId = context.read<AuthenticationBloc>().state.user?.userId ?? '';
    context.read<OrderHistoryCubit>().loadOrders(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: const Color(0xFF9E9E9E),
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home_rounded),
                  label: 'Trang chủ',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.local_cafe_outlined),
                  activeIcon: Icon(Icons.local_cafe_rounded),
                  label: 'Đặt món',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.assignment_outlined),
                  activeIcon: Icon(Icons.assignment_rounded),
                  label: 'Hoạt động',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline_rounded),
                  activeIcon: Icon(Icons.person_rounded),
                  label: 'Tài khoản',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
