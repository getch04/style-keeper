import 'package:flutter/material.dart';
import 'package:style_keeper/features/wardrobe/data/models/clothing_item.dart';
import 'package:style_keeper/features/wardrobe/data/services/shopping_list_db_service.dart';
import 'package:style_keeper/features/wardrobe/domain/models/shopping_list_model.dart';

class ShoppingListProvider extends ChangeNotifier {
  final ShoppingListDbService _dbService;
  List<ShoppingListModel> _shoppingLists = [];
  bool _isLoading = false;
  String? _error;

  ShoppingListProvider(this._dbService);

  // Getters
  List<ShoppingListModel> get shoppingLists => _shoppingLists;
  bool get isLoading => _isLoading;
  String? get error => _error;

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
