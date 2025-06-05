import 'package:flutter/material.dart';
import 'package:style_keeper/features/styles/data/models/looks_list_model.dart';
import 'package:style_keeper/features/styles/data/services/looks_list_db_service.dart';
import 'package:style_keeper/features/wardrobe/data/models/clothing_item.dart';

class LooksListProvider extends ChangeNotifier {
  final LooksListDbService _dbService;
  List<LooksListModel> _looksLists = [];
  bool _isLoading = false;
  String? _newListName;
  String? _newListImagePath;
  List<ClothingItem> _temporaryItems = [];

  // Item form fields
  String? _newItemName;
  String? _newItemBrand;
  String? _newItemPlace;
  String? _newItemPrice;
  String? _newItemImagePath;

  bool editLooksMode = false;
  String? looksListIdToBeEdited;

  // Getters
  List<LooksListModel> get looksLists => _looksLists;
  bool get isLoading => _isLoading;
  String? get newListName => _newListName;
  String? get newListImagePath => _newListImagePath;
  List<ClothingItem> get temporaryItems => _temporaryItems;
  double get temporaryItemsTotalPrice =>
      _temporaryItems.fold(0, (sum, item) => sum + (item.price ?? 0));

  // Item form getters
  String? get newItemName => _newItemName;
  String? get newItemBrand => _newItemBrand;
  String? get newItemPlace => _newItemPlace;
  String? get newItemPrice => _newItemPrice;
  String? get newItemImagePath => _newItemImagePath;

  LooksListProvider(this._dbService);

  // Load all looks lists
  Future<void> loadLooksLists() async {
    _isLoading = true;
    notifyListeners();

    try {
      _looksLists = await _dbService.getAllLooksLists();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create a new looks list
  Future<void> createLooksList({
    required String name,
    String? imagePath,
  }) async {
    final newList = await _dbService.createLooksList(
      name: name,
      imagePath: imagePath,
      items: _temporaryItems,
    );

    _looksLists = [..._looksLists, newList];
    clearTemporaryItems();
    clearNewListForm();
    notifyListeners();
  }

  // Update a looks list
  Future<void> updateLooksList(LooksListModel list) async {
    final updatedList = await _dbService.updateLooksList(list);
    _looksLists = _looksLists
        .map((l) => l.id == updatedList.id ? updatedList : l)
        .toList();
    notifyListeners();
  }

  // Delete a looks list
  Future<void> deleteLooksList(String id) async {
    await _dbService.deleteLooksList(id);
    _looksLists = _looksLists.where((list) => list.id != id).toList();
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

  void clearTemporaryItems() {
    _temporaryItems = [];
    notifyListeners();
  }

  // New list form management
  void setNewListName(String? name) {
    _newListName = name;
    notifyListeners();
  }

  void setNewListImagePath(String? path) {
    _newListImagePath = path;
    notifyListeners();
  }

  void clearNewListForm() {
    _newListName = null;
    _newListImagePath = null;
    notifyListeners();
  }

  // Item form management
  void setNewItemName(String? name) {
    _newItemName = name;
    notifyListeners();
  }

  void setNewItemBrand(String? brand) {
    _newItemBrand = brand;
    notifyListeners();
  }

  void setNewItemPlace(String? place) {
    _newItemPlace = place;
    notifyListeners();
  }

  void setNewItemPrice(String? price) {
    _newItemPrice = price;
    notifyListeners();
  }

  void setNewItemImagePath(String? path) {
    _newItemImagePath = path;
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

  // Get a looks list by ID
  Future<LooksListModel?> getLooksList(String id) async {
    return _dbService.getLooksList(id);
  }

  void updateEditLooksMode(bool value, String listId) {
    editLooksMode = value;
    looksListIdToBeEdited = listId;
    notifyListeners();
  }

  void clearEditLooksMode() {
    editLooksMode = false;
    looksListIdToBeEdited = null;
    notifyListeners();
  }
}
