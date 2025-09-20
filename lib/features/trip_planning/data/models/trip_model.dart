import 'package:hive/hive.dart';
import 'package:style_keeper/features/styles/data/models/looks_list_model.dart';
import 'package:style_keeper/features/wardrobe/data/models/clothing_item.dart';

part 'trip_model.g.dart';

@HiveType(typeId: 10)
class TripModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String duration;

  @HiveField(3)
  final String imagePath;

  @HiveField(4)
  final List<ClothingItem> items;

  @HiveField(5)
  final List<LooksListModel> completedLooks;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime updatedAt;

  TripModel({
    required this.id,
    required this.name,
    required this.duration,
    required this.imagePath,
    required this.items,
    required this.completedLooks,
    required this.createdAt,
    required this.updatedAt,
  });

  TripModel copyWith({
    String? id,
    String? name,
    String? duration,
    String? imagePath,
    List<ClothingItem>? items,
    List<LooksListModel>? completedLooks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TripModel(
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      imagePath: imagePath ?? this.imagePath,
      items: items ?? this.items,
      completedLooks: completedLooks ?? this.completedLooks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
