import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CoffeeProduct {
  final String name;
  final String description;
  final String picture;
  final double price;
  final double discount;
  final String tag;

  const CoffeeProduct({
    required this.name,
    required this.description,
    required this.picture,
    required this.price,
    required this.discount,
    required this.tag,
  });

  double get finalPrice => price - (price * discount / 100);
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<CoffeeProduct> coffees = [
    CoffeeProduct(
      name: 'Cappuccino',
      description: 'Coffee with steamed milk foam and a smooth taste.',
      picture:
      'https://images.unsplash.com/photo-1534778101976-62847782c213?q=80&w=800',
      price: 4.00,
      discount: 10,
      tag: 'HOT',
    ),
    CoffeeProduct(
      name: 'Latte',
      description: 'Espresso mixed with creamy steamed milk.',
      picture:
      'https://images.unsplash.com/photo-1561882468-9110e03e0f78?q=80&w=800',
      price: 5.00,
      discount: 15,
      tag: 'CREAMY',
    ),
    CoffeeProduct(
      name: 'Espresso',
      description: 'Strong and rich coffee for a quick energy boost.',
      picture:
      'https://images.unsplash.com/photo-1510707577719-ae7c14805e3a?q=80&w=800',
      price: 3.00,
      discount: 0,
      tag: 'STRONG',
    ),
    CoffeeProduct(
      name: 'Mocha',
      description: 'Coffee blended with chocolate and milk.',
      picture:
      'https://images.unsplash.com/photo-1517701604599-bb29b565090c?q=80&w=800',
      price: 6.00,
      discount: 20,
      tag: 'SWEET',
    ),
  ];

  String _formatPrice(double price) {
    return price.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Row(
          children: [
            Icon(
              Icons.local_cafe,
              size: 32,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 8),
            const Text(
              'COFFEE',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 30,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cart feature is not available yet.'),
                ),
              );
            },
            icon: const Icon(CupertinoIcons.cart),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sign out feature is not available yet.'),
                ),
              );
            },
            icon: const Icon(CupertinoIcons.arrow_right_to_line),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: coffees.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 9 / 16,
          ),
          itemBuilder: (context, int i) {
            final coffee = coffees[i];

            return Material(
              elevation: 3,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          CoffeeDetailsScreen(coffee: coffee),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: Image.network(
                        coffee.picture,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 120,
                            width: double.infinity,
                            color: Colors.brown.shade50,
                            child: Icon(
                              Icons.local_cafe,
                              size: 48,
                              color: Colors.brown.shade300,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.brown,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              child: Text(
                                coffee.tag,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (coffee.discount > 0)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                child: Text(
                                  'SALE ${coffee.discount.toInt()}%',
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        coffee.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        coffee.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    '\$${_formatPrice(coffee.finalPrice)}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                if (coffee.discount > 0)
                                  Flexible(
                                    child: Text(
                                      '\$${_formatPrice(coffee.price)}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w700,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${coffee.name} added to cart'),
                                ),
                              );
                            },
                            icon: const Icon(
                              CupertinoIcons.add_circled_solid,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
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

class CoffeeDetailsScreen extends StatelessWidget {
  final CoffeeProduct coffee;

  const CoffeeDetailsScreen({
    super.key,
    required this.coffee,
  });

  String _formatPrice(double price) {
    return price.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: Text(coffee.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(
                coffee.picture,
                height: 260,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 260,
                    width: double.infinity,
                    color: Colors.brown.shade50,
                    child: Icon(
                      Icons.local_cafe,
                      size: 80,
                      color: Colors.brown.shade300,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              coffee.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              coffee.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  '\$${_formatPrice(coffee.finalPrice)}',
                  style: TextStyle(
                    fontSize: 24,
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 10),
                if (coffee.discount > 0)
                  Text(
                    '\$${_formatPrice(coffee.price)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${coffee.name} added to cart'),
                    ),
                  );
                },
                icon: const Icon(CupertinoIcons.cart_badge_plus),
                label: const Text(
                  'Add to cart',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
