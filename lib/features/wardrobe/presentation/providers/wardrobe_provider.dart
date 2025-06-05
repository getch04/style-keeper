import 'package:flutter/foundation.dart';
import 'package:style_keeper/features/wardrobe/data/models/clothing_item.dart';

class WardrobeProvider extends ChangeNotifier {
  List<ClothingItem> _items = [];

  List<ClothingItem> get items => _items;

  void addItem(ClothingItem item) {
    _items = [..._items, item];
    notifyListeners();
  }

  void removeItem(String itemId) {
    _items = _items.where((item) => item.id != itemId).toList();
    notifyListeners();
  }

  void updateItem(ClothingItem updatedItem) {
    _items = _items
        .map((item) => item.id == updatedItem.id ? updatedItem : item)
        .toList();
    notifyListeners();
  }

  List<ClothingItem> filterByBrand(String brand) {
    return _items.where((item) => item.brand == brand).toList();
  }
}
