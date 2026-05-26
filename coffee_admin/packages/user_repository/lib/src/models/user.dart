import '../entities/entities.dart';

class MyUser {
  String userId;
  String email;
  String name;
  bool hasActiveCart;
  String membershipRank; // bronze, silver, gold, platinum
  double totalSpent;

  MyUser({
    required this.userId,
    required this.email,
    required this.name,
    required this.hasActiveCart,
    this.membershipRank = 'bronze',
    this.totalSpent = 0.0,
  });

  static final empty = MyUser(
    userId: '',
    email: '',
    name: '',
    hasActiveCart: false,
    membershipRank: 'bronze',
    totalSpent: 0.0,
  );

  MyUser copyWith({
    String? userId,
    String? email,
    String? name,
    bool? hasActiveCart,
    String? membershipRank,
    double? totalSpent,
  }) {
    return MyUser(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      hasActiveCart: hasActiveCart ?? this.hasActiveCart,
      membershipRank: membershipRank ?? this.membershipRank,
      totalSpent: totalSpent ?? this.totalSpent,
    );
  }

  MyUserEntity toEntity() {
    return MyUserEntity(
      userId: userId,
      email: email,
      name: name,
      hasActiveCart: hasActiveCart,
      membershipRank: membershipRank,
      totalSpent: totalSpent,
    );
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      userId: entity.userId,
      email: entity.email,
      name: entity.name,
      hasActiveCart: entity.hasActiveCart,
      membershipRank: entity.membershipRank,
      totalSpent: entity.totalSpent,
    );
  }

  @override
  String toString() {
    return 'MyUser: $userId, $email, $name, $hasActiveCart, $membershipRank, $totalSpent';
  }
}
