// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'courses.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CoursesAdapter extends TypeAdapter<Courses> {
  @override
  final int typeId = 0;

  @override
  Courses read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Courses(
      id: fields[0] as String,
      courseName: fields[1] as String,
      courseTitle: fields[2] as String,
      courseCode: fields[3] as String,
      courseImage: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Courses obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.courseName)
      ..writeByte(2)
      ..write(obj.courseTitle)
      ..writeByte(3)
      ..write(obj.courseCode)
      ..writeByte(4)
      ..write(obj.courseImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoursesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
