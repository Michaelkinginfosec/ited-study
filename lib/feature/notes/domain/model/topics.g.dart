// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topics.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TopicsAdapter extends TypeAdapter<Topics> {
  @override
  final int typeId = 2;

  @override
  Topics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Topics(
      id: fields[0] as String,
      courseId: fields[1] as String,
      topic: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Topics obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.courseId)
      ..writeByte(2)
      ..write(obj.topic);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopicsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
