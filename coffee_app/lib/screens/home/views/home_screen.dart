import 'package:coffee_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:coffee_app/components/coffee_image.dart';
import 'package:coffee_app/screens/home/blocs/get_coffee_bloc/get_coffee_bloc.dart';
import 'package:coffee_app/screens/home/views/details_screen.dart';
import 'package:coffee_app/screens/home/widgets/coffee_card.dart';
import 'package:coffee_app/utils/price_formatter.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    this.onOpenMenu,
    super.key,
  });

  final VoidCallback? onOpenMenu;

  @override
  Widget build(BuildContext context) {
    final firstName = context.select((AuthenticationBloc bloc) {
      final name = bloc.state.user?.name ?? '';
      final trimmedName = name.trim();
      if (trimmedName.isEmpty) {
        return 'Bạn';
      }
      return trimmedName.split(RegExp(r'\s+')).last;
    });

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<GetCoffeeBloc, GetCoffeeState>(
          builder: (context, state) {
            if (state is GetCoffeeLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is GetCoffeeSuccess) {
              return _CoffeeHomeBody(
                userName: firstName,
                coffees: state.coffees,
                onOpenMenu: onOpenMenu,
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
        ),
      ),
    );
  }
}

class _CoffeeHomeBody extends StatefulWidget {
  const _CoffeeHomeBody({
    required this.userName,
    required this.coffees,
    required this.onOpenMenu,
  });

  final String userName;
  final List<Coffee> coffees;
  final VoidCallback? onOpenMenu;

  @override
  State<_CoffeeHomeBody> createState() => _CoffeeHomeBodyState();
}

class _CoffeeHomeBodyState extends State<_CoffeeHomeBody> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasSearch = _searchQuery.trim().isNotEmpty;
    final searchResults = _filterCoffees(widget.coffees);
    final featuredCoffees = widget.coffees.take(3).toList(growable: false);
    final popularCoffees = widget.coffees.length > 3
        ? widget.coffees.skip(3).take(5).toList(growable: false)
        : widget.coffees.take(5).toList(growable: false);
    final categories = widget.coffees
        .map((coffee) => coffee.category)
        .where((category) => category.trim().isNotEmpty)
        .toSet()
        .take(5)
        .toList(growable: false);

    return RefreshIndicator(
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
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  _TopBar(
                    userName: widget.userName,
                  ),
                  const SizedBox(height: 16),
                  _HomeSearchField(
                    controller: _searchController,
                    onChanged: (query) {
                      setState(() => _searchQuery = query);
                    },
                    onClear: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  ),
                  const SizedBox(height: 18),
                  if (hasSearch) ...[
                    _SectionHeader(
                      title: 'Kết quả tìm kiếm',
                      actionLabel: '${searchResults.length} món',
                    ),
                    const SizedBox(height: 12),
                    if (searchResults.isEmpty)
                      const _HomeSearchEmptyView()
                    else
                      ...searchResults.map(
                        (coffee) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _CoffeeListTile(
                            coffee: coffee,
                            onTap: () => _openDetails(context, coffee),
                          ),
                        ),
                      ),
                  ] else ...[
                    _HeroPanel(
                      onOrderNow: widget.onOpenMenu,
                    ),
                    const SizedBox(height: 20),
                    _CategoryStrip(categories: categories),
                    const SizedBox(height: 24),
                    _SectionHeader(
                      title: 'Gợi ý hôm nay',
                      actionLabel: 'Xem menu',
                      onAction: widget.onOpenMenu,
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 304,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: featuredCoffees.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemBuilder: (context, index) {
                          final coffee = featuredCoffees[index];
                          return CoffeeCard(
                            coffee: coffee,
                            onTap: () => _openDetails(context, coffee),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    const _SectionHeader(title: 'Món phổ biến'),
                    const SizedBox(height: 12),
                    ...popularCoffees.map(
                      (coffee) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _CoffeeListTile(
                          coffee: coffee,
                          onTap: () => _openDetails(context, coffee),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Coffee> _filterCoffees(List<Coffee> coffees) {
    final query = _normalizeSearchText(_searchQuery);
    if (query.isEmpty) {
      return coffees;
    }

    return coffees.where((coffee) {
      final searchableText = _normalizeSearchText(
        [
          coffee.name,
          coffee.tagline,
          coffee.description,
          coffee.category,
          coffee.origin,
          coffee.caffeineLevel,
          coffee.tastingNotes.join(' '),
        ].join(' '),
      );

      return searchableText.contains(query);
    }).toList(growable: false);
  }

  String _normalizeSearchText(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp('[àáạảãâầấậẩẫăằắặẳẵ]'), 'a')
        .replaceAll(RegExp('[èéẹẻẽêềếệểễ]'), 'e')
        .replaceAll(RegExp('[ìíịỉĩ]'), 'i')
        .replaceAll(RegExp('[òóọỏõôồốộổỗơờớợởỡ]'), 'o')
        .replaceAll(RegExp('[ùúụủũưừứựửữ]'), 'u')
        .replaceAll(RegExp('[ỳýỵỷỹ]'), 'y')
        .replaceAll('đ', 'd');
  }

  void _openDetails(BuildContext context, Coffee coffee) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DetailsScreen(coffee),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.userName,
  });

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chào $userName',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Chọn món nhanh, theo dõi đơn dễ dàng.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        _TopBarAction(
          icon: Icons.shopping_cart_outlined,
          tooltip: 'Giỏ hàng',
          onTap: () => Navigator.of(context).pushNamed('/cart'),
        ),
      ],
    );
  }
}

class _TopBarAction extends StatelessWidget {
  const _TopBarAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE7D4C0)),
          ),
          child: Icon(icon, color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
    );
  }
}

class _HomeSearchField extends StatelessWidget {
  const _HomeSearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Tìm món, hương vị, loại cà phê...',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'Xóa tìm kiếm',
                onPressed: onClear,
                icon: const Icon(Icons.clear_rounded),
              ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({
    required this.onOrderNow,
  });

  final VoidCallback? onOrderNow;

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.textScalerOf(context).scale(1);
    final panelHeight =
        288.0 + ((textScaleFactor - 1.0).clamp(0.0, 0.5) * 80.0);
    final imageCacheHeight =
        (panelHeight * MediaQuery.devicePixelRatioOf(context)).round();

    return SizedBox(
      height: panelHeight,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 22,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/coffee/hero_shop.jpg',
              fit: BoxFit.cover,
              cacheHeight: imageCacheHeight,
              filterQuality: FilterQuality.low,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x2223120D),
                    Color(0xB525140F),
                    Color(0xF225140F),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text(
                    'Cà phê ngon,\nđặt trong vài chạm.',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          height: 1.04,
                        ),
                  ),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: onOrderNow,
                    icon: const Icon(Icons.local_cafe_rounded),
                    label: const Text('Đặt món ngay'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF2C1B16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 13,
                      ),
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
}

class _CategoryStrip extends StatelessWidget {
  const _CategoryStrip({required this.categories});

  final List<String> categories;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFFE7D3BD)),
            ),
            child: Text(
              categories[index],
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        if (actionLabel != null)
          onAction == null
              ? Text(
                  actionLabel!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                )
              : TextButton(
                  onPressed: onAction,
                  child: Text(actionLabel!),
                ),
      ],
    );
  }
}

class _CoffeeListTile extends StatelessWidget {
  const _CoffeeListTile({
    required this.coffee,
    required this.onTap,
  });

  final Coffee coffee;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
                imagePath: coffee.picture,
                width: 82,
                height: 82,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coffee.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    coffee.tagline,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.35,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _MiniChip(label: coffee.category),
                      _MiniChip(label: coffee.caffeineLevel),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatVnd(coffee.discountedPrice),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 10),
                const Icon(Icons.arrow_forward_rounded, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  const _MiniChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EBDE),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}

class _HomeSearchEmptyView extends StatelessWidget {
  const _HomeSearchEmptyView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 56, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'Không tìm thấy món',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Thử đổi từ khóa hoặc xem toàn bộ menu.',
            textAlign: TextAlign.center,
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_cafe_outlined, size: 52),
            const SizedBox(height: 12),
            Text(
              'Không tải được thực đơn',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Hãy kiểm tra kết nối rồi tải lại menu.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Tải lại'),
            ),
          ],
        ),
      ),
    );
  }
}
