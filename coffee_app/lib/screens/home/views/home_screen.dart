// TODO: Implement by team member
// File: screens\home\views\home_screen.dart
import 'package:coffee_app/app_bootstrap.dart';
import 'package:coffee_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:coffee_app/components/coffee_image.dart';

import 'package:coffee_app/screens/home/blocs/get_coffee_bloc/get_coffee_bloc.dart';
import 'package:coffee_app/screens/home/views/details_screen.dart';
import 'package:coffee_app/screens/home/widgets/brew_highlight_tile.dart';
import 'package:coffee_app/screens/home/widgets/coffee_card.dart';
import 'package:coffee_app/utils/price_formatter.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.bootstrap,
    super.key,
  });

  final AppBootstrap bootstrap;

  @override
  Widget build(BuildContext context) {
    final firstName = context.select((AuthenticationBloc bloc) {
      final name = bloc.state.user?.name ?? '';
      if (name.trim().isEmpty) {
        return 'Bạn';
      }
      return name.trim().split(' ').first;
    });

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<GetCoffeeBloc, GetCoffeeState>(
          builder: (context, state) {
            if (state is GetCoffeeLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is GetCoffeeSuccess) {
              return _CoffeeHomeBody(
                bootstrap: bootstrap,
                userName: firstName,
                coffees: state.coffees,
              );
            }

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_drink_outlined, size: 52),
                    const SizedBox(height: 12),
                    Text(
                      'Không tải được thực đơn',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hãy thử tải lại catalog một lần nữa.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    FilledButton(
                      onPressed: () {
                        context.read<GetCoffeeBloc>().add(GetCoffeeRequested());
                      },
                      child: const Text('Tải lại menu'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CoffeeHomeBody extends StatelessWidget {
  const _CoffeeHomeBody({
    required this.bootstrap,
    required this.userName,
    required this.coffees,
  });

  final AppBootstrap bootstrap;
  final String userName;
  final List<Coffee> coffees;

  @override
  Widget build(BuildContext context) {
    final featuredCoffees = coffees.take(3).toList(growable: false);
    final quickOrderCoffees = coffees.skip(2).toList(growable: false);
    final categories = coffees
        .map((coffee) => coffee.category)
        .toSet()
        .take(4)
        .toList(growable: false);

    return RefreshIndicator(
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
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  _TopBar(
                    userName: userName,
                    backendLabel: bootstrap.statusTitle,
                  ),
                  const SizedBox(height: 20),
                  _LoyaltyBanner(bootstrap: bootstrap),
                  const SizedBox(height: 24),
                  const _SectionHeader(
                    title: 'Danh mục đồ uống',
                    subtitle:
                        'Khám phá thực đơn đa dạng từ cà phê, trà, sinh tố đến nước ép.',
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: categories
                        .map((category) => _CategoryChip(label: category))
                        .toList(growable: false),
                  ),
                  const SizedBox(height: 26),
                  const _SectionHeader(
                    title: 'Gợi ý hôm nay',
                    subtitle:
                        'Thức uống nổi bật, ưu đãi hấp dẫn, đặt nhanh chóng.',
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 312,
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
                  const SizedBox(height: 26),
                  const _SectionHeader(
                    title: 'Tiện ích nhanh',
                    subtitle:
                        'Ưu đãi thành viên, đặt trước, tìm cửa hàng gần nhất.',
                  ),
                  const SizedBox(height: 14),
                  const Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      BrewHighlightTile(
                        title: 'Ưu đãi thành viên',
                        subtitle: 'Theo dõi hạng, quà và mã giảm giá gần nhất.',
                        icon: Icons.workspace_premium_outlined,
                      ),
                      BrewHighlightTile(
                        title: 'Đặt trước 10 phút',
                        subtitle: 'Chọn món xong là có thể ghé lấy tại quầy.',
                        icon: Icons.shopping_bag_outlined,
                      ),
                      BrewHighlightTile(
                        title: 'Tìm cửa hàng',
                        subtitle: 'Cách sử dụng tiện lợi.',
                        icon: Icons.storefront_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  const _SectionHeader(
                    title: 'Đồ uống phổ biến',
                    subtitle: 'Thức uống được yêu thích nhất, dễ dàng đặt lại.',
                  ),
                  const SizedBox(height: 14),
                  ...quickOrderCoffees.map(
                    (coffee) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _CoffeeListTile(
                        coffee: coffee,
                        onTap: () => _openDetails(context, coffee),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
    required this.backendLabel,
  });

  final String userName;
  final String backendLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Xin chào, $userName',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 6),
              Text(
                'Thực đơn đồ uống đa dạng, đặt món siêu nhanh.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFFE7D3BD)),
                ),
                child: Text(
                  backendLabel,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _TopBarAction(
          icon: Icons.shopping_cart_outlined,
          onTap: () {
            Navigator.of(context).pushNamed('/cart');
          },
        ),
        const SizedBox(width: 10),
        _TopBarAction(
          icon: Icons.person_outline_rounded,
          onTap: () {
            Navigator.of(context).pushNamed('/profile');
          },
        ),
        const SizedBox(width: 10),
        _TopBarAction(
          icon: Icons.logout_rounded,
          onTap: () {
            context
                .read<AuthenticationBloc>()
                .add(const AuthenticationLogoutRequested());
          },
        ),
      ],
    );
  }
}

class _TopBarAction extends StatelessWidget {
  const _TopBarAction({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE7D4C0)),
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.onSurface),
      ),
    );
  }
}

class _LoyaltyBanner extends StatelessWidget {
  const _LoyaltyBanner({
    required this.bootstrap,
  });

  final AppBootstrap bootstrap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/coffee/hero_shop.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0x4423120D),
                  Color(0xCC25140F),
                  Color(0xFF25140F),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.stars_rounded,
                              color: Colors.amber, size: 16),
                          const SizedBox(width: 6),
                          Builder(
                            builder: (context) {
                              final user = context.select(
                                  (AuthenticationBloc bloc) => bloc.state.user);
                              final rank = _getRankName((user?.totalSpent ?? 0.0).toDouble());
                              return Text(
                                'Thành viên $rank',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      bootstrap.usesFirebase
                          ? Icons.cloud_done_rounded
                          : Icons.layers_rounded,
                      color: Colors.white.withValues(alpha: 0.5),
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Ưu đãi rõ hơn,\nđặt món nhanh hơn.',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        height: 1.05,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 16),
                Builder(
                  builder: (context) {
                    final user = context.select(
                        (AuthenticationBloc bloc) => bloc.state.user);
                    final double totalSpent = user?.totalSpent ?? 0.0;
                    final nextRankData = _getNextRankData(totalSpent);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Chi tiêu: ${formatVnd(totalSpent)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              'Mục tiêu: ${formatVnd(nextRankData.targetAmount)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: nextRankData.progress,
                            minHeight: 8,
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.amber),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          nextRankData.message,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 11,
                                  ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _getRankName(double totalSpent) {
  if (totalSpent < 1000000) return 'Đồng';
  if (totalSpent < 3000000) return 'Bạc';
  if (totalSpent < 10000000) return 'Vàng';
  return 'Kim cương';
}

class _NextRankData {
  final double targetAmount;
  final double progress;
  final String message;

  _NextRankData({
    required this.targetAmount,
    required this.progress,
    required this.message,
  });
}

_NextRankData _getNextRankData(double totalSpent) {
  final double currentTotal = totalSpent.toDouble();
  if (currentTotal < 1000000) {
    return _NextRankData(
      targetAmount: 1000000,
      progress: currentTotal / 1000000,
      message: 'Còn ${formatVnd(1000000 - currentTotal)} để lên hạng Bạc',
    );
  } else if (currentTotal < 3000000) {
    return _NextRankData(
      targetAmount: 3000000,
      progress: (currentTotal - 1000000) / (3000000 - 1000000),
      message: 'Còn ${formatVnd(3000000 - currentTotal)} để lên hạng Vàng',
    );
  } else if (currentTotal < 10000000) {
    return _NextRankData(
      targetAmount: 10000000,
      progress: (currentTotal - 3000000) / (10000000 - 3000000),
      message: 'Còn ${formatVnd(10000000 - currentTotal)} để lên hạng Kim cương',
    );
  } else {
    return _NextRankData(
      targetAmount: currentTotal,
      progress: 1.0,
      message: 'Bạn đã đạt hạng cao nhất!',
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE7D3BD)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
      ),
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
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE7D3BD)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: CoffeeImage(
                imagePath: coffee.picture,
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
                  Text(
                    coffee.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    coffee.tagline,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.4,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _MiniChip(label: coffee.category),
                      _MiniChip(label: coffee.caffeineLevel),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
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
                Text(
                  '${coffee.rating.toStringAsFixed(1)}★',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 10),
                const Icon(Icons.arrow_forward_rounded),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  const _MiniChip({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EBDE),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
