import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'clothing_item.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
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

  factory ClothingItem.fromJson(Map<dynamic, dynamic> map) {
    return ClothingItem(
      id: map['id'] as String,
      name: map['name'] as String,
      brand: map['brand'] as String,
      placeOfPurchase: map['placeOfPurchase'] as String,
      price: (map['price'] as num).toDouble(),
      imagePath: map['imagePath'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return _$ClothingItemToJson(this);
  }

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
}
