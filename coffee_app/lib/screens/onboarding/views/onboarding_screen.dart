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

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Thức uống đa dạng',
      description:
      'Từ cà phê đậm đà, trà thơm mát, sinh tố tươi ngon đến nước ép bổ dưỡng — tất cả đều có trong tầm tay bạn.',
      image: 'assets/coffee/onboarding_1.jpg',
      icon: Icons.local_drink_rounded,
    ),
    OnboardingData(
      title: 'Đặt món siêu nhanh',
      description:
      'Chỉ vài chạm là có ngay đồ uống yêu thích. Đặt trước, đến lấy ngay — không phải xếp hàng chờ đợi.',
      image: 'assets/coffee/onboarding_2.jpg',
      icon: Icons.flash_on_rounded,
    ),
    OnboardingData(
      title: 'Thưởng thức mọi lúc',
      description:
      'Dù bạn ở nhà, ở văn phòng hay đang dạo phố — đồ uống ngon luôn sẵn sàng phục vụ bạn. Giao nhanh, tiện lợi.',
      image: 'assets/coffee/onboarding_3.jpg',
      icon: Icons.auto_awesome_rounded,
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
            itemBuilder: (context, index) {
              return _OnboardingPage(data: _pages[index]);
            },
          ),
          Positioned(
            bottom: 60,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(
                    _pages.length,
                        (index) => Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: _currentIndex == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? Theme.of(context).colorScheme.primary
                            : Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_currentIndex < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      widget.onFinish();
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _currentIndex < _pages.length - 1
                        ? 'Tiếp theo'
                        : 'Bắt đầu ngay',
                    style: const TextStyle(fontWeight: FontWeight.bold),
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

class OnboardingData {
  final String title;
  final String description;
  final String image;
  final IconData icon;

  OnboardingData({
    required this.title,
    required this.description,
    required this.image,
    required this.icon,
  });
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});
  final OnboardingData data;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/coffee/hero_shop.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.2),
                  const Color(0xCC241611),
                  const Color(0xFF1A120F),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(data.icon, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 32),
                Text(
                  data.title,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  data.description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 18,
                    height: 1.6,
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
