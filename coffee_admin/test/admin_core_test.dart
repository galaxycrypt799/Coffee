import 'package:coffee_admin/src/modules/operations/views/local_order_repo.dart';
import 'package:coffee_admin/src/utils/price_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formats VND values with thousands separators', () {
    expect(formatVnd(0), '0đ');
    expect(formatVnd(49000), '49.000đ');
    expect(formatVnd(1234567), '1.234.567đ');
  });

  test('local order repository updates order status and revenue stats',
      () async {
    final repository = LocalOrderRepo();
    final orders = await repository.getOrders();
    final pendingOrder =
        orders.firstWhere((order) => order.status == 'pending');

    await repository.updateOrderStatus(pendingOrder.id, 'delivered');

    final updatedOrders = await repository.getOrders();
    final updatedOrder = updatedOrders.firstWhere(
      (order) => order.id == pendingOrder.id,
    );
    final stats = await repository.getRevenueStats();

    expect(updatedOrder.status, 'delivered');
    expect(stats['count'], 2);
  });
}
