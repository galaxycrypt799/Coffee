import 'package:coffee_repository/src/entities/macros_entity.dart';

import '../models/models.dart';

class CoffeeEntity {
  const CoffeeEntity({
    required this.sortOrder,
    required this.coffeeId,
    required this.picture,
    required this.name,
    required this.tagline,
    required this.description,
    required this.category,
    required this.origin,
    required this.roastLevel,
    required this.intensity,
    required this.brewMinutes,
    required this.volumeMl,
    required this.rating,
    required this.price,
    required this.discount,
    required this.tastingNotes,
    required this.macros,
  });

  final int sortOrder;
  final String coffeeId;
  final String picture;
  final String name;
  final String tagline;
  final String description;
  final String category;
  final String origin;
  final String roastLevel;
  final int intensity;
  final int brewMinutes;
  final int volumeMl;
  final double rating;
  final double price;
  final int discount;
  final List<String> tastingNotes;
  final Macros macros;

  Map<String, Object?> toDocument() {
    return <String, Object?>{
      'sortOrder': sortOrder,
      'coffeeId': coffeeId,
      'picture': picture,
      'name': name,
      'tagline': tagline,
      'description': description,
      'category': category,
      'origin': origin,
      'roastLevel': roastLevel,
      'caffeineLevel': roastLevel,
      'intensity': intensity,
      'brewMinutes': brewMinutes,
      'volumeMl': volumeMl,
      'rating': rating,
      'price': price,
      'discount': discount,
      'tastingNotes': tastingNotes,
      'macros': macros.toEntity().toDocument(),
    };
  }

  static CoffeeEntity fromDocument(Map<String, dynamic> doc) {
    final rawTastingNotes = doc['tastingNotes'];
    final rawMacros = doc['macros'];

    return CoffeeEntity(
      sortOrder: (doc['sortOrder'] as num?)?.toInt() ?? 0,
      coffeeId: doc['coffeeId'] as String? ?? '',
      picture: doc['picture'] as String? ?? doc['imageUrl'] as String? ?? '',
      name: doc['name'] as String? ?? 'Coffee',
      tagline: doc['tagline'] as String? ?? '',
      description: doc['description'] as String? ?? '',
      category: doc['category'] as String? ?? 'Signature',
      origin: doc['origin'] as String? ?? '',
      roastLevel: doc['roastLevel'] as String? ??
          doc['caffeineLevel'] as String? ??
          'Vừa',
      intensity: (doc['intensity'] as num?)?.toInt() ?? 3,
      brewMinutes: (doc['brewMinutes'] as num?)?.toInt() ?? 4,
      volumeMl: (doc['volumeMl'] as num?)?.toInt() ?? 0,
      rating: (doc['rating'] as num?)?.toDouble() ?? 4.5,
      price: (doc['price'] as num?)?.toDouble() ?? 0,
      discount: (doc['discount'] as num?)?.toInt() ?? 0,
      tastingNotes: rawTastingNotes is List
          ? rawTastingNotes.whereType<String>().toList(growable: false)
          : const <String>[],
      macros: Macros.fromEntity(
        MacrosEntity.fromDocument(
          rawMacros is Map
              ? Map<String, dynamic>.from(rawMacros)
              : <String, dynamic>{},
        ),
      ),
    );
  }
}
