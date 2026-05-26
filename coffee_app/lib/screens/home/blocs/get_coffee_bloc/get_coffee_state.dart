part of 'get_coffee_bloc.dart';

sealed class GetCoffeeState extends Equatable {
  const GetCoffeeState();
  @override
  List<Object> get props => [];
}

final class GetCoffeeInitial extends GetCoffeeState {}

final class GetCoffeeLoading extends GetCoffeeState {}

final class GetCoffeeFailure extends GetCoffeeState {}

final class GetCoffeeSuccess extends GetCoffeeState {
  final List<Coffee> coffees;
  const GetCoffeeSuccess(this.coffees);
  @override
  List<Object> get props => [coffees];
}
