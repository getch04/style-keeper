// import 'package:hive/hive.dart';
// import 'package:json_annotation/json_annotation.dart';
// import 'package:uuid/uuid.dart';

// part 'clothing_item.g.dart';

// @HiveType(typeId: 0)
// @JsonSerializable()
// class ClothingItem {
//   @HiveField(0)
//   final String id;

//   @HiveField(1)
//   final String name;

//   @HiveField(2)
//   final String category;

//   @HiveField(3)
//   final String season;

//   @HiveField(4)
//   final String color;

//   @HiveField(5)
//   final String brand;

//   @HiveField(6)
//   final String placeOfPurchase;

//   @HiveField(7)
//   final double price;

//   @HiveField(8)
//   final String? imagePath;

//   @HiveField(9)
//   final DateTime createdAt;

//   @HiveField(10)
//   final List<String> tags;

//   ClothingItem({
//     String? id,
//     required this.name,
//     required this.category,
//     required this.season,
//     required this.color,
//     required this.brand,
//     required this.placeOfPurchase,
//     required this.price,
//     this.imagePath,
//     DateTime? createdAt,
//     List<String>? tags,
//   })  : id = id ?? const Uuid().v4(),
//         createdAt = createdAt ?? DateTime.now(),
//         tags = tags ?? [];

//   factory ClothingItem.fromJson(Map<String, dynamic> json) =>
//       _$ClothingItemFromJson(json);

//   Map<String, dynamic> toJson() => _$ClothingItemToJson(this);

//   ClothingItem copyWith({
//     String? name,
//     String? category,
//     String? season,
//     String? color,
//     String? brand,
//     String? placeOfPurchase,
//     double? price,
//     String? imagePath,
//     List<String>? tags,
//   }) {
//     return ClothingItem(
//       id: id,
//       name: name ?? this.name,
//       category: category ?? this.category,
//       season: season ?? this.season,
//       color: color ?? this.color,
//       brand: brand ?? this.brand,
//       placeOfPurchase: placeOfPurchase ?? this.placeOfPurchase,
//       price: price ?? this.price,
//       imagePath: imagePath ?? this.imagePath,
//       createdAt: createdAt,
//       tags: tags ?? this.tags,
//     );
//   }

//   ClothingItem merge(ClothingItem other) {
//     return ClothingItem(
//       id: other.id.isNotEmpty ? other.id : id,
//       name: other.name.isNotEmpty ? other.name : name,
//       category: other.category.isNotEmpty ? other.category : category,
//       season: other.season.isNotEmpty ? other.season : season,
//       color: other.color.isNotEmpty ? other.color : color,
//       brand: other.brand.isNotEmpty ? other.brand : brand,
//       placeOfPurchase: other.placeOfPurchase.isNotEmpty
//           ? other.placeOfPurchase
//           : placeOfPurchase,
//       price: other.price != 0 ? other.price : price,
//       imagePath: other.imagePath ?? imagePath,
//       createdAt: other.createdAt,
//       tags: other.tags.isNotEmpty ? other.tags : tags,
//     );
//   }
// }
