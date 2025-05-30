import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'clothing_item.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class ClothingItem {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final String season;

  @HiveField(4)
  final String color;

  @HiveField(5)
  final String? imageUrl;

  @HiveField(6)
  final DateTime dateAdded;

  @HiveField(7)
  final List<String> tags;

  ClothingItem({
    String? id,
    required this.name,
    required this.category,
    required this.season,
    required this.color,
    this.imageUrl,
    DateTime? dateAdded,
    List<String>? tags,
  })  : id = id ?? const Uuid().v4(),
        dateAdded = dateAdded ?? DateTime.now(),
        tags = tags ?? [];

  factory ClothingItem.fromJson(Map<String, dynamic> json) =>
      _$ClothingItemFromJson(json);

  Map<String, dynamic> toJson() => _$ClothingItemToJson(this);

  ClothingItem copyWith({
    String? name,
    String? category,
    String? season,
    String? color,
    String? imageUrl,
    List<String>? tags,
  }) {
    return ClothingItem(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      season: season ?? this.season,
      color: color ?? this.color,
      imageUrl: imageUrl ?? this.imageUrl,
      dateAdded: dateAdded,
      tags: tags ?? this.tags,
    );
  }
}
