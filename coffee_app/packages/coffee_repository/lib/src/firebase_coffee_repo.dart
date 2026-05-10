import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_repository/coffee_repository.dart';

class FirebaseCoffeeRepo implements CoffeeRepo {
  FirebaseCoffeeRepo({
    FirebaseFirestore? firestore,
    this.seedIfEmpty = true,
  }) : _coffeeCollection =
            (firestore ?? FirebaseFirestore.instance).collection('coffees');

  final CollectionReference<Map<String, dynamic>> _coffeeCollection;
  final bool seedIfEmpty;

  @override
  Future<List<Coffee>> getCoffees() async {
    try {
      var snapshot = await _coffeeCollection.orderBy('sortOrder').get();

      if (snapshot.docs.isEmpty && seedIfEmpty) {
        await _seedCollection();
        snapshot = await _coffeeCollection.orderBy('sortOrder').get();
      }

      if (snapshot.docs.isEmpty) {
        return LocalCoffeeRepo.bundledMenu;
      }

      return snapshot.docs
          .map(
              (doc) => Coffee.fromEntity(CoffeeEntity.fromDocument(doc.data())))
          .toList(growable: false);
    } catch (error, stackTrace) {
      log(
        'Loading coffees from Firebase failed, returning bundled menu instead.',
        error: error,
        stackTrace: stackTrace,
      );
      return LocalCoffeeRepo.bundledMenu;
    }
  }

  Future<void> _seedCollection() async {
    final batch = _coffeeCollection.firestore.batch();

    for (final coffee in LocalCoffeeRepo.bundledMenu) {
      batch.set(_coffeeCollection.doc(coffee.coffeeId),
          coffee.toEntity().toDocument());
    }

    await batch.commit();
  }
}
