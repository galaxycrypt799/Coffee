class MyUserEntity {
  String userId;
  String email;
  String name;
  bool hasActiveCart;
  String membershipRank; // bronze, silver, gold, platinum
  double totalSpent;

  MyUserEntity({
    required this.userId,
    required this.email,
    required this.name,
    required this.hasActiveCart,
    this.membershipRank = 'bronze',
    this.totalSpent = 0.0,
  });

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'hasActiveCart': hasActiveCart,
      'membershipRank': membershipRank,
      'totalSpent': totalSpent,
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
      userId: doc['userId'] as String? ?? '',
      email: doc['email'] as String? ?? '',
      name: doc['name'] as String? ?? '',
      hasActiveCart: doc['hasActiveCart'] as bool? ?? false,
      membershipRank: doc['membershipRank'] as String? ?? 'bronze',
      totalSpent: (doc['totalSpent'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
