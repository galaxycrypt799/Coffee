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
  static const Duration _pollInterval = Duration(seconds: 15);
  static const Duration _silentRefreshFloor = Duration(seconds: 12);

  DateTime? _lastLoadedAt;
  Future<List<Order>>? _activeFetch;

  OrdersBloc(this._orderRepo) : super(OrdersLoading()) {
    on<GetOrders>(_onGetOrders);

    on<UpdateOrderStatus>((event, emit) async {
      try {
        await _orderRepo.updateOrderStatus(event.orderId, event.status);
        add(const GetOrders(showLoader: false, forceRefresh: true));
      } catch (e) {
        emit(OrdersFailure());
      }
    });

    _refreshTimer = Timer.periodic(
      _pollInterval,
      (_) => add(const GetOrders(showLoader: false)),
    );
  }

  Future<void> _onGetOrders(
    GetOrders event,
    Emitter<OrdersState> emit,
  ) async {
    final lastLoadedAt = _lastLoadedAt;
    final isSilentRefreshTooSoon = !event.forceRefresh &&
        !event.showLoader &&
        lastLoadedAt != null &&
        DateTime.now().difference(lastLoadedAt) < _silentRefreshFloor;

    if (isSilentRefreshTooSoon) {
      return;
    }

    final activeFetch = _activeFetch;
    if (!event.forceRefresh && activeFetch != null) {
      try {
        final orders = await activeFetch;
        emit(OrdersSuccess(orders));
      } catch (_) {
        if (state is! OrdersSuccess) {
          emit(OrdersFailure());
        }
      }
      return;
    }

    if (event.showLoader || state is! OrdersSuccess) {
      emit(OrdersLoading());
    }

    final fetch = _orderRepo.getOrders(forceRefresh: event.forceRefresh);
    _activeFetch = fetch;

    try {
      final orders = await fetch;
      _lastLoadedAt = DateTime.now();
      emit(OrdersSuccess(orders));
    } catch (e) {
      if (state is! OrdersSuccess) {
        emit(OrdersFailure());
      }
    } finally {
      if (identical(_activeFetch, fetch)) {
        _activeFetch = null;
      }
    }
  }

  @override
  Future<void> close() {
    _refreshTimer.cancel();
    return super.close();
  }
}
