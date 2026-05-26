import 'dart:async';

import 'package:user_repository/user_repository.dart';

class LocalUserRepo implements UserRepository {
  LocalUserRepo();

  final StreamController<MyUser?> _userController =
      StreamController<MyUser?>.broadcast();
  final Map<String, _StoredUser> _users = <String, _StoredUser>{
    'admin@roastritual.app': _StoredUser(
      user: MyUser(
        userId: 'local-admin',
        email: 'admin@roastritual.app',
        name: 'Coffee Admin',
        hasActiveCart: false,
      ),
      password: 'Admin@123',
    ),
    'guest@roastritual.app': _StoredUser(
      user: MyUser(
        userId: 'local-guest',
        email: 'guest@roastritual.app',
        name: 'Coffee Guest',
        hasActiveCart: false,
        membershipRank: 'silver',
        totalSpent: 1250000,
      ),
      password: 'Coffee@123',
    ),
  };
  final Set<String> _adminUserIds = <String>{'local-admin'};

  MyUser _currentUser = MyUser.empty;

  @override
  Stream<MyUser?> get user async* {
    yield _currentUser; // Phát ra trạng thái hiện tại ngay lập tức
    yield* _userController.stream;
  }

  @override
  Future<void> signIn(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final normalizedEmail = email.trim().toLowerCase();
    final account = _users[normalizedEmail];

    if (account == null || account.password != password) {
      throw StateError('Invalid email or password');
    }
    if (!_adminUserIds.contains(account.user.userId)) {
      throw StateError('Tài khoản này chưa có quyền admin.');
    }

    _currentUser = account.user;
    _userController.add(_currentUser);
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final normalizedEmail = myUser.email.trim().toLowerCase();

    if (_users.containsKey(normalizedEmail)) {
      throw StateError('Email already exists');
    }

    final createdUser = MyUser(
      userId: 'local-${DateTime.now().microsecondsSinceEpoch}',
      email: normalizedEmail,
      name: myUser.name.trim(),
      hasActiveCart: myUser.hasActiveCart,
    );

    _users[normalizedEmail] = _StoredUser(
      user: createdUser,
      password: password,
    );
    _currentUser = createdUser;
    _userController.add(_currentUser);
    return createdUser;
  }

  @override
  Future<void> logOut() async {
    _currentUser = MyUser.empty;
    _userController.add(_currentUser);
  }

  @override
  Future<void> setUserData(MyUser myUser) async {
    final normalizedEmail = myUser.email.trim().toLowerCase();
    final current = _users[normalizedEmail];
    if (current == null) {
      return;
    }

    _users[normalizedEmail] = _StoredUser(
      user: myUser,
      password: current.password,
    );
    _currentUser = myUser;
    _userController.add(_currentUser);
  }

  @override
  Future<void> updateUserData(MyUser myUser) async {
    final entry = _users.entries.firstWhere(
      (item) => item.value.user.userId == myUser.userId,
      orElse: () => throw StateError('User not found'),
    );
    _users[entry.key] = _StoredUser(
      user: myUser,
      password: entry.value.password,
    );
    if (_currentUser.userId == myUser.userId) {
      _currentUser = myUser;
      _userController.add(_currentUser);
    }
  }

  @override
  Future<List<MyUser>> getAllUsers() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _users.values.map((stored) => stored.user).toList();
  }

  @override
  Future<Set<String>> getAdminUserIds() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return Set<String>.from(_adminUserIds);
  }

  @override
  Future<bool> isCurrentUserAdmin() async {
    return _adminUserIds.contains(_currentUser.userId);
  }

  @override
  Future<void> setAdminRole(String userId, bool isAdmin) async {
    if (_currentUser.userId == userId && !isAdmin) {
      throw StateError('Không thể tự gỡ quyền admin của chính mình.');
    }
    if (isAdmin) {
      _adminUserIds.add(userId);
    } else {
      _adminUserIds.remove(userId);
    }
  }
}

class _StoredUser {
  const _StoredUser({
    required this.user,
    required this.password,
  });

  final MyUser user;
  final String password;
}
