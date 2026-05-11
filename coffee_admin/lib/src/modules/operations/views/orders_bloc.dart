import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'order.dart';
import 'order_repo.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrderRepo _orderRepo;
  late final Timer _refreshTimer;

  OrdersBloc(this._orderRepo) : super(OrdersLoading()) {
    on<GetOrders>((event, emit) async {
      if (event.showLoader || state is! OrdersSuccess) {
        emit(OrdersLoading());
      }
      try {
        final orders = await _orderRepo.getOrders();
        emit(OrdersSuccess(orders));
      } catch (e) {
        emit(OrdersFailure());
      }
    });

    on<UpdateOrderStatus>((event, emit) async {
      try {
        await _orderRepo.updateOrderStatus(event.orderId, event.status);
        add(const GetOrders(showLoader: false));
      } catch (e) {
        emit(OrdersFailure());
      }
    });

    _refreshTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => add(const GetOrders(showLoader: false)),
    );
  }

  @override
  Future<void> close() {
    _refreshTimer.cancel();
    return super.close();
  }
}
