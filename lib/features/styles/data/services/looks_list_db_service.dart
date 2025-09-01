import 'package:hive/hive.dart';
import 'package:style_keeper/features/styles/data/models/looks_list_model.dart';
import 'package:style_keeper/features/wardrobe/data/models/clothing_item.dart';
import 'package:uuid/uuid.dart';

class LooksListDbService {
  static const String _boxName = 'looks_lists';
  late Box<Map<dynamic, dynamic>> _box;
  final _uuid = const Uuid();

  Future<void> init() async {
    _box = await Hive.openBox<Map<dynamic, dynamic>>(_boxName);
  }

  // Create a new looks list
  Future<LooksListModel> createLooksList({
    required String name,
    String? imagePath,
    List<ClothingItem> items = const [],
    String? season,
    String? weather,
  }) async {
    final now = DateTime.now();
    final looksList = LooksListModel(
      id: _uuid.v4(),
      name: name,
      items: items,
      imagePath: imagePath,
      createdAt: now,
      updatedAt: now,
      season: season,
      weather: weather,
    );

    await _box.put(looksList.id, looksList.toJson());
    return looksList;
  }

  // Get all looks lists
  Future<List<LooksListModel>> getAllLooksLists() async {
    return _box.values.map((map) => LooksListModel.fromJson(map)).toList();
  }

  // Get looks lists filtered by weather
  Future<List<LooksListModel>> getLooksListsByWeather(String weather) async {
    final allLists = await getAllLooksLists();
    return allLists
        .where((list) => list.weather?.toLowerCase() == weather.toLowerCase())
        .toList();
  }

  // Get a looks list by ID
  Future<LooksListModel?> getLooksList(String id) async {
    final map = _box.get(id);
    if (map == null) return null;
    return LooksListModel.fromJson(map);
  }

  // Update a looks list
  Future<LooksListModel> updateLooksList(LooksListModel looksList) async {
    final updatedList = looksList.copyWith(
      updatedAt: DateTime.now(),
    );
    await _box.put(updatedList.id, updatedList.toJson());
    return updatedList;
  }

  // Delete a looks list
  Future<void> deleteLooksList(String id) async {
    await _box.delete(id);
  }

  // Add an item to a looks list
  Future<LooksListModel> addItemToLooksList(
    String looksListId,
    ClothingItem item,
  ) async {
    final looksList = await getLooksList(looksListId);
    if (looksList == null) {
      throw Exception('Looks list not found');
    }

    final updatedItems = [...looksList.items, item];
    final updatedList = looksList.copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    );

    await _box.put(updatedList.id, updatedList.toJson());
    return updatedList;
  }

  // Remove an item from a looks list
  Future<LooksListModel> removeItemFromLooksList(
    String looksListId,
    String itemId,
  ) async {
    final looksList = await getLooksList(looksListId);
    if (looksList == null) {
      throw Exception('Looks list not found');
    }

    final updatedItems =
        looksList.items.where((item) => item.id != itemId).toList();

    final updatedList = looksList.copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    );

    await _box.put(updatedList.id, updatedList.toJson());
    return updatedList;
  }

  // Update an item in a looks list
  Future<LooksListModel> updateItemInLooksList(
    String looksListId,
    ClothingItem updatedItem,
  ) async {
    final looksList = await getLooksList(looksListId);
    if (looksList == null) {
      throw Exception('Looks list not found');
    }

    final updatedItems = looksList.items.map((item) {
      return item.id == updatedItem.id ? updatedItem : item;
    }).toList();

    final updatedList = looksList.copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    );

    await _box.put(updatedList.id, updatedList.toJson());
    return updatedList;
  }
}
