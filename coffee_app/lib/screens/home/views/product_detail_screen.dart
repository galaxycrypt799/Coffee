import 'package:coffee_app/screens/home/views/details_screen.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({
    required this.drink,
    super.key,
  });

  final Coffee drink;

  @override
  Widget build(BuildContext context) {
    return DetailsScreen(drink);
  }
}
