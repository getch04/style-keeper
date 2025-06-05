import 'package:hive/hive.dart';
import 'package:style_keeper/features/wardrobe/data/models/clothing_item.dart';
import 'package:style_keeper/features/wardrobe/domain/models/shopping_list_model.dart';
import 'package:uuid/uuid.dart';

class ShoppingListDbService {
  static const String _boxName = 'shopping_lists';
  late Box<Map<dynamic, dynamic>> _box;
  final _uuid = const Uuid();

  Future<void> init() async {
    _box = await Hive.openBox<Map<dynamic, dynamic>>(_boxName);
  }

  // Create a new shopping list
  Future<ShoppingListModel> createShoppingList({
    required String name,
    required double budget,
    String? imagePath,
    List<ClothingItem> items = const [],
  }) async {
    final now = DateTime.now();
    final shoppingList = ShoppingListModel(
      id: _uuid.v4(),
      name: name,
      items: items,
      totalPrice: items.fold(0, (sum, item) => sum + (item.price ?? 0)),
      budget: budget,
      imagePath: imagePath,
      createdAt: now,
      updatedAt: now,
    );

    await _box.put(shoppingList.id, shoppingList.toJson());
    return shoppingList;
  }

  // Get all shopping lists
  Future<List<ShoppingListModel>> getAllShoppingLists() async {
    print("========getAllShoppingLists=========");
    print(_box.values);
    return _box.values.map((map) => ShoppingListModel.fromJson(map)).toList();
  }

  // Get a shopping list by ID
  Future<ShoppingListModel?> getShoppingList(String id) async {
    final map = _box.get(id);
    if (map == null) return null;
    return ShoppingListModel.fromJson(map);
  }

  // Update a shopping list
  Future<ShoppingListModel> updateShoppingList(
      ShoppingListModel shoppingList) async {
    final updatedList = shoppingList.copyWith(
      updatedAt: DateTime.now(),
      totalPrice: shoppingList.calculatedTotalPrice,
    );
    await _box.put(updatedList.id, updatedList.toJson());
    return updatedList;
  }

  // Delete a shopping list
  Future<void> deleteShoppingList(String id) async {
    await _box.delete(id);
  }

  // Add an item to a shopping list
  Future<ShoppingListModel> addItemToShoppingList(
    String shoppingListId,
    ClothingItem item,
  ) async {
    final shoppingList = await getShoppingList(shoppingListId);
    if (shoppingList == null) {
      throw Exception('Shopping list not found');
    }

    final updatedItems = [...shoppingList.items, item];
    final updatedList = shoppingList.copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    );

    await _box.put(updatedList.id, updatedList.toJson());
    return updatedList;
  }

  // Remove an item from a shopping list
  Future<ShoppingListModel> removeItemFromShoppingList(
    String shoppingListId,
    String itemId,
  ) async {
    final shoppingList = await getShoppingList(shoppingListId);
    if (shoppingList == null) {
      throw Exception('Shopping list not found');
    }

    final updatedItems =
        shoppingList.items.where((item) => item.id != itemId).toList();

    final updatedList = shoppingList.copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    );

    await _box.put(updatedList.id, updatedList.toJson());
    return updatedList;
  }

  // Update an item in a shopping list
  Future<ShoppingListModel> updateItemInShoppingList(
    String shoppingListId,
    ClothingItem updatedItem,
  ) async {
    final shoppingList = await getShoppingList(shoppingListId);
    if (shoppingList == null) {
      throw Exception('Shopping list not found');
    }

    final updatedItems = shoppingList.items.map((item) {
      return item.id == updatedItem.id ? updatedItem : item;
    }).toList();

    final updatedList = shoppingList.copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    );

    await _box.put(updatedList.id, updatedList.toJson());
    return updatedList;
  }
}
