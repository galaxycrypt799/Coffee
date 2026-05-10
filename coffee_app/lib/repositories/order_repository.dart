import 'package:cloud_firestore/cloud_firestore.dart' hide Order;

import '../models/order.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrdersForUser(String userId);
  Future<void> placeOrder(Order order);
}

class LocalOrderRepository implements OrderRepository {
  LocalOrderRepository();

  static final List<Order> _orders = <Order>[];

  @override
  Future<List<Order>> getOrdersForUser(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    final filtered = _orders.where((order) => order.userId == userId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return List<Order>.unmodifiable(filtered);
  }

  @override
  Future<void> placeOrder(Order order) async {
    await Future<void>.delayed(const Duration(milliseconds: 260));
    _orders.removeWhere((existingOrder) => existingOrder.id == order.id);
    _orders.insert(0, order);
  }
}

class FirebaseOrderRepository implements OrderRepository {
  FirebaseOrderRepository({
    FirebaseFirestore? firestore,
  }) : _ordersCollection =
            (firestore ?? FirebaseFirestore.instance).collection('orders');

  final CollectionReference<Map<String, dynamic>> _ordersCollection;

  @override
  Future<List<Order>> getOrdersForUser(String userId) async {
    final snapshot = await _ordersCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((document) => Order.fromMap(document.data()))
        .toList(growable: false);
  }

  @override
  Future<void> placeOrder(Order order) async {
    await _ordersCollection.doc(order.id).set(order.toMap());
  }
}
