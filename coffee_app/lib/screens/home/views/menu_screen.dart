import 'package:coffee_app/components/coffee_image.dart';
import 'package:coffee_app/screens/home/blocs/cart_bloc/cart_bloc.dart';
import 'package:coffee_app/screens/home/blocs/get_coffee_bloc/get_coffee_bloc.dart';
import 'package:coffee_app/screens/home/views/details_screen.dart';
import 'package:coffee_app/utils/price_formatter.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({
    super.key,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  static const _allCategory = 'Tất cả';

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = _allCategory;

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
          final categories = <String>[
            _allCategory,
            ...drinks
                .map((drink) => drink.category)
                .where((category) => category.trim().isNotEmpty)
                .toSet(),
          ];
          final filtered = _filterDrinks(drinks);

          return _MenuBody(
            drinks: filtered,
            totalDrinks: drinks.length,
            categories: categories,
            selectedCategory: _selectedCategory,
            searchController: _searchController,
            onCategoryChanged: (category) {
              setState(() => _selectedCategory = category);
            },
            onSearchChanged: (query) {
              setState(() => _searchQuery = query);
            },
          );
        }

        return _MenuErrorView(
          onRetry: () {
            context
                .read<GetCoffeeBloc>()
                .add(const GetCoffeeRequested(forceRefresh: true));
          },
        );
      },
    );
  }

  List<Coffee> _filterDrinks(List<Coffee> drinks) {
    var filtered = _selectedCategory == _allCategory
        ? drinks
        : drinks
            .where((drink) => drink.category == _selectedCategory)
            .toList(growable: false);

    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return filtered;
    }

    return filtered.where((drink) {
      return drink.name.toLowerCase().contains(query) ||
          drink.tagline.toLowerCase().contains(query) ||
          drink.description.toLowerCase().contains(query) ||
          drink.origin.toLowerCase().contains(query);
    }).toList(growable: false);
  }
}

class _MenuBody extends StatelessWidget {
  const _MenuBody({
    required this.drinks,
    required this.totalDrinks,
    required this.categories,
    required this.selectedCategory,
    required this.searchController,
    required this.onCategoryChanged,
    required this.onSearchChanged,
  });

  final List<Coffee> drinks;
  final int totalDrinks;
  final List<String> categories;
  final String selectedCategory;
  final TextEditingController searchController;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đặt món'),
        actions: [
          IconButton(
            tooltip: 'Giỏ hàng',
            onPressed: () => Navigator.of(context).pushNamed('/cart'),
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context
              .read<GetCoffeeBloc>()
              .add(const GetCoffeeRequested(forceRefresh: true));
          await Future<void>.delayed(const Duration(milliseconds: 450));
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              sliver: SliverToBoxAdapter(
                child: _MenuSummary(
                  totalDrinks: totalDrinks,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              sliver: SliverToBoxAdapter(
                child: TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Tìm món, hương vị, nguồn gốc...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            tooltip: 'Xoá tìm kiếm',
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              searchController.clear();
                              onSearchChanged('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              sliver: SliverToBoxAdapter(
                child: SizedBox(
                  height: 42,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = category == selectedCategory;
                      return ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (_) => onCategoryChanged(category),
                        selectedColor: Theme.of(context).colorScheme.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : null,
                          fontWeight: FontWeight.w800,
                        ),
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: isSelected
                              ? Colors.transparent
                              : const Color(0xFFE7D3BD),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            if (drinks.isEmpty)
              const SliverFillRemaining(
                child: _EmptySearchView(),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
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
                      onAddToCart: () => _addToCart(context, drink),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _addToCart(BuildContext context, Coffee drink) {
    context.read<CartBloc>().add(
          AddToCartEvent(coffee: drink, quantity: 1),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã thêm ${drink.name} vào giỏ hàng'),
        action: SnackBarAction(
          label: 'Xem giỏ',
          onPressed: () => Navigator.of(context).pushNamed('/cart'),
        ),
      ),
    );
  }
}

class _MenuSummary extends StatelessWidget {
  const _MenuSummary({
    required this.totalDrinks,
  });

  final int totalDrinks;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C1B16),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.local_cafe_rounded, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$totalDrinks món đang phục vụ',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
        ],
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
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE7D3BD)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CoffeeImage(
                imagePath: drink.picture,
                width: 84,
                height: 84,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    drink.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    drink.tagline,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.35,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      Text(
                        formatVnd(drink.discountedPrice),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                      ),
                      if (hasDiscount) ...[
                        const SizedBox(width: 8),
                        Text(
                          formatVnd(drink.price),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            IconButton.filled(
              onPressed: onAddToCart,
              icon: const Icon(Icons.add_rounded),
              tooltip: 'Thêm vào giỏ',
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySearchView extends StatelessWidget {
  const _EmptySearchView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 56, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'Không tìm thấy món',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Thử đổi từ khoá hoặc nhóm món.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _MenuErrorView extends StatelessWidget {
  const _MenuErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_cafe_outlined, size: 48),
          const SizedBox(height: 12),
          Text(
            'Không tải được thực đơn',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onRetry,
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}
