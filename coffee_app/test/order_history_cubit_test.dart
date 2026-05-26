import 'package:coffee_app/models/cart.dart';
import 'package:coffee_app/models/cart_item.dart';
import 'package:coffee_app/models/order.dart';
import 'package:coffee_app/repositories/order_repository.dart';
import 'package:coffee_app/screens/orders/cubit/order_history_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  group('OrderHistoryCubit.placeOrder', () {
    test('returns success when the order is saved but history refresh fails',
        () async {
      final repository = _RefreshFailsOrderRepository();
      final cubit = OrderHistoryCubit(repository);
      final userRepo = _MockUserRepo();

      final isSuccess = await cubit.placeOrder(
        user: _user,
        cart: _cart,
        customerName: 'Nguyen Van A',
        customerPhone: '0900000001',
        totalPrice: 69000,
        paymentMethod: 'cash',
        deliveryAddress: '123 Test Street',
        userRepository: userRepo,
      );

      expect(isSuccess, isTrue);
      expect(repository.savedOrder, isNotNull);
      expect(userRepo.updateUserSpentCalled, isTrue);
      expect(cubit.state.isSubmitting, isFalse);
      expect(cubit.state.errorMessage, isNull);
      expect(cubit.state.successMessage, isNotNull);
      expect(cubit.state.orders, hasLength(1));
      expect(cubit.state.orders.single.id, repository.savedOrder!.id);
    });

    test('returns failure when saving the order fails', () async {
      final cubit = OrderHistoryCubit(_SaveFailsOrderRepository());
      final userRepo = _MockUserRepo();

      final isSuccess = await cubit.placeOrder(
        user: _user,
        cart: _cart,
        customerName: 'Nguyen Van A',
        customerPhone: '0900000001',
        totalPrice: 69000,
        paymentMethod: 'cash',
        deliveryAddress: '123 Test Street',
        userRepository: userRepo,
      );

      expect(isSuccess, isFalse);
      expect(cubit.state.isSubmitting, isFalse);
      expect(cubit.state.errorMessage, isNotNull);
      expect(cubit.state.orders, isEmpty);
    });
  });
}

class _MockUserRepo implements UserRepository {
  bool updateUserSpentCalled = false;

  @override
  Stream<MyUser?> get user => throw UnimplementedError();

  @override
  Future<void> logOut() => throw UnimplementedError();

  @override
  Future<void> setUserData(MyUser myUser) => throw UnimplementedError();

  @override
  Future<void> signIn(String email, String password) =>
      throw UnimplementedError();

  @override
  Future<MyUser> signUp(MyUser myUser, String password) =>
      throw UnimplementedError();

  @override
  Future<void> updateUserSpent(String userId, double amount) async {
    updateUserSpentCalled = true;
  }
}

final _user = MyUser(
  userId: 'local-user',
  email: 'guest@example.com',
  name: 'Guest',
  hasActiveCart: true,
);

final _cart = Cart(
  items: [
    CartItem(
      id: 'latte',
      name: 'Latte',
      imageUrl: 'assets/coffee/velvet_latte.jpg',
      price: 69000,
      category: 'coffee',
    ),
  ],
);

class _RefreshFailsOrderRepository implements OrderRepository {
  Order? savedOrder;

  @override
  Future<List<Order>> getOrdersForUser(
    String userId, {
    bool forceRefresh = false,
  }) async {
    throw StateError('Missing Firestore index');
  }

  @override
  Future<void> placeOrder(Order order) async {
    savedOrder = order;
  }
}

class _SaveFailsOrderRepository implements OrderRepository {
  @override
  Future<List<Order>> getOrdersForUser(
    String userId, {
    bool forceRefresh = false,
  }) async {
    return const <Order>[];
  }

  @override
  Future<void> placeOrder(Order order) async {
    throw StateError('Permission denied');
  }
}
