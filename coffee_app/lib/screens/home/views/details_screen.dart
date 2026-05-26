import 'package:coffee_app/components/coffee_image.dart';
import 'package:coffee_app/screens/home/blocs/cart_bloc/cart_bloc.dart';
import 'package:coffee_app/utils/price_formatter.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen(this.coffee, {super.key});

  final Coffee coffee;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int _quantity = 1;

  Coffee get coffee => widget.coffee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 360,
            pinned: true,
            stretch: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'coffee-${coffee.coffeeId}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CoffeeImage(
                      imagePath: coffee.picture,
                      fit: BoxFit.cover,
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x33241612),
                            Color(0x00241612),
                            Color(0xCC241612),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 130),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TitleBlock(coffee: coffee),
                  const SizedBox(height: 18),
                  _InfoGrid(coffee: coffee),
                  const SizedBox(height: 24),
                  const _SectionTitle(title: 'Mô tả'),
                  const SizedBox(height: 8),
                  Text(
                    coffee.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.55,
                          color: const Color(0xFF5E473F),
                        ),
                  ),
                  if (coffee.tastingNotes.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const _SectionTitle(title: 'Hương vị'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: coffee.tastingNotes
                          .map((note) => _DetailChip(label: note))
                          .toList(growable: false),
                    ),
                  ],
                  const SizedBox(height: 24),
                  const _SectionTitle(title: 'Dinh dưỡng'),
                  const SizedBox(height: 10),
                  _MacroRow(macros: coffee.macros),
                  const SizedBox(height: 24),
                  _QuantitySelector(
                    quantity: _quantity,
                    onDecrease: _quantity == 1
                        ? null
                        : () => setState(() => _quantity -= 1),
                    onIncrease: () => setState(() => _quantity += 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng cộng',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatVnd(coffee.discountedPrice * _quantity),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: _addToCart,
                icon: const Icon(Icons.shopping_bag_rounded),
                label: const Text('Thêm giỏ'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addToCart() {
    context.read<CartBloc>().add(
          AddToCartEvent(
            coffee: coffee,
            quantity: _quantity,
          ),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã thêm $_quantity ${coffee.name} vào giỏ hàng'),
        action: SnackBarAction(
          label: 'Xem giỏ',
          onPressed: () => Navigator.of(context).pushNamed('/cart'),
        ),
      ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.coffee});

  final Coffee coffee;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                coffee.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              formatVnd(coffee.discountedPrice),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          coffee.tagline,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF6B5148),
                height: 1.45,
              ),
        ),
      ],
    );
  }
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.coffee});

  final Coffee coffee;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _DetailChip(label: coffee.category, icon: Icons.local_cafe_rounded),
        _DetailChip(label: coffee.caffeineLevel, icon: Icons.bolt_rounded),
        _DetailChip(label: '${coffee.volumeMl}ml', icon: Icons.local_drink),
        _DetailChip(label: '${coffee.brewMinutes} phút', icon: Icons.timer),
        _DetailChip(
          label: '${coffee.rating.toStringAsFixed(1)}★',
          icon: Icons.star_rounded,
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge);
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({
    required this.label,
    this.icon,
  });

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE7D3BD)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 15, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class _MacroRow extends StatelessWidget {
  const _MacroRow({required this.macros});

  final Macros macros;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Kcal', macros.calories),
      ('Protein', macros.proteins),
      ('Fat', macros.fat),
      ('Carbs', macros.carbs),
    ];

    return Row(
      children: items
          .map(
            (item) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE7D3BD)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        item.$2.toString(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.$1,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  const _QuantitySelector({
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int quantity;
  final VoidCallback? onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Số lượng',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        IconButton.filledTonal(
          onPressed: onDecrease,
          icon: const Icon(Icons.remove_rounded),
        ),
        SizedBox(
          width: 48,
          child: Text(
            quantity.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        IconButton.filledTonal(
          onPressed: onIncrease,
          icon: const Icon(Icons.add_rounded),
        ),
      ],
    );
  }
}
