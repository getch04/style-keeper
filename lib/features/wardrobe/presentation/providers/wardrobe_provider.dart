import 'package:flutter/foundation.dart';

import '../../domain/models/clothing_item.dart';

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

  List<ClothingItem> filterByCategory(String category) {
    return _items.where((item) => item.category == category).toList();
  }

  List<ClothingItem> filterBySeason(String season) {
    return _items.where((item) => item.season == season).toList();
  }
}
