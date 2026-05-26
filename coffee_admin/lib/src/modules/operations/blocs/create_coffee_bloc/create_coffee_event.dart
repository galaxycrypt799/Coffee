part of 'create_coffee_bloc.dart';

sealed class CreateCoffeeEvent extends Equatable {
  const CreateCoffeeEvent();

  @override
  List<Object> get props => [];
}

class CreateCoffeeRequested extends CreateCoffeeEvent {
  final Coffee coffee;

  const CreateCoffeeRequested(this.coffee);

  @override
  List<Object> get props => [coffee];
}

class UpdateCoffeeRequested extends CreateCoffeeEvent {
  final Coffee coffee;

  const UpdateCoffeeRequested(this.coffee);

  @override
  List<Object> get props => [coffee];
}

class DeleteCoffeeRequested extends CreateCoffeeEvent {
  final String coffeeId;

  const DeleteCoffeeRequested(this.coffeeId);

  @override
  List<Object> get props => [coffeeId];
}
