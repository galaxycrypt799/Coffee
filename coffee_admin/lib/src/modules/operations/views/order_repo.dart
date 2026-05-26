import 'order.dart';

abstract class OrderRepo {
  Future<void> createOrder(Order order);
  Future<List<Order>> getMyOrders(
    String userId, {
    bool forceRefresh = false,
  });
  Future<List<Order>> getOrders({bool forceRefresh = false});
  Future<void> updateOrderStatus(String orderId, String status);
  Future<Map<String, dynamic>> getRevenueStats({bool forceRefresh = false});
}
