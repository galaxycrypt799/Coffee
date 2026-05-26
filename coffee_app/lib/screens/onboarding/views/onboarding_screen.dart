import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({required this.onFinish, super.key});

  final VoidCallback onFinish;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  static const List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Cà phê đúng gu',
      description:
          'Chọn nhanh phin Việt, cold brew, latte hoặc espresso với hình ảnh và thông tin rõ ràng.',
      image: 'assets/coffee/velvet_latte.jpg',
      icon: Icons.local_cafe_rounded,
    ),
    OnboardingData(
      title: 'Đặt món mượt hơn',
      description:
          'Xem giá, ưu đãi, mô tả món và thêm vào giỏ chỉ trong vài thao tác.',
      image: 'assets/coffee/midnight_mocha.jpg',
      icon: Icons.shopping_bag_rounded,
    ),
    OnboardingData(
      title: 'Theo dõi đơn dễ dàng',
      description:
          'Sau khi đặt hàng, đơn sẽ nằm trong Hoạt động để bạn kiểm tra trạng thái bất cứ lúc nào.',
      image: 'assets/coffee/hero_shop.jpg',
      icon: Icons.receipt_long_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) => _OnboardingPage(
              data: _pages[index],
              pageIndex: index,
              pageCount: _pages.length,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 20,
            child: TextButton(
              onPressed: widget.onFinish,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black.withValues(alpha: 0.24),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              child: const Text('Bỏ qua'),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).padding.bottom + 28,
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        margin: const EdgeInsets.only(right: 8),
                        width: _currentIndex == index ? 28 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.34),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                ),
                FilledButton(
                  onPressed: _goNextOrFinish,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2C1B16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: Text(
                    _currentIndex < _pages.length - 1 ? 'Tiếp theo' : 'Bắt đầu',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _goNextOrFinish() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeOutCubic,
      );
      return;
    }
    widget.onFinish();
  }
}

class OnboardingData {
  const OnboardingData({
    required this.title,
    required this.description,
    required this.image,
    required this.icon,
  });

  final String title;
  final String description;
  final String image;
  final IconData icon;
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.data,
    required this.pageIndex,
    required this.pageCount,
  });

  final OnboardingData data;
  final int pageIndex;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            data.image,
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.08),
                  Colors.black.withValues(alpha: 0.38),
                  const Color(0xFF1B100D),
                ],
                stops: const [0.0, 0.46, 1.0],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 80, 24, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.16),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(data.icon, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        '${pageIndex + 1}/$pageCount',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  data.title,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        height: 1.02,
                      ),
                ),
                const SizedBox(height: 14),
                Text(
                  data.description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.86),
                        height: 1.5,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
