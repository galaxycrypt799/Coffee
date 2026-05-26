import 'package:coffee_admin/src/modules/operations/views/order.dart';
import 'package:coffee_admin/src/modules/operations/views/order_item.dart';
import 'package:coffee_admin/src/modules/operations/views/order_repo.dart';

class LocalOrderRepo implements OrderRepo {
  final List<Order> _orders = <Order>[
    Order(
      id: 'order-local-001',
      userId: 'local-guest',
      customerName: 'Nguyễn Văn A',
      customerPhone: '0900000001',
      customerEmail: 'guest@roastritual.app',
      items: const [
        OrderItem(
          coffeeId: 'phin-sua-da-signature',
          name: 'Phin Sữa Đá',
          quantity: 2,
          price: 49000,
        ),
      ],
      totalPrice: 98000,
      status: 'pending',
      paymentMethod: 'cash',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Order(
      id: 'order-local-002',
      userId: 'local-admin',
      customerName: 'Trần Thị B',
      customerPhone: '0900000002',
      customerEmail: 'admin@roastritual.app',
      items: const [
        OrderItem(
          coffeeId: 'cold-brew-cam',
          name: 'Cold Brew Cam',
          quantity: 1,
          price: 59000,
        ),
      ],
      totalPrice: 59000,
      status: 'delivered',
      paymentMethod: 'card',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  @override
  Future<void> createOrder(Order order) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _orders.insert(0, order);
  }

  @override
  Future<List<Order>> getMyOrders(
    String userId, {
    bool forceRefresh = false,
  }) async {
    return _orders
        .where((order) => order.userId == userId)
        .toList(growable: false);
  }

  @override
  Future<List<Order>> getOrders({bool forceRefresh = false}) async {
    return _orders.toList(growable: false);
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index == -1) {
      return;
    }
    _orders[index] = _orders[index].copyWith(status: status);
  }

  @override
  Future<Map<String, dynamic>> getRevenueStats({
    bool forceRefresh = false,
  }) async {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final startOfThisMonth = DateTime(now.year, now.month, 1);
    final startOfThisYear = DateTime(now.year, 1, 1);
    const revenueStatuses = <String>{'delivered', 'completed'};

    var today = 0;
    var month = 0;
    var year = 0;
    var completedOrders = 0;
    final weekly = List<int>.filled(7, 0);
    final monthly = List<int>.filled(12, 0);
    final statusCounts = <String, int>{};
    final itemSales = <String, _ItemSalesAccumulator>{};

    for (final order in _orders) {
      statusCounts.update(order.status, (count) => count + 1,
          ifAbsent: () => 1);

      if (!revenueStatuses.contains(order.status)) {
        continue;
      }

      completedOrders += 1;
      final orderTotal = order.totalPrice.round();
      final orderDate = DateTime(
          order.createdAt.year, order.createdAt.month, order.createdAt.day);

      if (!order.createdAt.isBefore(startOfToday)) {
        today += orderTotal;
      }
      if (!order.createdAt.isBefore(startOfThisMonth)) {
        month += orderTotal;
      }
      if (!order.createdAt.isBefore(startOfThisYear)) {
        year += orderTotal;
        monthly[order.createdAt.month - 1] += orderTotal;
      }

      final dayDifference = startOfToday.difference(orderDate).inDays;
      if (dayDifference >= 0 && dayDifference < 7) {
        weekly[6 - dayDifference] += orderTotal;
      }

      for (final item in order.items) {
        final key = item.coffeeId.isNotEmpty ? item.coffeeId : item.name;
        itemSales
            .putIfAbsent(key, () => _ItemSalesAccumulator(name: item.name))
            .add(
              quantity: item.quantity,
              revenue: (item.price * item.quantity).round(),
            );
      }
    }

    final topItems = itemSales.values.toList()
      ..sort((a, b) => b.quantity.compareTo(a.quantity));

    return {
      'today': today,
      'month': month,
      'year': year,
      'count': completedOrders,
      'totalOrders': _orders.length,
      'weekly': weekly,
      'monthly': monthly,
      'topItems': topItems
          .take(5)
          .map(
            (item) => {
              'name': item.name,
              'quantity': item.quantity,
              'revenue': item.revenue,
            },
          )
          .toList(growable: false),
      'statusCounts': statusCounts,
    };
  }
}

class _ItemSalesAccumulator {
  _ItemSalesAccumulator({required this.name});

  final String name;
  int quantity = 0;
  int revenue = 0;

  void add({required int quantity, required int revenue}) {
    this.quantity += quantity;
    this.revenue += revenue;
  }
}
