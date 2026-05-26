part of 'users_list_bloc.dart';

sealed class UsersListEvent extends Equatable {
  const UsersListEvent();

  @override
  List<Object> get props => [];
}

class FetchUsersRequested extends UsersListEvent {
  const FetchUsersRequested();
}

class UpdateUserRequested extends UsersListEvent {
  const UpdateUserRequested(this.user);

  final MyUser user;

  @override
  List<Object> get props => [user.userId, user.name, user.membershipRank];
}

class SetUserAdminRoleRequested extends UsersListEvent {
  const SetUserAdminRoleRequested({
    required this.userId,
    required this.isAdmin,
  });

  final String userId;
  final bool isAdmin;

  @override
  List<Object> get props => [userId, isAdmin];
}
