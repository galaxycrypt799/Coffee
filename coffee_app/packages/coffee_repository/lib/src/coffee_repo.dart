import 'models/models.dart';

abstract class CoffeeRepo {
  Future<List<Coffee>> getCoffees({bool forceRefresh = false});
}
