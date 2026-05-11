import 'package:flutter/material.dart';

class CoffeeImage extends StatelessWidget {
  const CoffeeImage({
    required this.imagePath,
    this.fit = BoxFit.cover,
    this.errorChild,
    this.width,
    this.height,
    super.key,
  });

  final String imagePath;
  final BoxFit fit;
  final Widget? errorChild;
  final double? width;
  final double? height;

  bool get _isRemoteImage =>
      imagePath.startsWith('http://') || imagePath.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    final fallback = errorChild ??
        Container(
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: Icon(
            Icons.local_cafe_outlined,
            color: Colors.grey.shade500,
          ),
        );

    if (_isRemoteImage) {
      return Image.network(
        imagePath,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, __, ___) => fallback,
        loadingBuilder: (context, child, progress) {
          if (progress == null) {
            return child;
          }
          return Container(
            color: Colors.grey.shade200,
            alignment: Alignment.center,
            child: const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
      );
    }

    return Image.asset(
      imagePath,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (_, __, ___) => fallback,
    );
  }
}
