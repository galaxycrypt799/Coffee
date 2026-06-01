import 'package:coffee_app/components/coffee_image.dart';
import 'package:coffee_app/models/cart_item.dart';
import 'package:coffee_app/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../blocs/authentication_bloc/authentication_bloc.dart';
import '../../../utils/price_formatter.dart';
import '../cubit/order_history_cubit.dart';

enum OrderHistoryFilter { all, completed }

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({
    this.initialFilter = OrderHistoryFilter.all,
    super.key,
  });

  final OrderHistoryFilter initialFilter;

  @override
  Widget build(BuildContext context) {
    final showCompletedOnly = initialFilter == OrderHistoryFilter.completed;

    return Scaffold(
      appBar: AppBar(
        title: Text(showCompletedOnly ? 'Đơn hoàn thành' : 'Lịch sử đơn hàng'),
      ),
      body: BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final visibleOrders = showCompletedOnly
              ? state.orders
                  .where((order) => order.countsTowardSpending)
                  .toList(growable: false)
              : state.orders;

          if (visibleOrders.isEmpty) {
            return _EmptyOrdersView(showCompletedOnly: showCompletedOnly);
          }

          return RefreshIndicator(
            onRefresh: () async {
              final cubit = context.read<OrderHistoryCubit>();
              final authBloc = context.read<AuthenticationBloc>();
              final userId = authBloc.state.user?.userId ?? '';
              if (userId.isNotEmpty) {
                await cubit.loadOrders(userId, forceRefresh: true);
              }
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: visibleOrders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = visibleOrders[index];
                return _OrderHistoryCard(
                  order: order,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => OrderDetailScreen(order: order),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({
    required this.order,
    super.key,
  });

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn hàng'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mã đơn ${_formatOrderCode(order.id)}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DateFormat('HH:mm - dd/MM/yyyy')
                                .format(order.createdAt),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    _StatusChip(label: order.statusDisplay),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _SectionCard(
            title: 'Món đã đặt',
            child: Column(
              children: [
                for (final item in order.items) ...[
                  _OrderItemRow(item: item),
                  if (item != order.items.last) const Divider(height: 20),
                ],
                const Divider(height: 28),
                _InfoRow(
                  label: 'Tổng thanh toán',
                  value: formatVnd(order.totalPrice),
                  isEmphasized: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _SectionCard(
            title: 'Thông tin nhận hàng',
            child: Column(
              children: [
                _InfoRow(label: 'Tên khách', value: order.customerName),
                _InfoRow(label: 'Số điện thoại', value: order.customerPhone),
                if (order.customerEmail.trim().isNotEmpty)
                  _InfoRow(label: 'Email', value: order.customerEmail),
                if (order.deliveryAddress?.trim().isNotEmpty == true)
                  _InfoRow(
                    label: 'Địa chỉ',
                    value: order.deliveryAddress!.trim(),
                  ),
                _InfoRow(
                  label: 'Thanh toán',
                  value: order.paymentMethodDisplay,
                ),
                if (order.notes?.trim().isNotEmpty == true)
                  _InfoRow(label: 'Ghi chú', value: order.notes!.trim()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderHistoryCard extends StatelessWidget {
  const _OrderHistoryCard({
    required this.order,
    required this.onTap,
  });

  final Order order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE7D3BD)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Mã đơn ${_formatOrderCode(order.id)}',
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                _StatusChip(label: order.statusDisplay),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              DateFormat('HH:mm - dd/MM/yyyy').format(order.createdAt),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 14),
            ...order.items.take(3).map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${item.quantity}x ${item.name}',
                            style: Theme.of(context).textTheme.bodyLarge,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(formatVnd(item.subtotal)),
                      ],
                    ),
                  ),
                ),
            if (order.items.length > 3)
              Text(
                '+${order.items.length - 3} món khác',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng thanh toán',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formatVnd(order.totalPrice),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right_rounded),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyOrdersView extends StatelessWidget {
  const _EmptyOrdersView({required this.showCompletedOnly});

  final bool showCompletedOnly;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.receipt_long_outlined, size: 68),
            const SizedBox(height: 16),
            Text(
              showCompletedOnly
                  ? 'Chưa có đơn hoàn thành'
                  : 'Bạn chưa có đơn hàng nào',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              showCompletedOnly
                  ? 'Các đơn đã giao sẽ được tính vào tổng chi.'
                  : 'Đơn mới sau khi checkout sẽ xuất hiện tại đây.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.child,
    this.title,
  });

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE7D3BD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title!, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 14),
          ],
          child,
        ],
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  const _OrderItemRow({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: CoffeeImage(
            imagePath: item.imageUrl,
            width: 54,
            height: 54,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                '${item.quantity} x ${formatVnd(item.price)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          formatVnd(item.subtotal),
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.isEmphasized = false,
  });

  final String label;
  final String value;
  final bool isEmphasized;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 118,
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value.trim().isEmpty ? '---' : value,
              textAlign: TextAlign.right,
              style: (isEmphasized
                      ? Theme.of(context).textTheme.titleMedium
                      : Theme.of(context).textTheme.bodyLarge)
                  ?.copyWith(
                color:
                    isEmphasized ? Theme.of(context).colorScheme.primary : null,
                fontWeight: isEmphasized ? FontWeight.w800 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatOrderCode(String orderId) {
  final trimmed = orderId.trim();
  if (trimmed.isEmpty) {
    return '---';
  }
  if (trimmed.startsWith('order_')) {
    return trimmed.split('_').last;
  }
  return trimmed.length <= 12 ? trimmed : trimmed.substring(0, 12);
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EBDE),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
