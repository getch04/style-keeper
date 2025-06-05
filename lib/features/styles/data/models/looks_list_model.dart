import 'package:style_keeper/features/wardrobe/data/models/clothing_item.dart';

class LooksListModel {
  final String id;
  final String name;
  final List<ClothingItem> items;
  final String? imagePath;
  final DateTime createdAt;
  final DateTime updatedAt;

  LooksListModel({
    required this.id,
    required this.name,
    required this.items,
    this.imagePath,
    required this.createdAt,
    required this.updatedAt,
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
  }) {
    return LooksListModel(
      id: id ?? this.id,
      name: name ?? this.name,
      items: items ?? this.items,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Convert model to Map for database operations
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'items': items.map((item) => item.toJson()).toList(),
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create model from Map (from database)
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
    );
  }
}
