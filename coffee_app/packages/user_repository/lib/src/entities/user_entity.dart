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
      userId: doc['userId'],
      email: doc['email'],
      name: doc['name'],
      hasActiveCart: doc['hasActiveCart'],
      membershipRank: doc['membershipRank'] ?? 'bronze',
      totalSpent: (doc['totalSpent'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
