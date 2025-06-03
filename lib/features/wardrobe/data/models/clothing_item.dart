import 'package:hive/hive.dart';

part 'clothing_item.g.dart';

@HiveType(typeId: 0)
class ClothingItem extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String brand;

  @HiveField(3)
  String placeOfPurchase;

  @HiveField(4)
  double price;

  @HiveField(5)
  String imagePath;

  @HiveField(6)
  DateTime createdAt;

  ClothingItem({
    required this.id,
    required this.name,
    required this.brand,
    required this.placeOfPurchase,
    required this.price,
    required this.imagePath,
    required this.createdAt,
  });

  ClothingItem copyWith({
    String? id,
    String? name,
    String? brand,
    String? placeOfPurchase,
    double? price,
    String? imagePath,
    DateTime? createdAt,
  }) {
    return ClothingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      placeOfPurchase: placeOfPurchase ?? this.placeOfPurchase,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  ClothingItem merge(ClothingItem other) {
    return ClothingItem(
      id: other.id.isNotEmpty ? other.id : id,
      name: other.name.isNotEmpty ? other.name : name,
      brand: other.brand.isNotEmpty ? other.brand : brand,
      placeOfPurchase: other.placeOfPurchase.isNotEmpty
          ? other.placeOfPurchase
          : placeOfPurchase,
      price: other.price != 0 ? other.price : price,
      imagePath: other.imagePath.isNotEmpty ? other.imagePath : imagePath,
      createdAt: other.createdAt ?? createdAt,
    );
  }

  //to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'placeOfPurchase': placeOfPurchase,
      'price': price,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
