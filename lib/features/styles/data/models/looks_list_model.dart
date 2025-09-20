import 'package:hive/hive.dart';
import 'package:style_keeper/features/wardrobe/data/models/clothing_item.dart';

part 'looks_list_model.g.dart';

@HiveType(typeId: 11)
class LooksListModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<ClothingItem> items;

  @HiveField(3)
  final String? imagePath;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime updatedAt;

  @HiveField(6)
  final String? season;

  @HiveField(7)
  final String? weather;

  LooksListModel({
    required this.id,
    required this.name,
    required this.items,
    this.imagePath,
    required this.createdAt,
    required this.updatedAt,
    this.season,
    this.weather,
  });

  // Calculate total price from items
  double get calculatedTotalPrice {
    return items.fold(0, (sum, item) => sum + (item.price));
  }

  // Create a copy of the model with updated fields
  LooksListModel copyWith({
    String? id,
    String? name,
    List<ClothingItem>? items,
    String? imagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? season,
    String? weather,
  }) {
    return LooksListModel(
      id: id ?? this.id,
      name: name ?? this.name,
      items: items ?? this.items,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      season: season ?? this.season,
      weather: weather ?? this.weather,
    );
  }

  // Convert model to Map for database operations (for backward compatibility)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'items': items.map((item) => item.toJson()).toList(),
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'season': season,
      'weather': weather,
    };
  }

  // Create model from Map (from database) - for backward compatibility
  factory LooksListModel.fromJson(Map<dynamic, dynamic> map) {
    return LooksListModel(
      id: map['id'] as String,
      name: map['name'] as String,
      items: (map['items'] as List)
          .map((item) => ClothingItem.fromJson(
              Map<String, dynamic>.from(item as Map<dynamic, dynamic>)))
          .toList(),
      imagePath: map['imagePath'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      season: map['season'] as String?,
      weather: map['weather'] as String?,
    );
  }
}
