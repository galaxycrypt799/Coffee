import 'dart:typed_data';

import 'models/models.dart';

abstract class CoffeeRepo {
  Future<List<Coffee>> getCoffees();
  Future<void> createCoffee(Coffee coffee);
  Future<void> updateCoffee(Coffee coffee);
  Future<void> deleteCoffee(String coffeeId);
  Future<String> uploadCoffeeImage(Uint8List file, String fileName);
}
