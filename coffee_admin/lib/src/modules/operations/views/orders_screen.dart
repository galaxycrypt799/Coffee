import 'package:coffee_admin/src/utils/price_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'order.dart';
import 'orders_bloc.dart';
import 'revenue_bloc.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String _selectedStatus = _OrderStatusFilter.all.key;

  static const List<_OrderStatusFilter> _statusFilters = [
    _OrderStatusFilter.all,
    _OrderStatusFilter('pending', 'Chờ xử lý'),
    _OrderStatusFilter('confirmed', 'Đã nhận'),
    _OrderStatusFilter('preparing', 'Đang pha'),
    _OrderStatusFilter('ready', 'Sẵn sàng'),
    _OrderStatusFilter('delivered', 'Đã giao'),
    _OrderStatusFilter('completed', 'Hoàn thành'),
    _OrderStatusFilter('cancelled', 'Đã hủy'),
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'preparing':
        return Colors.deepPurple;
      case 'ready':
        return Colors.teal;
      case 'delivered':
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton.filledTonal(
                tooltip: 'Tải lại đơn hàng',
                onPressed: () {
                  context.read<OrdersBloc>().add(
                        const GetOrders(forceRefresh: true),
                      );
                  context.read<RevenueBloc>().add(
                        const GetRevenueRequested(forceRefresh: true),
                      );
                },
                icon: const Icon(Icons.refresh_rounded),
              ),
            ),
          ),
          BlocBuilder<RevenueBloc, RevenueState>(
            builder: (context, state) {
              if (state is RevenueSuccess) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('Hôm nay', formatVnd(state.today)),
                      _buildStatItem('Tháng này', formatVnd(state.month)),
                      _buildStatItem(
                        'Đã giao',
                        state.completedOrders.toString(),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          Expanded(child: _buildOrdersList()),
        ],
      ),
    );
  }

  Widget _buildOrdersList() {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        if (state is OrdersLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is OrdersFailure) {
          return const Center(child: Text('Không thể tải đơn hàng'));
        }
        if (state is OrdersSuccess) {
          if (state.orders.isEmpty) {
            return const Center(child: Text('Chưa có đơn hàng nào'));
          }

          final sortedOrders = _sortNewestFirst(state.orders);
          final countsByStatus = _countByStatus(sortedOrders);
          final filteredOrders = _filterOrders(sortedOrders);

          return Column(
            children: [
              _buildStatusFilters(sortedOrders.length, countsByStatus),
              Expanded(
                child: filteredOrders.isEmpty
                    ? const Center(child: Text('Không có đơn trong mục này'))
                    : RefreshIndicator(
                        onRefresh: () async {
                          context.read<OrdersBloc>().add(
                                const GetOrders(forceRefresh: true),
                              );
                          context.read<RevenueBloc>().add(
                                const GetRevenueRequested(forceRefresh: true),
                              );
                        },
                        child: ListView.builder(
                          itemCount: filteredOrders.length,
                          padding: const EdgeInsets.all(16),
                          itemBuilder: (context, index) {
                            return _buildOrderCard(
                              context,
                              filteredOrders[index],
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildStatusFilters(
    int totalOrders,
    Map<String, int> countsByStatus,
  ) {
    return SizedBox(
      height: 54,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _statusFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _statusFilters[index];
          final count = filter.key == _OrderStatusFilter.all.key
              ? totalOrders
              : countsByStatus[filter.key] ?? 0;

          return ChoiceChip(
            label: Text('${filter.label} ($count)'),
            selected: _selectedStatus == filter.key,
            onSelected: (_) {
              setState(() => _selectedStatus = filter.key);
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(order.status),
          child: const Icon(Icons.receipt_long, color: Colors.white),
        ),
        title: Text(
          'Đơn hàng #${_shortOrderId(order.id)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Khách: ${order.customerName} - '
          '${DateFormat('HH:mm dd/MM/yyyy').format(order.createdAt)}',
        ),
        trailing: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: order.status,
            isDense: true,
            items: const [
              DropdownMenuItem(value: 'pending', child: Text('Chờ')),
              DropdownMenuItem(value: 'confirmed', child: Text('Đã nhận')),
              DropdownMenuItem(value: 'preparing', child: Text('Đang pha')),
              DropdownMenuItem(value: 'ready', child: Text('Sẵn sàng')),
              DropdownMenuItem(value: 'delivered', child: Text('Đã giao')),
              DropdownMenuItem(value: 'completed', child: Text('Hoàn thành')),
              DropdownMenuItem(value: 'cancelled', child: Text('Hủy')),
            ],
            onChanged: (value) {
              if (value != null && value != order.status) {
                context
                    .read<OrdersBloc>()
                    .add(UpdateOrderStatus(order.id, value));
              }
            },
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ...order.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(child: Text('${item.quantity}x ${item.name}')),
                        const SizedBox(width: 12),
                        Text(formatVnd(item.price * item.quantity)),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tổng cộng:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      formatVnd(order.totalPrice),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Order> _sortNewestFirst(List<Order> orders) {
    final sortedOrders = orders.toList(growable: false)
      ..sort((a, b) {
        final createdAtCompare = b.createdAt.compareTo(a.createdAt);
        if (createdAtCompare != 0) {
          return createdAtCompare;
        }
        return b.id.compareTo(a.id);
      });
    return sortedOrders;
  }

  Map<String, int> _countByStatus(List<Order> orders) {
    final counts = <String, int>{};
    for (final order in orders) {
      counts.update(order.status, (value) => value + 1, ifAbsent: () => 1);
    }
    return counts;
  }

  List<Order> _filterOrders(List<Order> orders) {
    if (_selectedStatus == _OrderStatusFilter.all.key) {
      return orders;
    }
    return orders
        .where((order) => order.status == _selectedStatus)
        .toList(growable: false);
  }

  String _shortOrderId(String orderId) {
    if (orderId.length <= 8) {
      return orderId;
    }
    return orderId.substring(0, 8);
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}

class _OrderStatusFilter {
  const _OrderStatusFilter(this.key, this.label);

  final String key;
  final String label;

  static const all = _OrderStatusFilter('all', 'Tất cả');
}
