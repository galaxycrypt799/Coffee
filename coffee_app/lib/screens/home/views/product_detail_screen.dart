import 'package:coffee_app/screens/home/blocs/cart_bloc/cart_bloc.dart';
import 'package:coffee_app/components/coffee_image.dart';
import 'package:coffee_app/utils/price_formatter.dart' as pf;
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailScreen extends StatefulWidget {
  final Coffee drink;

  const ProductDetailScreen({required this.drink, super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết sản phẩm'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh sản phẩm
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.grey[200],
              child: CoffeeImage(
                imagePath: widget.drink.picture,
                fit: BoxFit.cover,
                errorChild: Center(
                  child: Icon(
                    Icons.local_drink,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),

            // Thông tin sản phẩm
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên sản phẩm
                  Text(
                    widget.drink.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),

                  // Danh mục
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.brown[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.drink.category,
                      style: TextStyle(
                        color: Colors.brown[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Đánh giá và giá
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            '4.5 (128 đánh giá)',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Text(
                        pf.formatPrice(widget.drink.price),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.brown[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Mô tả
                  Text(
                    'Mô tả',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.drink.description.isNotEmpty
                        ? widget.drink.description
                        : 'Thức uống được pha chế từ nguyên liệu tươi ngon, công thức độc đáo.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),

                  // Chi tiết thêm
                  _buildDetailItem(context, 'Xuất xứ', widget.drink.origin.isNotEmpty ? widget.drink.origin : 'Việt Nam'),
                  const SizedBox(height: 12),
                  _buildDetailItem(context, 'Dung tích', '${widget.drink.volumeMl}ml'),
                  const SizedBox(height: 12),
                  _buildDetailItem(context, 'Hương vị', widget.drink.tagline),
                  const SizedBox(height: 32),

                  // Số lượng
                  Text(
                    'Số lượng',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildQuantityButton(Icons.remove, () {
                        if (quantity > 1) {
                          setState(() => quantity--);
                        }
                      }),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              quantity.toString(),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        ),
                      ),
                      _buildQuantityButton(Icons.add, () {
                        setState(() => quantity++);
                      }),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Nút thêm vào giỏ hàng
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: () {
                        context.read<CartBloc>().add(
                          AddToCartEvent(
                            coffee: widget.drink,
                            quantity: quantity,
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Đã thêm $quantity ${widget.drink.name} vào giỏ hàng',
                            ),
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'Xem giỏ',
                              onPressed: () {
                                Navigator.of(context).pushNamed('/cart');
                              },
                            ),
                          ),
                        );

                        Navigator.pop(context);
                      },
                      child: const Text('Thêm vào giỏ hàng'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: 48,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          side: BorderSide(color: Colors.grey[300]!),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }
}
