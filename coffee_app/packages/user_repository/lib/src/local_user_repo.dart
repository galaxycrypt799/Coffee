import 'dart:async';

import 'package:user_repository/user_repository.dart';

class LocalUserRepo implements UserRepository {
  LocalUserRepo();

  final StreamController<MyUser?> _userController =
      StreamController<MyUser?>.broadcast();
  final Map<String, _StoredUser> _users = <String, _StoredUser>{
    'guest@roastritual.app': _StoredUser(
      user: MyUser(
        userId: 'local-guest',
        email: 'guest@roastritual.app',
        name: 'Coffee Guest',
        hasActiveCart: true,
      ),
      password: 'Coffee@123',
    ),
  };

  MyUser _currentUser = MyUser.empty;

  @override
  Stream<MyUser?> get user async* {
    yield _currentUser;
    yield* _userController.stream;
  }

  @override
  Future<void> signIn(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final normalizedEmail = email.trim().toLowerCase();
    final account = _users[normalizedEmail];

    if (account == null || account.password != password) {
      throw StateError('Invalid email or password');
    }

    _currentUser = account.user;
    _userController.add(_currentUser);
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 550));
    final normalizedEmail = myUser.email.trim().toLowerCase();

    if (_users.containsKey(normalizedEmail)) {
      throw StateError('Email already exists');
    }

    final createdUser = MyUser(
      userId: 'local-${DateTime.now().microsecondsSinceEpoch}',
      email: normalizedEmail,
      name: myUser.name.trim(),
      hasActiveCart: false,
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
    await Future<void>.delayed(const Duration(milliseconds: 150));
    _currentUser = MyUser.empty;
    _userController.add(_currentUser);
  }

  @override
  Future<void> setUserData(MyUser myUser) async {
    final normalizedEmail = myUser.email.trim().toLowerCase();
    final account = _users[normalizedEmail];

    if (account == null) {
      return;
    }

    _users[normalizedEmail] = _StoredUser(
      user: myUser,
      password: account.password,
    );

    if (_currentUser.userId == myUser.userId) {
      _currentUser = myUser;
      _userController.add(_currentUser);
    }
  }

  @override
  Future<void> updateUserSpent(String userId, double amount) async {
    final entry = _users.entries.firstWhere(
      (e) => e.value.user.userId == userId,
      orElse: () => throw StateError('User not found'),
    );

    final updatedUser = MyUser(
      userId: entry.value.user.userId,
      email: entry.value.user.email,
      name: entry.value.user.name,
      hasActiveCart: entry.value.user.hasActiveCart,
      totalSpent: entry.value.user.totalSpent + amount,
    );

    // Update rank
    if (updatedUser.totalSpent >= 10000000) {
      updatedUser.membershipRank = 'platinum';
    } else if (updatedUser.totalSpent >= 3000000) {
      updatedUser.membershipRank = 'gold';
    } else if (updatedUser.totalSpent >= 1000000) {
      updatedUser.membershipRank = 'silver';
    } else {
      updatedUser.membershipRank = 'bronze';
    }

    _users[entry.key] = _StoredUser(
      user: updatedUser,
      password: entry.value.password,
    );

    if (_currentUser.userId == userId) {
      _currentUser = updatedUser;
      _userController.add(_currentUser);
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
