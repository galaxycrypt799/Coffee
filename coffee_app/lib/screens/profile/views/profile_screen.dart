import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/authentication_bloc/authentication_bloc.dart';
import '../../../utils/price_formatter.dart';
import '../../orders/cubit/order_history_cubit.dart';
import '../../orders/views/order_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, authState) {
        final user = authState.user;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Tài khoản'),
          ),
          body: BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
            builder: (context, state) {
              final completedOrders = state.orders
                  .where((order) => order.countsTowardSpending)
                  .toList(growable: false);
              final completedTotal = completedOrders.fold<double>(
                0,
                (sum, order) => sum + order.totalPrice,
              );
              final memberRank = _MemberRank.fromTotalSpent(completedTotal);

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE7D3BD)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 34,
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          child: Text(
                            (user?.name.trim().isNotEmpty == true
                                    ? user!.name.trim()[0]
                                    : 'R')
                                .toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.name ?? 'Khách',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user?.email ?? '',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 10),
                              _MemberRankChip(rank: memberRank),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _MetricCard(
                          label: 'Đơn hoàn thành',
                          value: '${completedOrders.length}',
                          onTap: () => _openCompletedOrders(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _MetricCard(
                          label: 'Tổng chi',
                          value: formatVnd(completedTotal),
                          onTap: () => _openCompletedOrders(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _ActionTile(
                    icon: Icons.receipt_long_outlined,
                    title: 'Lịch sử đơn hàng',
                    subtitle: 'Xem các đơn đã đặt và trạng thái hiện tại.',
                    onTap: () {
                      Navigator.of(context).pushNamed('/orders');
                    },
                  ),
                  const SizedBox(height: 12),
                  _ActionTile(
                    icon: Icons.logout_rounded,
                    title: 'Đăng xuất',
                    subtitle:
                        'Thoát tài khoản hiện tại và quay lại màn đăng nhập.',
                    onTap: () {
                      context
                          .read<AuthenticationBloc>()
                          .add(const AuthenticationLogoutRequested());
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _openCompletedOrders(BuildContext context) {
    Navigator.of(context).pushNamed(
      '/orders',
      arguments: OrderHistoryFilter.completed,
    );
  }
}

class _MemberRank {
  const _MemberRank({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;

  factory _MemberRank.fromTotalSpent(double totalSpent) {
    if (totalSpent >= 10000000) {
      return const _MemberRank(
        label: 'Bạch kim',
        color: Color(0xFF5A6FD8),
        icon: Icons.diamond_outlined,
      );
    }
    if (totalSpent >= 3000000) {
      return const _MemberRank(
        label: 'Vàng',
        color: Color(0xFFC48322),
        icon: Icons.workspace_premium_rounded,
      );
    }
    if (totalSpent >= 1000000) {
      return const _MemberRank(
        label: 'Bạc',
        color: Color(0xFF6B7280),
        icon: Icons.military_tech_rounded,
      );
    }
    return const _MemberRank(
      label: 'Đồng',
      color: Color(0xFF9A5B2E),
      icon: Icons.local_cafe_rounded,
    );
  }
}

class _MemberRankChip extends StatelessWidget {
  const _MemberRankChip({required this.rank});

  final _MemberRank rank;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: rank.color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: rank.color.withValues(alpha: 0.24)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(rank.icon, size: 16, color: rank.color),
            const SizedBox(width: 6),
            Text(
              'Hạng ${rank.label}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: rank.color,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE7D3BD)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                if (onTap != null) const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE7D3BD)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF5EBDE),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}
