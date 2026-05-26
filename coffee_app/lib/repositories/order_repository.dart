import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/order.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrdersForUser(
    String userId, {
    bool forceRefresh = false,
  });
  Future<void> placeOrder(Order order);
}

class LocalOrderRepository implements OrderRepository {
  LocalOrderRepository() : _cacheStore = const _OrderCacheStore();

  final _OrderCacheStore _cacheStore;

  @override
  Future<List<Order>> getOrdersForUser(
    String userId, {
    bool forceRefresh = false,
  }) async {
    final orders = await _cacheStore.readOrdersForUser(userId);
    return List<Order>.unmodifiable(orders);
  }

  @override
  Future<void> placeOrder(Order order) async {
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
  static const Duration _cacheTtl = Duration(seconds: 45);
  static const int _historyLimit = 50;

  final Map<String, List<Order>> _cachedOrdersByUser = <String, List<Order>>{};
  final Map<String, DateTime> _lastFetchByUser = <String, DateTime>{};
  final Map<String, Future<List<Order>>> _activeFetchByUser =
      <String, Future<List<Order>>>{};

  @override
  Future<List<Order>> getOrdersForUser(
    String userId, {
    bool forceRefresh = false,
  }) async {
    final trimmedUserId = userId.trim();
    if (trimmedUserId.isEmpty) {
      return const <Order>[];
    }

    final cachedOrders = _cachedOrdersByUser[trimmedUserId];
    final lastFetchAt = _lastFetchByUser[trimmedUserId];
    final isCacheFresh = cachedOrders != null &&
        lastFetchAt != null &&
        DateTime.now().difference(lastFetchAt) < _cacheTtl;

    if (!forceRefresh && isCacheFresh) {
      return cachedOrders;
    }

    final activeFetch = _activeFetchByUser[trimmedUserId];
    if (!forceRefresh && activeFetch != null) {
      return activeFetch;
    }

    final fetch = _fetchOrdersForUser(trimmedUserId);
    _activeFetchByUser[trimmedUserId] = fetch;

    try {
      final orders = await fetch;
      final immutableOrders = List<Order>.unmodifiable(orders);
      _cachedOrdersByUser[trimmedUserId] = immutableOrders;
      _lastFetchByUser[trimmedUserId] = DateTime.now();
      return immutableOrders;
    } finally {
      if (identical(_activeFetchByUser[trimmedUserId], fetch)) {
        _activeFetchByUser.remove(trimmedUserId);
      }
    }
  }

  Future<List<Order>> _fetchOrdersForUser(String userId) async {
    try {
      final snapshot = await _ordersCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(_historyLimit)
          .get();
      final orders = snapshot.docs
          .map((document) => Order.fromMap(document.data()))
          .toList(growable: false);
      await _cacheStore.replaceOrdersForUser(userId, orders);
      return orders;
    } catch (_) {
      return _fetchOrdersForUserWithoutServerSort(userId);
    }
  }

  Future<List<Order>> _fetchOrdersForUserWithoutServerSort(
      String userId) async {
    try {
      final snapshot =
          await _ordersCollection.where('userId', isEqualTo: userId).get();
      final orders = snapshot.docs
          .map((document) => Order.fromMap(document.data()))
          .toList(growable: false)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      final limitedOrders = orders.take(_historyLimit).toList(growable: false);
      await _cacheStore.replaceOrdersForUser(userId, limitedOrders);
      return limitedOrders;
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

    final cachedOrders = _cachedOrdersByUser[order.userId];
    if (cachedOrders != null) {
      final updatedOrders = <Order>[
        order,
        ...cachedOrders.where((existingOrder) => existingOrder.id != order.id),
      ]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _cachedOrdersByUser[order.userId] =
          List<Order>.unmodifiable(updatedOrders.take(_historyLimit));
      _lastFetchByUser[order.userId] = DateTime.now();
    }
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
