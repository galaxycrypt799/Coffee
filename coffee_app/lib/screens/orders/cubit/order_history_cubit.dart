import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

import '../../../models/cart.dart';
import '../../../models/cart_item.dart';
import '../../../models/order.dart';
import '../../../repositories/order_repository.dart';

part 'order_history_state.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  OrderHistoryCubit(this._orderRepository) : super(const OrderHistoryState());

  final OrderRepository _orderRepository;

  Future<void> loadOrders(String userId) async {
    if (userId.trim().isEmpty) {
      emit(state.copyWith(orders: const <Order>[], isLoading: false));
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        clearError: true,
        clearSuccess: true,
      ),
    );

    try {
      final orders = await _orderRepository.getOrdersForUser(userId);
      emit(
        state.copyWith(
          isLoading: false,
          orders: orders,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Không thể tải lịch sử đơn hàng.',
        ),
      );
    }
  }

  Future<bool> placeOrder({
    required MyUser user,
    required Cart cart,
    required String customerName,
    required String customerPhone,
    required double totalPrice,
    required String paymentMethod,
    String? deliveryAddress,
    String? notes,
  }) async {
    if (user.userId.trim().isEmpty || cart.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: 'Thiếu thông tin người dùng hoặc giỏ hàng đang trống.',
          clearSuccess: true,
        ),
      );
      return false;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        clearError: true,
        clearSuccess: true,
      ),
    );

    final order = Order(
      id: 'order_${DateTime.now().millisecondsSinceEpoch}',
      userId: user.userId,
      customerName: customerName.trim(),
      customerPhone: customerPhone.trim(),
      customerEmail: user.email.trim().toLowerCase(),
      items: List<CartItem>.from(cart.items),
      totalPrice: totalPrice,
      status: 'pending',
      paymentMethod: paymentMethod,
      createdAt: DateTime.now(),
      deliveryAddress: deliveryAddress,
      notes: notes,
    );

    try {
      await _orderRepository.placeOrder(order);
      final updatedOrders = await _orderRepository.getOrdersForUser(user.userId);

      emit(
        state.copyWith(
          isSubmitting: false,
          orders: updatedOrders,
          successMessage: 'Đơn hàng đã được lưu thành công.',
        ),
      );
      return true;
    } catch (error) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'Không thể tạo đơn hàng. Vui lòng thử lại.',
        ),
      );
      return false;
    }
  }

  void clearFeedback() {
    emit(
      state.copyWith(
        clearError: true,
        clearSuccess: true,
      ),
    );
  }
}
