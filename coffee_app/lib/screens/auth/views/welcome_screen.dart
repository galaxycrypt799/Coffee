import 'package:coffee_app/app_bootstrap.dart';
import 'package:coffee_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:coffee_app/screens/auth/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:coffee_app/screens/auth/blocs/sing_in_bloc/sign_in_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'sign_in_screen.dart';
import 'sign_up_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    required this.bootstrap,
    super.key,
  });

  final AppBootstrap bootstrap;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/coffee/hero_shop.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0x801A120F),
                      const Color(0xCC241611),
                      Theme.of(context).colorScheme.surface,
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            child: const Icon(
                              Icons.local_drink_rounded,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'COFFEE APP',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(color: Colors.white),
                              ),
                              Text(
                                'Đặt đồ uống yêu thích của bạn',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.white70),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                      child: Text(
                        'Thức uống ngon - Giao nhanh - Dễ dàng',
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: Colors.white,
                                  height: 1.02,
                                ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
                      child: Text(
                        '',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              height: 1.45,
                            ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(24, 18, 24, 32),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _BenefitChip(
                            icon: Icons.workspace_premium_rounded,
                            label: 'Nhanh chóng',
                          ),
                          _BenefitChip(
                            icon: Icons.shopping_bag_outlined,
                            label: 'Tiện lợi',
                          ),
                          _BenefitChip(
                            icon: Icons.storefront_outlined,
                            label: 'Dễ dùng',
                          ),
                        ],
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        minHeight: height * 0.55,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surface
                            .withValues(alpha: 0.97),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 12),
                          Container(
                            width: 56,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD4B08B),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: _BackendStatusCard(bootstrap: bootstrap),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.82),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TabBar(
                              dividerColor: Colors.transparent,
                              indicator: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              indicatorPadding: const EdgeInsets.all(4),
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelColor: Colors.white,
                              unselectedLabelColor: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.6),
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              tabs: const [
                                Tab(text: 'Đăng nhập'),
                                Tab(text: 'Đăng ký'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 480, // Chiều cao đủ cho form
                            child: TabBarView(
                              children: [
                                BlocProvider<SignInBloc>(
                                  create: (context) => SignInBloc(
                                    context
                                        .read<AuthenticationBloc>()
                                        .userRepository,
                                  ),
                                  child: SignInScreen(
                                    usesFirebase: bootstrap.usesFirebase,
                                  ),
                                ),
                                BlocProvider<SignUpBloc>(
                                  create: (context) => SignUpBloc(
                                    context
                                        .read<AuthenticationBloc>()
                                        .userRepository,
                                  ),
                                  child: SignUpScreen(
                                    usesFirebase: bootstrap.usesFirebase,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BenefitChip extends StatelessWidget {
  const _BenefitChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _BackendStatusCard extends StatelessWidget {
  const _BackendStatusCard({
    required this.bootstrap,
  });

  final AppBootstrap bootstrap;

  @override
  Widget build(BuildContext context) {
    final accentColor = bootstrap.usesFirebase
        ? Theme.of(context).colorScheme.tertiary
        : Theme.of(context).colorScheme.secondary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6D3BF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              bootstrap.usesFirebase
                  ? Icons.cloud_done_outlined
                  : Icons.layers_outlined,
              color: accentColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bootstrap.statusTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  bootstrap.statusMessage,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.45,
                      ),
                ),
                if (bootstrap.warning != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    bootstrap.warning!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF8D3A23),
                          fontWeight: FontWeight.w700,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
