import 'package:coffee_app/models/cart_item.dart';
import 'package:coffee_app/models/order.dart';
import 'package:coffee_app/repositories/order_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('local order repository persists order history across instances',
      () async {
    final firstRepository = LocalOrderRepository();

    await firstRepository.placeOrder(
      Order(
        id: 'order_1001',
        userId: 'user-1',
        customerName: 'Nguyen Van A',
        customerPhone: '0900000001',
        customerEmail: 'guest@example.com',
        items: [
          CartItem(
            id: 'latte',
            name: 'Latte',
            imageUrl: 'assets/coffee/velvet_latte.jpg',
            price: 49000,
            category: 'coffee',
          ),
        ],
        totalPrice: 49000,
        status: 'pending',
        paymentMethod: 'cash',
        createdAt: DateTime(2026, 5, 11, 8, 30),
      ),
    );

    final secondRepository = LocalOrderRepository();
    final orders = await secondRepository.getOrdersForUser('user-1');

    expect(orders, hasLength(1));
    expect(orders.single.id, 'order_1001');
    expect(orders.single.totalPrice, 49000);
  });
}
