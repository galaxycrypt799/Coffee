part of 'revenue_bloc.dart';

sealed class RevenueState extends Equatable {
  const RevenueState();

  @override
  List<Object> get props => [];
}

final class RevenueInitial extends RevenueState {}

final class RevenueLoading extends RevenueState {}

final class RevenueFailure extends RevenueState {}

final class TopSellingItem extends Equatable {
  const TopSellingItem({
    required this.name,
    required this.quantity,
    required this.revenue,
  });

  final String name;
  final int quantity;
  final int revenue;

  @override
  List<Object> get props => [name, quantity, revenue];
}

final class RevenueSuccess extends RevenueState {
  const RevenueSuccess({
    required this.today,
    required this.month,
    required this.year,
    required this.completedOrders,
    required this.totalOrders,
    required this.weeklyRevenue,
    required this.monthlyRevenue,
    required this.topItems,
    required this.statusCounts,
  });

  final int today;
  final int month;
  final int year;
  final int completedOrders;
  final int totalOrders;
  final List<int> weeklyRevenue;
  final List<int> monthlyRevenue;
  final List<TopSellingItem> topItems;
  final Map<String, int> statusCounts;

  @override
  List<Object> get props => [
        today,
        month,
        year,
        completedOrders,
        totalOrders,
        weeklyRevenue,
        monthlyRevenue,
        topItems,
        statusCounts,
      ];
}
