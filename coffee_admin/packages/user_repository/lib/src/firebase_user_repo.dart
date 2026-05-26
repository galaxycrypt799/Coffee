import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/user_repository.dart';

class FirebaseUserRepo implements UserRepository {
  FirebaseUserRepo({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _usersCollection =
            (firestore ?? FirebaseFirestore.instance).collection('users'),
        _adminsCollection =
            (firestore ?? FirebaseFirestore.instance).collection('admins');

  final FirebaseAuth _firebaseAuth;
  final CollectionReference<Map<String, dynamic>> _usersCollection;
  final CollectionReference<Map<String, dynamic>> _adminsCollection;

  @override
  Stream<MyUser?> get user {
    return _firebaseAuth.authStateChanges().asyncExpand((firebaseUser) async* {
      if (firebaseUser == null) {
        yield MyUser.empty;
        return;
      }

      final hasAdminAccess = await _isAdminUid(firebaseUser.uid);
      if (!hasAdminAccess) {
        await _firebaseAuth.signOut();
        yield MyUser.empty;
        return;
      }

      final fallbackUser = MyUser(
        userId: firebaseUser.uid,
        email: firebaseUser.email?.trim().toLowerCase() ?? '',
        name: firebaseUser.displayName?.trim().isNotEmpty == true
            ? firebaseUser.displayName!.trim()
            : 'Coffee Admin',
        hasActiveCart: false,
      );

      yield fallbackUser;

      try {
        final snapshot = await _usersCollection.doc(firebaseUser.uid).get();
        final data = snapshot.data();

        if (data == null) {
          await setUserData(fallbackUser);
          return;
        }

        yield MyUser.fromEntity(MyUserEntity.fromDocument(data));
      } catch (error, stackTrace) {
        log(
          'Loading Firebase admin profile failed, using fallback user.',
          error: error,
          stackTrace: stackTrace,
        );
      }
    });
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final uid = credential.user?.uid;
      if (uid == null || !await _isAdminUid(uid)) {
        await _firebaseAuth.signOut();
        throw StateError(
          'Tài khoản đã đăng nhập Firebase Auth nhưng UID chưa có trong collection admins.',
        );
      }
    } catch (error, stackTrace) {
      log('Firebase sign-in failed', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: myUser.email.trim(),
        password: password,
      );

      final createdUser = MyUser(
        userId: credential.user!.uid,
        email: myUser.email.trim().toLowerCase(),
        name: myUser.name.trim(),
        hasActiveCart: myUser.hasActiveCart,
      );

      await credential.user!.updateDisplayName(createdUser.name);
      return createdUser;
    } catch (error, stackTrace) {
      log('Firebase sign-up failed', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> setUserData(MyUser myUser) async {
    try {
      await _usersCollection
          .doc(myUser.userId)
          .set(myUser.toEntity().toDocument(), SetOptions(merge: true));
    } catch (error, stackTrace) {
      log('Saving Firebase user data failed',
          error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> updateUserData(MyUser myUser) async {
    try {
      await _usersCollection.doc(myUser.userId).update({
        'name': myUser.name.trim(),
        'hasActiveCart': myUser.hasActiveCart,
        'membershipRank': myUser.membershipRank,
        'totalSpent': myUser.totalSpent,
      });
    } catch (error, stackTrace) {
      log('Updating Firebase user data failed',
          error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<List<MyUser>> getAllUsers() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw StateError('User not authenticated');
      }

      final snapshot = await _usersCollection.get();
      return snapshot.docs
          .map(
              (doc) => MyUser.fromEntity(MyUserEntity.fromDocument(doc.data())))
          .toList();
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        log(
            'Permission denied reading users collection. '
            'Update Firestore rules to allow admin access.',
            error: e);
      }
      rethrow;
    } catch (error, stackTrace) {
      log('Fetching all users failed', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<Set<String>> getAdminUserIds() async {
    final snapshot = await _adminsCollection.get();
    return snapshot.docs.map((doc) => doc.id).toSet();
  }

  @override
  Future<bool> isCurrentUserAdmin() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return false;
    }
    return _isAdminUid(user.uid);
  }

  @override
  Future<void> setAdminRole(String userId, bool isAdmin) async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      throw StateError('User not authenticated');
    }
    if (currentUser.uid == userId && !isAdmin) {
      throw StateError('Không thể tự gỡ quyền admin của chính mình.');
    }

    final adminDoc = _adminsCollection.doc(userId);
    if (isAdmin) {
      final userDoc = await _usersCollection.doc(userId).get();
      await adminDoc.set({
        'userId': userId,
        'email': userDoc.data()?['email'] as String? ?? '',
        'role': 'admin',
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': currentUser.uid,
      }, SetOptions(merge: true));
    } else {
      await adminDoc.delete();
    }
  }

  Future<bool> _isAdminUid(String uid) async {
    try {
      final doc = await _adminsCollection.doc(uid).get();
      return doc.exists;
    } on FirebaseException catch (error, stackTrace) {
      log('Checking admin access failed', error: error, stackTrace: stackTrace);
      if (error.code == 'permission-denied') {
        throw StateError(
          'Không đọc được admins/$uid. Hãy deploy Firestore rules và kiểm tra document admins có ID đúng bằng Firebase Auth UID.',
        );
      }
      rethrow;
    } catch (error, stackTrace) {
      log('Checking admin access failed', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
