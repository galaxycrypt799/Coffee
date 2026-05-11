import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:coffee_app/components/coffee_image.dart';
import 'package:coffee_app/screens/home/blocs/cart_bloc/cart_bloc.dart';
import 'package:coffee_app/utils/price_formatter.dart';
import 'package:coffee_repository/coffee_repository.dart';

class DetailsScreen extends StatelessWidget {
  final Coffee coffee;
  const DetailsScreen(this.coffee, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: CoffeeImage(
                imagePath: coffee.picture,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(coffee.name, style: Theme.of(context).textTheme.headlineMedium),
                            Text(coffee.category, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Text(formatVnd(coffee.discountedPrice), style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text("Mô tả", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(coffee.description, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 24),
                  _InfoRow(label: "Nguồn gốc", value: coffee.origin),
                  _InfoRow(label: "Hàm lượng Caffeine", value: coffee.caffeineLevel),
                  _InfoRow(label: "Dung tích", value: "${coffee.volumeMl}ml"),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: () {
                        context.read<CartBloc>().add(
                          AddToCartEvent(
                            coffee: coffee,
                            quantity: 1,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${coffee.name} - Đã thêm vào giỏ hàng!"),
                            action: SnackBarAction(
                              label: 'Xem giỏ',
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushNamed('/cart');
                              },
                            ),
                          ),
                        );
                      },
                      child: const Text("Thêm vào giỏ hàng"),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }
}
