part of 'get_coffee_bloc.dart';

sealed class GetCoffeeEvent extends Equatable {
  const GetCoffeeEvent();
  @override
  List<Object> get props => [];
}

class GetCoffeeRequested extends GetCoffeeEvent {
  const GetCoffeeRequested({this.forceRefresh = false});

  final bool forceRefresh;

  @override
  List<Object> get props => [forceRefresh];
}
