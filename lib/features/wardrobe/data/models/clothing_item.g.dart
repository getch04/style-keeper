// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clothing_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClothingItemAdapter extends TypeAdapter<ClothingItem> {
  @override
  final int typeId = 0;

  @override
  ClothingItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClothingItem(
      id: fields[0] as String,
      name: fields[1] as String,
      brand: fields[2] as String,
      placeOfPurchase: fields[3] as String,
      price: fields[4] as double,
      imagePath: fields[5] as String,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ClothingItem obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.brand)
      ..writeByte(3)
      ..write(obj.placeOfPurchase)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.imagePath)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClothingItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClothingItem _$ClothingItemFromJson(Map<String, dynamic> json) => ClothingItem(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      placeOfPurchase: json['placeOfPurchase'] as String,
      price: (json['price'] as num).toDouble(),
      imagePath: json['imagePath'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ClothingItemToJson(ClothingItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'brand': instance.brand,
      'placeOfPurchase': instance.placeOfPurchase,
      'price': instance.price,
      'imagePath': instance.imagePath,
      'createdAt': instance.createdAt.toIso8601String(),
    };
