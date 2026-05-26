part of 'get_coffee_bloc.dart';

sealed class GetCoffeeEvent extends Equatable {
  const GetCoffeeEvent();
  @override List<Object> get props => [];
}

class GetCoffeeRequested extends GetCoffeeEvent {}