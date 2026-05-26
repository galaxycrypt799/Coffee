import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';
import '../../../operations/views/order_repo.dart';
import '../../../operations/views/order.dart';

part 'users_list_event.dart';
part 'users_list_state.dart';

class UsersListBloc extends Bloc<UsersListEvent, UsersListState> {
  final UserRepository userRepository;
  final OrderRepo orderRepo;

  UsersListBloc({
    required this.userRepository,
    required this.orderRepo,
  }) : super(const UsersListInitial()) {
    on<FetchUsersRequested>(_onFetchUsersRequested);
    on<UpdateUserRequested>(_onUpdateUserRequested);
    on<SetUserAdminRoleRequested>(_onSetUserAdminRoleRequested);
  }

  Future<void> _onFetchUsersRequested(
    FetchUsersRequested event,
    Emitter<UsersListState> emit,
  ) async {
    await _fetchUsers(emit);
  }

  Future<void> _onUpdateUserRequested(
    UpdateUserRequested event,
    Emitter<UsersListState> emit,
  ) async {
    emit(const UsersListLoading());
    try {
      await userRepository.updateUserData(event.user);
      await _fetchUsers(emit, emitLoading: false);
    } catch (e) {
      emit(UsersListFailure(e.toString()));
    }
  }

  Future<void> _onSetUserAdminRoleRequested(
    SetUserAdminRoleRequested event,
    Emitter<UsersListState> emit,
  ) async {
    emit(const UsersListLoading());
    try {
      await userRepository.setAdminRole(event.userId, event.isAdmin);
      await _fetchUsers(emit, emitLoading: false);
    } catch (e) {
      emit(UsersListFailure(e.toString()));
    }
  }

  Future<void> _fetchUsers(
    Emitter<UsersListState> emit, {
    bool emitLoading = true,
  }) async {
    if (emitLoading) {
      emit(const UsersListLoading());
    }

    try {
      final users = await userRepository.getAllUsers();
      users
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      final adminUserIds = await userRepository.getAdminUserIds();

      final userOrderEntries = await Future.wait(
        users.map((user) async {
          try {
            final orders = await orderRepo.getMyOrders(user.userId);
            return MapEntry(user.userId, orders);
          } catch (e) {
            return MapEntry(user.userId, <Order>[]);
          }
        }),
      );
      final userOrders = Map<String, List<Order>>.fromEntries(
        userOrderEntries,
      );

      emit(UsersListSuccess(
        users: users,
        userOrders: userOrders,
        adminUserIds: adminUserIds,
      ));
    } catch (e) {
      emit(UsersListFailure(e.toString()));
    }
  }
}
