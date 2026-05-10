import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_bootstrap.dart';
import '../../../components/coffee_image.dart';
import '../../../utils/price_formatter.dart';
import '../../home/blocs/get_coffee_bloc/get_coffee_bloc.dart';
import '../../home/blocs/cart_bloc/cart_bloc.dart';
import 'details_screen.dart';
import 'package:coffee_repository/coffee_repository.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({
    required this.bootstrap,
    super.key,
  });

  final AppBootstrap bootstrap;

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'Tất cả';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetCoffeeBloc, GetCoffeeState>(
      builder: (context, state) {
        if (state is GetCoffeeLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GetCoffeeSuccess) {
          final drinks = state.coffees;

          final categories = <String>['Tất cả'];
          final raw = drinks.map((d) => d.category).toSet();
          categories.addAll(raw);

          var filtered = _selectedCategory == 'Tất cả'
              ? drinks
              : drinks.where((d) => d.category == _selectedCategory).toList();

          if (_searchQuery.isNotEmpty) {
            final query = _searchQuery.toLowerCase();
            filtered = filtered.where((d) {
              return d.name.toLowerCase().contains(query) ||
                  d.tagline.toLowerCase().contains(query) ||
                  d.description.toLowerCase().contains(query);
            }).toList();
          }

          return _MenuBody(
            bootstrap: widget.bootstrap,
            drinks: filtered,
            categories: categories,
            selectedCategory: _selectedCategory,
            searchController: _searchController,
            onCategoryChanged: (cat) => setState(() => _selectedCategory = cat),
            onSearchChanged: (q) => setState(() => _searchQuery = q),
          );
        }

        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.local_drink_outlined, size: 48),
              const SizedBox(height: 12),
              Text(
                'Không tải được thực đơn',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  context.read<GetCoffeeBloc>().add(GetCoffeeRequested());
                },
                child: const Text('Thử lại'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MenuBody extends StatelessWidget {
  const _MenuBody({
    required this.bootstrap,
    required this.drinks,
    required this.categories,
    required this.selectedCategory,
    required this.searchController,
    required this.onCategoryChanged,
    required this.onSearchChanged,
  });

  final AppBootstrap bootstrap;
  final List<Coffee> drinks;
  final List<String> categories;
  final String selectedCategory;
  final TextEditingController searchController;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const chipBorderSide = BorderSide(color: Color(0xFFE7D3BD));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thực đơn đồ uống'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<GetCoffeeBloc>().add(GetCoffeeRequested());
          await Future<void>.delayed(const Duration(milliseconds: 450));
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              sliver: SliverToBoxAdapter(
                child: TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Tìm đồ uống...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        searchController.clear();
                        onSearchChanged('');
                      },
                    )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              sliver: SliverToBoxAdapter(
                child: SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      final isSelected = cat == selectedCategory;
                      return FilterChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (_) => onCategoryChanged(cat),
                        selectedColor: theme.colorScheme.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : null,
                          fontWeight: FontWeight.w600,
                        ),
                        backgroundColor: Colors.white,
                        side: isSelected ? BorderSide.none : chipBorderSide,
                      );
                    },
                  ),
                ),
              ),
            ),
            if (drinks.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_off_rounded,
                          size: 56, color: Colors.grey[300]),
                      const SizedBox(height: 12),
                      Text(
                        'Không tìm thấy đồ uống',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Thử tìm với từ khóa khác',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList.separated(
                  itemCount: drinks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final drink = drinks[index];
                    return _DrinkListTile(
                      drink: drink,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => DetailsScreen(drink),
                        ),
                      ),
                      onAddToCart: () {
                        context.read<CartBloc>().add(
                          AddToCartEvent(coffee: drink, quantity: 1),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                            Text('${drink.name} đã thêm vào giỏ hàng'),
                            action: SnackBarAction(
                              label: 'Xem giỏ',
                              onPressed: () =>
                                  Navigator.of(context).pushNamed('/cart'),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
          ],
        ),
      ),
    );
  }
}

class _DrinkListTile extends StatelessWidget {
  const _DrinkListTile({
    required this.drink,
    required this.onTap,
    required this.onAddToCart,
  });

  final Coffee drink;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final hasDiscount = drink.discount > 0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE7D3BD)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: CoffeeImage(
                imagePath: drink.picture,
                width: 92,
                height: 92,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(drink.name,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(
                    drink.tagline,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        formatVnd(drink.discountedPrice),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      if (hasDiscount) ...[
                        const SizedBox(width: 8),
                        Text(
                          formatVnd(drink.price),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '-${drink.discount}%',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onAddToCart,
              icon: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
