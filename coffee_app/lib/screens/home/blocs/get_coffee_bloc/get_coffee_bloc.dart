import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:coffee_repository/coffee_repository.dart';

part 'get_coffee_event.dart';
part 'get_coffee_state.dart';

class GetCoffeeBloc extends Bloc<GetCoffeeEvent, GetCoffeeState> {
  final CoffeeRepo _coffeeRepo;

  GetCoffeeBloc(this._coffeeRepo) : super(GetCoffeeInitial()) {
    on<GetCoffeeRequested>((event, emit) async {
      emit(GetCoffeeLoading());
      try {
        List<Coffee> coffees = await _coffeeRepo.getCoffees();
        emit(GetCoffeeSuccess(coffees));
      } catch (e) {
        emit(GetCoffeeFailure());
      }
    });
  }
}