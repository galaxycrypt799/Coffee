import 'cart_item.dart';

// ignore_for_file: prefer_const_constructors

class Cart {
  final List<CartItem> items;

  const Cart({this.items = const []});

  int get itemCount => items.length;

  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => items.fold(0, (sum, item) => sum + item.subtotal);

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;

  // Thêm item vào giỏ hàng
  Cart addItem(CartItem item) {
    final existingIndex = items.indexWhere((i) => i.id == item.id);

    if (existingIndex >= 0) {
      // Nếu item đã có, tăng quantity
      final updatedItems = List<CartItem>.from(items);
      updatedItems[existingIndex] =
          updatedItems[existingIndex].copyWith(quantity: updatedItems[existingIndex].quantity + item.quantity);
      return Cart(items: updatedItems);
    } else {
      // Thêm item mới
      return Cart(items: [...items, item]);
    }
  }

  // Xoá item khỏi giỏ hàng
  Cart removeItem(String itemId) {
    return Cart(items: items.where((item) => item.id != itemId).toList());
  }

  // Cập nhật quantity của item
  Cart updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      return removeItem(itemId);
    }

    final updatedItems = items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    return Cart(items: updatedItems);
  }

  // Xoá toàn bộ giỏ hàng
  Cart clear() => Cart();

  Map<String, dynamic> toJson() => {
        'items': items.map((item) => item.toJson()).toList(),
      };

  factory Cart.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List<dynamic>?)
            ?.whereType<Map<String, dynamic>>() ??
        [];
    return Cart(
      items: rawItems.map((e) => CartItem.fromJson(e)).toList(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cart &&
          runtimeType == other.runtimeType &&
          items == other.items;

  @override
  int get hashCode => items.hashCode;
}
