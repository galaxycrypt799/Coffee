<<<<<<< HEAD
=======
// TODO: Implement by team member
// File: screens\home\views\cart_screen.dart
>>>>>>> dev
// ignore_for_file: prefer_const_constructors

import 'package:coffee_app/components/coffee_image.dart';
import 'package:coffee_app/screens/home/blocs/cart_bloc/cart_bloc.dart';
import 'package:coffee_app/utils/price_formatter.dart' as pf;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
        elevation: 0,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoaded && state.cart.isEmpty) {
            return _buildEmptyCart(context);
          }

          if (state is CartUpdated && state.cart.isEmpty) {
            return _buildEmptyCart(context);
          }

          if (state is CartError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 56, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                ],
              ),
            );
          }

          final cart = (state is CartLoaded)
              ? state.cart
              : (state is CartUpdated)
                  ? state.cart
                  : null;

          if (cart == null || cart.isEmpty) {
            return _buildEmptyCart(context);
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return _buildCartItem(context, item);
                  },
                ),
              ),
              // Tóm tắt đơn hàng
              _buildOrderSummary(context, cart),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Giỏ hàng trống',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Hãy thêm sản phẩm yêu thích vào giỏ hàng',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 24),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(context),
            child: const Text('Quay lại mua sắm'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, dynamic item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Hình ảnh
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CoffeeImage(
                  imagePath: item.imageUrl,
                  fit: BoxFit.cover,
                  errorChild: Icon(
                    Icons.local_drink,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Thông tin sản phẩm
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pf.formatPrice(item.price),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.brown[700],
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),

                  // Quantity controls
                  Row(
                    children: [
                      _buildSmallQuantityButton(
                        Icons.remove,
                        () {
                          if (item.quantity > 1) {
                            context.read<CartBloc>().add(
                                  UpdateQuantityEvent(
                                    itemId: item.id,
                                    quantity: item.quantity - 1,
                                  ),
                                );
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          item.quantity.toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      _buildSmallQuantityButton(
                        Icons.add,
                        () {
                          context.read<CartBloc>().add(
                                UpdateQuantityEvent(
                                  itemId: item.id,
                                  quantity: item.quantity + 1,
                                ),
                              );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Xoá và tổng giá
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    context.read<CartBloc>().add(
                          RemoveFromCartEvent(item.id),
                        );
                  },
                ),
                Text(
                  pf.formatPrice(item.subtotal),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallQuantityButton(IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: 28,
      height: 28,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: Icon(icon, size: 14),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, dynamic cart) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tạm tính:'),
              Text(pf.formatPrice(cart.totalPrice)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Phí vận chuyển:'),
              Text(pf.formatPrice(0)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Giảm giá:'),
              Text(pf.formatPrice(0)),
            ],
          ),
          Divider(color: Colors.grey[300], height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tổng cộng:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                pf.formatPrice(cart.totalPrice),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.brown[700],
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: () {
                Navigator.pushNamed(context, '/checkout');
              },
              child: Text(
                'Thanh toán (${cart.totalQuantity} sản phẩm)',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
