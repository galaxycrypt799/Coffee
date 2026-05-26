// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:coffee_app/models/cart.dart';
import 'package:coffee_app/models/cart_item.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  static const _cartKey = 'coffee_app_cart';

  CartBloc() : super(const CartInitial()) {
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<ClearCartEvent>(_onClearCart);
    on<LoadCartEvent>(_onLoadCart);
  }

  Future<void> _persistCart(Cart cart) async {
    final prefs = await SharedPreferences.getInstance();
    if (cart.isEmpty) {
      await prefs.remove(_cartKey);
    } else {
      await prefs.setString(_cartKey, jsonEncode(cart.toJson()));
    }
  }

  Future<void> _onAddToCart(
      AddToCartEvent event, Emitter<CartState> emit) async {
    try {
      final currentCart = _getCurrentCart();
      final cartItem = CartItem(
        id: event.coffee.coffeeId,
        name: event.coffee.name,
        imageUrl: event.coffee.picture,
        price: event.coffee.discountedPrice,
        category: event.coffee.category,
        quantity: event.quantity,
      );

      final updatedCart = currentCart.addItem(cartItem);
      await _persistCart(updatedCart);
      emit(CartUpdated(updatedCart));
    } catch (e) {
      emit(CartError('Lỗi khi thêm vào giỏ hàng: $e'));
    }
  }

  Future<void> _onRemoveFromCart(
      RemoveFromCartEvent event, Emitter<CartState> emit) async {
    try {
      final currentCart = _getCurrentCart();
      final updatedCart = currentCart.removeItem(event.itemId);
      await _persistCart(updatedCart);
      emit(CartUpdated(updatedCart));
    } catch (e) {
      emit(CartError('Lỗi khi xoá khỏi giỏ hàng: $e'));
    }
  }

  Future<void> _onUpdateQuantity(
      UpdateQuantityEvent event, Emitter<CartState> emit) async {
    try {
      final currentCart = _getCurrentCart();
      final updatedCart =
          currentCart.updateQuantity(event.itemId, event.quantity);
      await _persistCart(updatedCart);
      emit(CartUpdated(updatedCart));
    } catch (e) {
      emit(CartError('Lỗi khi cập nhật số lượng: $e'));
    }
  }

  Future<void> _onClearCart(
      ClearCartEvent event, Emitter<CartState> emit) async {
    try {
      const emptyCart = Cart();
      await _persistCart(emptyCart);
      emit(const CartUpdated(Cart()));
    } catch (e) {
      emit(CartError('Lỗi khi xoá giỏ hàng: $e'));
    }
  }

  Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading());
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_cartKey);

      if (cartJson != null) {
        final cart =
            Cart.fromJson(jsonDecode(cartJson) as Map<String, dynamic>);
        emit(CartLoaded(cart));
      } else {
        emit(const CartLoaded(Cart()));
      }
    } catch (e) {
      emit(const CartLoaded(Cart()));
    }
  }

  Cart _getCurrentCart() {
    if (state is CartLoaded) {
      return (state as CartLoaded).cart;
    } else if (state is CartUpdated) {
      return (state as CartUpdated).cart;
    }
    return const Cart();
  }
}
