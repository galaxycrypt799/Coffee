import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user_repository/user_repository.dart';

class FirebaseUserRepo implements UserRepository {
  FirebaseUserRepo({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _usersCollection =
            (firestore ?? FirebaseFirestore.instance).collection('users');

  final FirebaseAuth _firebaseAuth;
  final CollectionReference<Map<String, dynamic>> _usersCollection;

  @override
  Stream<MyUser?> get user {
    return _firebaseAuth.authStateChanges().switchMap((firebaseUser) {
      if (firebaseUser == null) {
        return Stream.value(MyUser.empty);
      }

      return _usersCollection.doc(firebaseUser.uid).snapshots().map((snapshot) {
        final data = snapshot.data();
        if (data == null) {
          // If document doesn't exist, we might want to create it or return a fallback
          return MyUser(
            userId: firebaseUser.uid,
            email: firebaseUser.email?.trim().toLowerCase() ?? '',
            name: firebaseUser.displayName?.trim().isNotEmpty == true
                ? firebaseUser.displayName!.trim()
                : 'Coffee Guest',
            hasActiveCart: false,
          );
        }
        return MyUser.fromEntity(MyUserEntity.fromDocument(data));
      }).handleError((error, stackTrace) {
        log(
          'Error streaming user document',
          error: error,
          stackTrace: stackTrace,
        );
      });
    });
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
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
          .set(myUser.toEntity().toDocument());
    } catch (error, stackTrace) {
      log('Saving Firebase user data failed',
          error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> updateUserSpent(String userId, double amount) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      if (!doc.exists) return;

      final currentSpent = (doc.data()?['totalSpent'] ?? 0).toDouble();
      final newSpent = currentSpent + amount;

      String newRank = 'bronze';
      if (newSpent >= 10000000) {
        newRank = 'platinum';
      } else if (newSpent >= 3000000) {
        newRank = 'gold';
      } else if (newSpent >= 1000000) {
        newRank = 'silver';
      }

      await _usersCollection.doc(userId).update({
        'totalSpent': newSpent,
        'membershipRank': newRank,
      });
    } catch (e) {
      log('Error updating user spent: $e');
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }
}
