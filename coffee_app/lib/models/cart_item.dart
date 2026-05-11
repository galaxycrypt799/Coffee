class CartItem {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String category;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.category,
    this.quantity = 1,
  });

  double get subtotal => price * quantity;

  CartItem copyWith({
    String? id,
    String? name,
    String? imageUrl,
    double? price,
    String? category,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'price': price,
        'category': category,
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        imageUrl: json['imageUrl'] as String? ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0,
        category: json['category'] as String? ?? '',
        quantity: json['quantity'] as int? ?? 1,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          quantity == other.quantity;

  @override
  int get hashCode => id.hashCode ^ quantity.hashCode;
}
