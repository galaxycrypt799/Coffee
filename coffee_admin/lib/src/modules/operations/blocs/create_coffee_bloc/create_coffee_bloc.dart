import 'package:bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:equatable/equatable.dart';

part 'create_coffee_event.dart';
part 'create_coffee_state.dart';

class CreateCoffeeBloc extends Bloc<CreateCoffeeEvent, CreateCoffeeState> {
  CreateCoffeeBloc(this._coffeeRepo) : super(CreateCoffeeInitial()) {
    on<CreateCoffeeRequested>((event, emit) async {
      emit(CreateCoffeeLoading());
      try {
        await _coffeeRepo.createCoffee(event.coffee);
        emit(const CreateCoffeeSuccess('Đã thêm món vào menu'));
      } catch (error) {
        emit(CreateCoffeeFailure(error.toString()));
      }
    });

    on<UpdateCoffeeRequested>((event, emit) async {
      emit(CreateCoffeeLoading());
      try {
        await _coffeeRepo.updateCoffee(event.coffee);
        emit(const CreateCoffeeSuccess('Đã cập nhật món'));
      } catch (error) {
        emit(CreateCoffeeFailure(error.toString()));
      }
    });

    on<DeleteCoffeeRequested>((event, emit) async {
      emit(CreateCoffeeLoading());
      try {
        await _coffeeRepo.deleteCoffee(event.coffeeId);
        emit(const CreateCoffeeSuccess('Đã xoá món khỏi menu'));
      } catch (error) {
        emit(CreateCoffeeFailure(error.toString()));
      }
    });
  }

  final CoffeeRepo _coffeeRepo;
}
