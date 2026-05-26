import 'package:coffee_app/models/cart.dart';
import 'package:coffee_app/models/cart_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Cart', () {
    test('adds duplicate drinks by increasing quantity', () {
      final item = CartItem(
        id: 'latte',
        name: 'Latte',
        imageUrl: 'assets/coffee/velvet_latte.jpg',
        price: 49000,
        category: 'coffee',
      );

      final cart =
          const Cart().addItem(item).addItem(item.copyWith(quantity: 2));

      expect(cart.items, hasLength(1));
      expect(cart.totalQuantity, 3);
      expect(cart.totalPrice, 147000);
    });

    test('restores persisted cart data', () {
      final cart = Cart(
        items: [
          CartItem(
            id: 'cold-brew',
            name: 'Cold Brew',
            imageUrl: 'assets/coffee/house_cold_brew.jpg',
            price: 52000,
            category: 'cold brew',
            quantity: 2,
          ),
        ],
      );

      final restored = Cart.fromJson(cart.toJson());

      expect(restored.items, hasLength(1));
      expect(restored.items.first.id, 'cold-brew');
      expect(restored.items.first.quantity, 2);
      expect(restored.totalPrice, 104000);
    });
  });
}
