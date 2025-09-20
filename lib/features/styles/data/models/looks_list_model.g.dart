// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'looks_list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LooksListModelAdapter extends TypeAdapter<LooksListModel> {
  @override
  final int typeId = 11;

  @override
  LooksListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LooksListModel(
      id: fields[0] as String,
      name: fields[1] as String,
      items: (fields[2] as List).cast<ClothingItem>(),
      imagePath: fields[3] as String?,
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime,
      season: fields[6] as String?,
      weather: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LooksListModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.items)
      ..writeByte(3)
      ..write(obj.imagePath)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.season)
      ..writeByte(7)
      ..write(obj.weather);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LooksListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
