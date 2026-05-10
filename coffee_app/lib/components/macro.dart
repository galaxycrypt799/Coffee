import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyMacroWidget extends StatelessWidget {
  const MyMacroWidget({
    required this.title,
    required this.value,
    required this.icon,
    this.accentColor = const Color(0xFFC58A54),
    super.key,
  });

  final String title;
  final int value;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final valueLabel = title == 'Calories' ? '$value kcal' : '$value g';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE7D3BD),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: FaIcon(
                icon,
                size: 16,
                color: accentColor,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            valueLabel,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
