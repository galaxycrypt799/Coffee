part of 'users_list_bloc.dart';

sealed class UsersListState extends Equatable {
  const UsersListState();

  @override
  List<Object> get props => [];
}

class UsersListInitial extends UsersListState {
  const UsersListInitial();
}

class UsersListLoading extends UsersListState {
  const UsersListLoading();
}

class UsersListSuccess extends UsersListState {
  final List<MyUser> users;
  final Map<String, List<Order>> userOrders;
  final Set<String> adminUserIds;

  const UsersListSuccess({
    required this.users,
    required this.userOrders,
    required this.adminUserIds,
  });

  @override
  List<Object> get props => [users, userOrders, adminUserIds];
}

class UsersListFailure extends UsersListState {
  final String error;

  const UsersListFailure(this.error);

  @override
  List<Object> get props => [error];
}
