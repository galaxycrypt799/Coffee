import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:coffee_repository/coffee_repository.dart';

part 'get_coffee_event.dart';
part 'get_coffee_state.dart';

class GetCoffeeBloc extends Bloc<GetCoffeeEvent, GetCoffeeState> {
  final CoffeeRepo _coffeeRepo;
  static const Duration _stateTtl = Duration(minutes: 5);

  DateTime? _lastLoadedAt;
  Future<List<Coffee>>? _activeRequest;

  GetCoffeeBloc(this._coffeeRepo) : super(GetCoffeeInitial()) {
    on<GetCoffeeRequested>((event, emit) async {
      final currentState = state;
      final lastLoadedAt = _lastLoadedAt;
      final hasFreshState = currentState is GetCoffeeSuccess &&
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

      if (currentState is! GetCoffeeSuccess) {
        emit(GetCoffeeLoading());
      }

      final request = _coffeeRepo.getCoffees(forceRefresh: event.forceRefresh);
      _activeRequest = request;

      try {
        final coffees = await request;
        _lastLoadedAt = DateTime.now();
        emit(GetCoffeeSuccess(coffees));
      } catch (e) {
        if (currentState is! GetCoffeeSuccess) {
          emit(GetCoffeeFailure());
        }
      } finally {
        if (identical(_activeRequest, request)) {
          _activeRequest = null;
        }
      }
    });
  }
}
