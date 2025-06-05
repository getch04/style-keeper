import 'package:flutter/material.dart';
import 'package:style_keeper/features/wardrobe/data/models/clothing_item.dart';
import 'package:style_keeper/features/wardrobe/data/services/shopping_list_db_service.dart';
import 'package:style_keeper/features/wardrobe/data/models/shopping_list_model.dart';

class ShoppingListProvider extends ChangeNotifier {
  final ShoppingListDbService _dbService;
  List<ShoppingListModel> _shoppingLists = [];
  List<ClothingItem> _temporaryItems = [];
  bool _isLoading = false;
  String? _error;
  bool editShoppingMode = false;
  String? shoppingListIdToBeEdited;
  // Form state
  String? _newListName;
  String? _newListImagePath;
  String? _newItemName;
  String? _newItemBrand;
  String? _newItemPlace;
  String? _newItemPrice;
  String? _newItemImagePath;

  ShoppingListProvider(this._dbService);

  // Getters
  List<ShoppingListModel> get shoppingLists => _shoppingLists;
  List<ClothingItem> get temporaryItems => _temporaryItems;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Form state getters
  String? get newListName => _newListName;
  String? get newListImagePath => _newListImagePath;
  String? get newItemName => _newItemName;
  String? get newItemBrand => _newItemBrand;
  String? get newItemPlace => _newItemPlace;
  String? get newItemPrice => _newItemPrice;
  String? get newItemImagePath => _newItemImagePath;

  // update edit shopping mode
  void updateEditShoppingMode(bool value, String listId) {
    editShoppingMode = value;
    shoppingListIdToBeEdited = listId;
    notifyListeners();
  }

  // Form state setters
  void setNewListName(String? value) {
    _newListName = value;
    notifyListeners();
  }

  void setNewListImagePath(String? value) {
    _newListImagePath = value;
    notifyListeners();
  }

  void setNewItemName(String? value) {
    _newItemName = value;
    notifyListeners();
  }

  void setNewItemBrand(String? value) {
    _newItemBrand = value;
    notifyListeners();
  }

  void setNewItemPlace(String? value) {
    _newItemPlace = value;
    notifyListeners();
  }

  void setNewItemPrice(String? value) {
    _newItemPrice = value;
    notifyListeners();
  }

  void setNewItemImagePath(String? value) {
    _newItemImagePath = value;
    notifyListeners();
  }

  // Clear form state
  void clearNewListForm() {
    _newListName = null;
    _newListImagePath = null;
    notifyListeners();
  }

  void clearNewItemForm() {
    _newItemName = null;
    _newItemBrand = null;
    _newItemPlace = null;
    _newItemPrice = null;
    _newItemImagePath = null;
    notifyListeners();
  }

  // Temporary items management
  void addTemporaryItem(ClothingItem item) {
    _temporaryItems = [..._temporaryItems, item];
    notifyListeners();
  }

  void removeTemporaryItem(String itemId) {
    _temporaryItems =
        _temporaryItems.where((item) => item.id != itemId).toList();
    notifyListeners();
  }

  void updateTemporaryItem(ClothingItem updatedItem) {
    _temporaryItems = _temporaryItems
        .map((item) => item.id == updatedItem.id ? updatedItem : item)
        .toList();
    notifyListeners();
  }

  void clearTemporaryItems() {
    _temporaryItems = [];
    editShoppingMode = false;
    shoppingListIdToBeEdited = null;
    notifyListeners();
  }

  // Calculate total price of temporary items
  double get temporaryItemsTotalPrice {
    return _temporaryItems.fold(0, (sum, item) => sum + (item.price ?? 0));
  }

  // Load all shopping lists
  Future<void> loadShoppingLists() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _shoppingLists = await _dbService.getAllShoppingLists();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create a new shopping list
  Future<ShoppingListModel?> createShoppingList({
    required String name,
    required double budget,
    String? imagePath,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newList = await _dbService.createShoppingList(
        name: name,
        budget: budget,
        imagePath: imagePath,
        items: _temporaryItems,
      );
      _shoppingLists.add(newList);
      _error = null;
      return newList;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update a shopping list
  Future<bool> updateShoppingList(ShoppingListModel shoppingList) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedList = await _dbService.updateShoppingList(shoppingList);
      final index =
          _shoppingLists.indexWhere((list) => list.id == updatedList.id);
      if (index != -1) {
        _shoppingLists[index] = updatedList;
      }
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete a shopping list
  Future<bool> deleteShoppingList(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _dbService.deleteShoppingList(id);
      _shoppingLists.removeWhere((list) => list.id == id);
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add an item to a shopping list
  Future<bool> addItemToShoppingList(
    String shoppingListId,
    ClothingItem item,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedList = await _dbService.addItemToShoppingList(
        shoppingListId,
        item,
      );
      final index =
          _shoppingLists.indexWhere((list) => list.id == updatedList.id);
      if (index != -1) {
        _shoppingLists[index] = updatedList;
      }
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Remove an item from a shopping list
  Future<bool> removeItemFromShoppingList(
    String shoppingListId,
    String itemId,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedList = await _dbService.removeItemFromShoppingList(
        shoppingListId,
        itemId,
      );
      final index =
          _shoppingLists.indexWhere((list) => list.id == updatedList.id);
      if (index != -1) {
        _shoppingLists[index] = updatedList;
      }
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update an item in a shopping list
  Future<bool> updateItemInShoppingList(
    String shoppingListId,
    ClothingItem updatedItem,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedList = await _dbService.updateItemInShoppingList(
        shoppingListId,
        updatedItem,
      );
      final index =
          _shoppingLists.indexWhere((list) => list.id == updatedList.id);
      if (index != -1) {
        _shoppingLists[index] = updatedList;
      }
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
