part of 'revenue_bloc.dart';

sealed class RevenueEvent extends Equatable {
  const RevenueEvent();

  @override
  List<Object> get props => [];
}

class GetRevenueRequested extends RevenueEvent {
  const GetRevenueRequested({this.forceRefresh = false});

  final bool forceRefresh;

  @override
  List<Object> get props => [forceRefresh];
}
