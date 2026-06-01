import 'cart_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String id;
  final String userId;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final List<CartItem> items;
  final double totalPrice;
  final String
      status; // pending, confirmed, preparing, ready, delivered, cancelled
  final String paymentMethod; // cash, card, online
  final DateTime createdAt;
  final String? deliveryAddress;
  final String? notes;

  Order({
    required this.id,
    required this.userId,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.paymentMethod,
    required this.createdAt,
    this.deliveryAddress,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': id,
      'userId': userId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'items': items
          .map(
            (item) => {
              'id': item.id,
              'coffeeId': item.id,
              'name': item.name,
              'picture': item.imageUrl,
              'imageUrl': item.imageUrl,
              'price': item.price,
              'category': item.category,
              'quantity': item.quantity,
            },
          )
          .toList(growable: false),
      'totalPrice': totalPrice,
      'status': status,
      'paymentMethod': paymentMethod,
      'createdAt': Timestamp.fromDate(createdAt),
      'deliveryAddress': deliveryAddress,
      'notes': notes,
    };
  }

  Map<String, dynamic> toCacheMap() {
    return {
      'id': id,
      'orderId': id,
      'userId': userId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'items': items.map((item) => item.toJson()).toList(growable: false),
      'totalPrice': totalPrice,
      'status': status,
      'paymentMethod': paymentMethod,
      'createdAt': createdAt.toIso8601String(),
      'deliveryAddress': deliveryAddress,
      'notes': notes,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    final rawItems = (map['items'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>();

    final rawCreatedAt = map['createdAt'];
    DateTime createdAt;
    if (rawCreatedAt is String) {
      createdAt = DateTime.tryParse(rawCreatedAt) ?? DateTime.now();
    } else if (rawCreatedAt is Timestamp) {
      createdAt = rawCreatedAt.toDate();
    } else {
      createdAt = DateTime.now();
    }

    return Order(
      id: map['id'] as String? ?? map['orderId'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      customerName: map['customerName'] as String? ?? '',
      customerPhone: map['customerPhone'] as String? ?? '',
      customerEmail: map['customerEmail'] as String? ?? '',
      items: rawItems
          .map(
            (item) => CartItem(
              id: item['id'] as String? ?? item['coffeeId'] as String? ?? '',
              name: item['name'] as String? ?? '',
              imageUrl: item['imageUrl'] as String? ??
                  item['picture'] as String? ??
                  '',
              price: (item['price'] as num?)?.toDouble() ?? 0,
              category: item['category'] as String? ?? '',
              quantity: item['quantity'] as int? ?? 1,
            ),
          )
          .toList(growable: false),
      totalPrice: (map['totalPrice'] as num?)?.toDouble() ?? 0,
      status: map['status'] as String? ?? 'pending',
      paymentMethod: map['paymentMethod'] as String? ?? 'cash',
      createdAt: createdAt,
      deliveryAddress: map['deliveryAddress'] as String?,
      notes: map['notes'] as String?,
    );
  }

  factory Order.fromCacheMap(Map<String, dynamic> map) {
    final rawItems = (map['items'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>();

    return Order(
      id: map['id'] as String? ?? map['orderId'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      customerName: map['customerName'] as String? ?? '',
      customerPhone: map['customerPhone'] as String? ?? '',
      customerEmail: map['customerEmail'] as String? ?? '',
      items: rawItems.map(CartItem.fromJson).toList(growable: false),
      totalPrice: (map['totalPrice'] as num?)?.toDouble() ?? 0,
      status: map['status'] as String? ?? 'pending',
      paymentMethod: map['paymentMethod'] as String? ?? 'cash',
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
      deliveryAddress: map['deliveryAddress'] as String?,
      notes: map['notes'] as String?,
    );
  }

  String get statusDisplay {
    switch (status) {
      case 'pending':
        return 'Chờ xác nhận';
      case 'confirmed':
        return 'Đã xác nhận';
      case 'preparing':
        return 'Đang chuẩn bị';
      case 'ready':
        return 'Sẵn sàng lấy';
      case 'delivered':
        return 'Đã giao';
      case 'completed':
        return 'Hoàn thành';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return status;
    }
  }

  bool get countsTowardSpending {
    final normalizedStatus = status.trim().toLowerCase();
    return normalizedStatus == 'delivered' || normalizedStatus == 'completed';
  }

  String get paymentMethodDisplay {
    switch (paymentMethod.trim().toLowerCase()) {
      case 'cash':
        return 'Tiền mặt';
      case 'card':
        return 'Thẻ';
      case 'online':
        return 'Thanh toán online';
      default:
        return paymentMethod;
    }
  }
}
