import 'package:hive/hive.dart';

import '../models/clothing_item.dart';

class WardrobeHiveService {
  static final WardrobeHiveService _instance = WardrobeHiveService._internal();
  factory WardrobeHiveService() => _instance;
  WardrobeHiveService._internal();

  static const String boxName = 'clothing_items';

  Future<Box<ClothingItem>> _openBox() async {
    return await Hive.openBox<ClothingItem>(boxName);
  }

  Future<void> addClothingItem(ClothingItem item) async {
    print('===========addClothingItem===========');
    print(item.toJson());
    final box = await _openBox();
    await box.put(item.id, item);
  }

  Future<List<ClothingItem>> getAllClothingItems() async {
    final box = await _openBox();
    print('===========getAllClothingItems===========');
    print(box.values.toList());
    return box.values.toList();
  }

  Future<void> updateClothingItem(ClothingItem item) async {
    final box = await _openBox();
    await box.put(item.id, item);
  }

  Future<void> deleteClothingItem(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  Future<void> clearAllClothingItems() async {
    final box = await _openBox();
    await box.clear();
  }
}
