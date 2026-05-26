import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

import 'order.dart';
import 'order_repo.dart';

class FirebaseOrderRepo implements OrderRepo {
  FirebaseOrderRepo({
    firestore.FirebaseFirestore? firestoreInstance,
  }) : orderCollection =
            (firestoreInstance ?? firestore.FirebaseFirestore.instance)
                .collection('orders');

  final firestore.CollectionReference<Map<String, dynamic>> orderCollection;
  static const Duration _ordersCacheTtl = Duration(seconds: 15);
  static const Duration _revenueCacheTtl = Duration(seconds: 45);
  static const int _ordersLimit = 120;
  static const int _userOrdersLimit = 50;

  List<Order>? _cachedOrders;
  DateTime? _ordersFetchedAt;
  Future<List<Order>>? _activeOrdersFetch;

  final Map<String, List<Order>> _cachedOrdersByUser = <String, List<Order>>{};
  final Map<String, DateTime> _userOrdersFetchedAt = <String, DateTime>{};
  final Map<String, Future<List<Order>>> _activeUserOrdersFetch =
      <String, Future<List<Order>>>{};

  Map<String, dynamic>? _cachedRevenueStats;
  DateTime? _revenueFetchedAt;
  Future<Map<String, dynamic>>? _activeRevenueFetch;

  @override
  Future<void> createOrder(Order order) async {
    try {
      final docRef = orderCollection.doc();
      await docRef.set(order.copyWith(id: docRef.id).toDocument());
      _invalidateCaches();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Order>> getMyOrders(
    String userId, {
    bool forceRefresh = false,
  }) async {
    final trimmedUserId = userId.trim();
    if (trimmedUserId.isEmpty) {
      return const <Order>[];
    }

    final cachedOrders = _cachedOrdersByUser[trimmedUserId];
    final fetchedAt = _userOrdersFetchedAt[trimmedUserId];
    final isCacheFresh = cachedOrders != null &&
        fetchedAt != null &&
        DateTime.now().difference(fetchedAt) < _ordersCacheTtl;

    if (!forceRefresh && isCacheFresh) {
      return cachedOrders;
    }

    final activeFetch = _activeUserOrdersFetch[trimmedUserId];
    if (!forceRefresh && activeFetch != null) {
      return activeFetch;
    }

    final fetch = _fetchMyOrders(trimmedUserId);
    _activeUserOrdersFetch[trimmedUserId] = fetch;

    try {
      final orders = await fetch;
      final immutableOrders = List<Order>.unmodifiable(orders);
      _cachedOrdersByUser[trimmedUserId] = immutableOrders;
      _userOrdersFetchedAt[trimmedUserId] = DateTime.now();
      return immutableOrders;
    } finally {
      if (identical(_activeUserOrdersFetch[trimmedUserId], fetch)) {
        _activeUserOrdersFetch.remove(trimmedUserId);
      }
    }
  }

  Future<List<Order>> _fetchMyOrders(String userId) async {
    try {
      final snapshot = await orderCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(_userOrdersLimit)
          .get();
      final orders = snapshot.docs
          .map((doc) => Order.fromDocument(doc.data()))
          .toList(growable: false);
      return orders;
    } catch (e) {
      return _fetchMyOrdersWithoutServerSort(userId);
    }
  }

  Future<List<Order>> _fetchMyOrdersWithoutServerSort(String userId) async {
    try {
      final snapshot =
          await orderCollection.where('userId', isEqualTo: userId).get();
      final orders = snapshot.docs
          .map((doc) => Order.fromDocument(doc.data()))
          .toList(growable: false)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return orders.take(_userOrdersLimit).toList(growable: false);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Order>> getOrders({bool forceRefresh = false}) async {
    final cachedOrders = _cachedOrders;
    final fetchedAt = _ordersFetchedAt;
    final isCacheFresh = cachedOrders != null &&
        fetchedAt != null &&
        DateTime.now().difference(fetchedAt) < _ordersCacheTtl;

    if (!forceRefresh && isCacheFresh) {
      return cachedOrders;
    }

    final activeFetch = _activeOrdersFetch;
    if (!forceRefresh && activeFetch != null) {
      return activeFetch;
    }

    final fetch = _fetchOrders();
    _activeOrdersFetch = fetch;

    try {
      final orders = await fetch;
      final immutableOrders = List<Order>.unmodifiable(orders);
      _cachedOrders = immutableOrders;
      _ordersFetchedAt = DateTime.now();
      return immutableOrders;
    } finally {
      if (identical(_activeOrdersFetch, fetch)) {
        _activeOrdersFetch = null;
      }
    }
  }

  Future<List<Order>> _fetchOrders() async {
    try {
      final snapshot = await orderCollection
          .orderBy('createdAt', descending: true)
          .limit(_ordersLimit)
          .get();
      final orders = snapshot.docs
          .map((doc) => Order.fromDocument(doc.data()))
          .toList(growable: false);
      return orders;
    } catch (e) {
      return _fetchOrdersWithoutServerSort();
    }
  }

  Future<List<Order>> _fetchOrdersWithoutServerSort() async {
    try {
      final snapshot = await orderCollection.get();
      final orders = snapshot.docs
          .map((doc) => Order.fromDocument(doc.data()))
          .toList(growable: false)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return orders.take(_ordersLimit).toList(growable: false);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await orderCollection.doc(orderId).update({'status': status});
      _invalidateCaches();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getRevenueStats({
    bool forceRefresh = false,
  }) async {
    final cachedStats = _cachedRevenueStats;
    final fetchedAt = _revenueFetchedAt;
    final isCacheFresh = cachedStats != null &&
        fetchedAt != null &&
        DateTime.now().difference(fetchedAt) < _revenueCacheTtl;

    if (!forceRefresh && isCacheFresh) {
      return cachedStats;
    }

    final activeFetch = _activeRevenueFetch;
    if (!forceRefresh && activeFetch != null) {
      return activeFetch;
    }

    final fetch = _fetchRevenueStats();
    _activeRevenueFetch = fetch;

    try {
      final stats = await fetch;
      _cachedRevenueStats = stats;
      _revenueFetchedAt = DateTime.now();
      return stats;
    } finally {
      if (identical(_activeRevenueFetch, fetch)) {
        _activeRevenueFetch = null;
      }
    }
  }

  Future<Map<String, dynamic>> _fetchRevenueStats() async {
    try {
      final snapshot = await orderCollection.get();
      int today = 0;
      int month = 0;
      int year = 0;
      final weekly = List<int>.filled(7, 0);
      final monthly = List<int>.filled(12, 0);
      final statusCounts = <String, int>{};
      final itemSales = <String, _ItemSalesAccumulator>{};

      final now = DateTime.now();
      final startOfToday = DateTime(now.year, now.month, now.day);
      final startOfThisMonth = DateTime(now.year, now.month, 1);
      final startOfThisYear = DateTime(now.year, 1, 1);
      const revenueStatuses = <String>{'delivered', 'completed'};
      var completedOrders = 0;

      for (var doc in snapshot.docs) {
        final order = Order.fromDocument(doc.data());
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

        int dayDifference = startOfToday.difference(orderDate).inDays;
        if (dayDifference >= 0 && dayDifference < 7) {
          weekly[6 - dayDifference] += orderTotal;
        }

        for (final item in order.items) {
          final key = item.coffeeId.isNotEmpty ? item.coffeeId : item.name;
          itemSales
              .putIfAbsent(
                key,
                () => _ItemSalesAccumulator(name: item.name),
              )
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
        'totalOrders': snapshot.docs.length,
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
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  void _invalidateCaches() {
    _cachedOrders = null;
    _ordersFetchedAt = null;
    _cachedOrdersByUser.clear();
    _userOrdersFetchedAt.clear();
    _cachedRevenueStats = null;
    _revenueFetchedAt = null;
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
