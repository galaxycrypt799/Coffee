import 'dart:developer';

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
  static const Duration _stateTtl = Duration(seconds: 45);

  String? _loadedUserId;
  String? _requestedUserId;
  DateTime? _lastLoadedAt;
  Future<void>? _activeLoad;
  String? _activeLoadUserId;

  Future<void> loadOrders(
    String userId, {
    bool forceRefresh = false,
  }) async {
    final trimmedUserId = userId.trim();

    if (trimmedUserId.isEmpty) {
      _loadedUserId = null;
      _requestedUserId = null;
      _lastLoadedAt = null;
      emit(state.copyWith(orders: const <Order>[], isLoading: false));
      return;
    }

    final lastLoadedAt = _lastLoadedAt;
    final hasFreshState = _loadedUserId == trimmedUserId &&
        lastLoadedAt != null &&
        DateTime.now().difference(lastLoadedAt) < _stateTtl;

    if (!forceRefresh && hasFreshState) {
      return;
    }

    final activeLoad = _activeLoad;
    if (!forceRefresh &&
        activeLoad != null &&
        _activeLoadUserId == trimmedUserId) {
      await activeLoad;
      return;
    }

    final shouldShowFullLoader =
        state.orders.isEmpty || _loadedUserId != trimmedUserId;

    if (shouldShowFullLoader || state.errorMessage != null) {
      emit(
        state.copyWith(
          isLoading: shouldShowFullLoader,
          clearError: true,
          clearSuccess: true,
        ),
      );
    }

    final load = _loadOrders(trimmedUserId, forceRefresh: forceRefresh);
    _requestedUserId = trimmedUserId;
    _activeLoad = load;
    _activeLoadUserId = trimmedUserId;

    try {
      await load;
    } finally {
      if (identical(_activeLoad, load)) {
        _activeLoad = null;
        _activeLoadUserId = null;
      }
    }
  }

  Future<void> _loadOrders(
    String userId, {
    required bool forceRefresh,
  }) async {
    try {
      final orders = await _orderRepository.getOrdersForUser(
        userId,
        forceRefresh: forceRefresh,
      );
      if (_requestedUserId != userId) {
        return;
      }
      _loadedUserId = userId;
      _lastLoadedAt = DateTime.now();
      emit(
        state.copyWith(
          isLoading: false,
          orders: orders,
        ),
      );
    } catch (error) {
      if (_requestedUserId != userId) {
        return;
      }
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
    required UserRepository userRepository,
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
    } catch (error) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'Không thể tạo đơn hàng. Vui lòng thử lại.',
        ),
      );
      return false;
    }

    try {
      await userRepository.updateUserSpent(user.userId, totalPrice);
    } catch (error, stackTrace) {
      log(
        'Updating loyalty spend failed after order placement.',
        error: error,
        stackTrace: stackTrace,
      );
    }

    final updatedOrders = <Order>[
      order,
      ...state.orders.where((item) => item.id != order.id),
    ];
    _loadedUserId = user.userId;
    _requestedUserId = user.userId;
    _lastLoadedAt = DateTime.now();

    emit(
      state.copyWith(
        isSubmitting: false,
        orders: updatedOrders,
        successMessage: 'Đơn hàng đã được lưu thành công.',
      ),
    );
    return true;
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
