import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/order.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrdersForUser(String userId);
  Future<void> placeOrder(Order order);
}

class LocalOrderRepository implements OrderRepository {
  LocalOrderRepository() : _cacheStore = const _OrderCacheStore();

  final _OrderCacheStore _cacheStore;

  @override
  Future<List<Order>> getOrdersForUser(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    final orders = await _cacheStore.readOrdersForUser(userId);
    return List<Order>.unmodifiable(orders);
  }

  @override
  Future<void> placeOrder(Order order) async {
    await Future<void>.delayed(const Duration(milliseconds: 260));
    await _cacheStore.upsertOrder(order);
  }
}

class FirebaseOrderRepository implements OrderRepository {
  FirebaseOrderRepository({
    FirebaseFirestore? firestore,
  })  : _ordersCollection =
            (firestore ?? FirebaseFirestore.instance).collection('orders'),
        _cacheStore = const _OrderCacheStore();

  final CollectionReference<Map<String, dynamic>> _ordersCollection;
  final _OrderCacheStore _cacheStore;

  @override
  Future<List<Order>> getOrdersForUser(String userId) async {
    try {
      final snapshot =
          await _ordersCollection.where('userId', isEqualTo: userId).get();
      final orders = snapshot.docs
          .map((document) => Order.fromMap(document.data()))
          .toList(growable: false)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      await _cacheStore.replaceOrdersForUser(userId, orders);
      return orders;
    } catch (_) {
      final cachedOrders = await _cacheStore.readOrdersForUser(userId);
      if (cachedOrders.isNotEmpty) {
        return cachedOrders;
      }
      rethrow;
    }
  }

  @override
  Future<void> placeOrder(Order order) async {
    await _ordersCollection.doc(order.id).set(order.toMap());
    await _cacheStore.upsertOrder(order);
  }
}

class _OrderCacheStore {
  const _OrderCacheStore();

  static const String _cacheKey = 'coffee_app_order_history_cache_v1';

  Future<List<Order>> readOrdersForUser(String userId) async {
    final allOrders = await _readAllOrders();
    final userOrders = allOrders
        .where((order) => order.userId == userId)
        .toList(growable: false)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return userOrders;
  }

  Future<void> replaceOrdersForUser(String userId, List<Order> orders) async {
    final allOrders = await _readAllOrders();
    final mergedOrders = allOrders
        .where((order) => order.userId != userId)
        .toList(growable: true)
      ..addAll(orders);
    await _writeAllOrders(mergedOrders);
  }

  Future<void> upsertOrder(Order order) async {
    final allOrders = await _readAllOrders();
    allOrders.removeWhere((existingOrder) => existingOrder.id == order.id);
    allOrders.add(order);
    await _writeAllOrders(allOrders);
  }

  Future<List<Order>> _readAllOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final rawOrders = prefs.getString(_cacheKey);
    if (rawOrders == null || rawOrders.isEmpty) {
      return <Order>[];
    }

    final decoded = jsonDecode(rawOrders);
    if (decoded is! List<dynamic>) {
      return <Order>[];
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(Order.fromCacheMap)
        .toList(growable: true)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> _writeAllOrders(List<Order> orders) async {
    final prefs = await SharedPreferences.getInstance();
    final orderedList = orders.toList(growable: false)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    await prefs.setString(
      _cacheKey,
      jsonEncode(
        orderedList.map((order) => order.toCacheMap()).toList(growable: false),
      ),
    );
  }
}
