import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'order_repo.dart';

part 'revenue_event.dart';
part 'revenue_state.dart';

class RevenueBloc extends Bloc<RevenueEvent, RevenueState> {
  final OrderRepo _orderRepo;
  static const Duration _stateTtl = Duration(seconds: 45);

  DateTime? _lastLoadedAt;
  Future<Map<String, dynamic>>? _activeRequest;

  RevenueBloc(this._orderRepo) : super(RevenueInitial()) {
    on<GetRevenueRequested>((event, emit) async {
      final currentState = state;
      final lastLoadedAt = _lastLoadedAt;
      final hasFreshState = currentState is RevenueSuccess &&
          lastLoadedAt != null &&
          DateTime.now().difference(lastLoadedAt) < _stateTtl;

      if (!event.forceRefresh && hasFreshState) {
        return;
      }

      final activeRequest = _activeRequest;
      if (!event.forceRefresh && activeRequest != null) {
        try {
          await activeRequest;
        } catch (_) {
          // The original request will emit the failure state.
        }
        return;
      }

      if (currentState is! RevenueSuccess) {
        emit(RevenueLoading());
      }

      final request = _orderRepo.getRevenueStats(
        forceRefresh: event.forceRefresh,
      );
      _activeRequest = request;

      try {
        final stats = await request;
        _lastLoadedAt = DateTime.now();
        emit(RevenueSuccess(
          today: _asInt(stats['today']),
          month: _asInt(stats['month']),
          year: _asInt(stats['year']),
          completedOrders: _asInt(stats['count']),
          totalOrders: _asInt(stats['totalOrders']),
          weeklyRevenue: _asIntList(stats['weekly'], fallbackLength: 7),
          monthlyRevenue: _asIntList(stats['monthly'], fallbackLength: 12),
          topItems: _asTopItems(stats['topItems']),
          statusCounts: _asStatusCounts(stats['statusCounts']),
        ));
      } catch (e) {
        if (currentState is! RevenueSuccess) {
          emit(RevenueFailure());
        }
      } finally {
        if (identical(_activeRequest, request)) {
          _activeRequest = null;
        }
      }
    });
  }

  int _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.round();
    return 0;
  }

  List<int> _asIntList(Object? value, {required int fallbackLength}) {
    if (value is List) {
      final parsed = value.map(_asInt).toList(growable: false);
      if (parsed.length >= fallbackLength) {
        return parsed.take(fallbackLength).toList(growable: false);
      }
      return <int>[
        ...parsed,
        ...List<int>.filled(fallbackLength - parsed.length, 0),
      ];
    }

    return List<int>.filled(fallbackLength, 0);
  }

  List<TopSellingItem> _asTopItems(Object? value) {
    if (value is! List) return const <TopSellingItem>[];

    return value
        .whereType<Map>()
        .map(
          (item) => TopSellingItem(
            name: item['name']?.toString() ?? '',
            quantity: _asInt(item['quantity']),
            revenue: _asInt(item['revenue']),
          ),
        )
        .where((item) => item.name.isNotEmpty)
        .toList(growable: false);
  }

  Map<String, int> _asStatusCounts(Object? value) {
    if (value is! Map) return const <String, int>{};

    return value.map(
      (key, rawValue) => MapEntry(key.toString(), _asInt(rawValue)),
    );
  }
}
