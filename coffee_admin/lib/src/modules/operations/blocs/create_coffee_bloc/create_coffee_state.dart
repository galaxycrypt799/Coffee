part of 'create_coffee_bloc.dart';

sealed class CreateCoffeeState extends Equatable {
  const CreateCoffeeState();

  @override
  List<Object> get props => [];
}

final class CreateCoffeeInitial extends CreateCoffeeState {}

final class CreateCoffeeFailure extends CreateCoffeeState {
  const CreateCoffeeFailure([this.message = '']);

  final String message;

  @override
  List<Object> get props => [message];
}

final class CreateCoffeeLoading extends CreateCoffeeState {}

final class CreateCoffeeSuccess extends CreateCoffeeState {
  const CreateCoffeeSuccess([this.message = '']);

  final String message;

  @override
  List<Object> get props => [message];
}
