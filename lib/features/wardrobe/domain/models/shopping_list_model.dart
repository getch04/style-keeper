import 'package:style_keeper/features/wardrobe/data/models/clothing_item.dart';

class ShoppingListModel {
  final String id;
  final String name;
  final List<ClothingItem> items;
  final double totalPrice;
  final double budget;
  final String? imagePath;
  final DateTime createdAt;
  final DateTime updatedAt;

  ShoppingListModel({
    required this.id,
    required this.name,
    required this.items,
    required this.totalPrice,
    required this.budget,
    this.imagePath,
    required this.createdAt,
    required this.updatedAt,
  });

  // Calculate total price from items
  double get calculatedTotalPrice {
    return items.fold(0, (sum, item) => sum + (item.price ?? 0));
  }

  // Check if budget is exceeded
  bool get isBudgetExceeded {
    return calculatedTotalPrice > budget;
  }

  // Get remaining budget
  double get remainingBudget {
    return budget - calculatedTotalPrice;
  }

  // Create a copy of the model with updated fields
  ShoppingListModel copyWith({
    String? id,
    String? name,
    List<ClothingItem>? items,
    double? totalPrice,
    double? budget,
    String? imagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ShoppingListModel(
      id: id ?? this.id,
      name: name ?? this.name,
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      budget: budget ?? this.budget,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Convert model to Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'items': items.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
      'budget': budget,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create model from Map (from database)
  factory ShoppingListModel.fromMap(Map<String, dynamic> map) {
    return ShoppingListModel(
      id: map['id'] as String,
      name: map['name'] as String,
      items: (map['items'] as List)
          .map((item) => ClothingItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalPrice: map['totalPrice'] as double,
      budget: map['budget'] as double,
      imagePath: map['imagePath'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }
}
