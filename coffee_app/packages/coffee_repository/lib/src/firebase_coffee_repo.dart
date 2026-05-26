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
  static const Duration _cacheTtl = Duration(minutes: 5);

  List<Coffee>? _cachedCoffees;
  DateTime? _lastFetchAt;
  Future<List<Coffee>>? _activeFetch;

  @override
  Future<List<Coffee>> getCoffees({bool forceRefresh = false}) async {
    final cachedCoffees = _cachedCoffees;
    final lastFetchAt = _lastFetchAt;
    final isCacheFresh = cachedCoffees != null &&
        lastFetchAt != null &&
        DateTime.now().difference(lastFetchAt) < _cacheTtl;

    if (!forceRefresh && isCacheFresh) {
      return cachedCoffees;
    }

    final activeFetch = _activeFetch;
    if (!forceRefresh && activeFetch != null) {
      return activeFetch;
    }

    final fetch = _loadCoffees();
    _activeFetch = fetch;

    try {
      final coffees = await fetch;
      _cachedCoffees = List<Coffee>.unmodifiable(coffees);
      _lastFetchAt = DateTime.now();
      return _cachedCoffees!;
    } finally {
      if (identical(_activeFetch, fetch)) {
        _activeFetch = null;
      }
    }
  }

  Future<List<Coffee>> _loadCoffees() async {
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
