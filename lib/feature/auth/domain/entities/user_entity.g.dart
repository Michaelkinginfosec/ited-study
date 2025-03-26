// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserEntityAdapter extends TypeAdapter<UserEntity> {
  @override
  final int typeId = 1;

  @override
  UserEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserEntity(
      fullName: fields[0] as String,
      email: fields[1] as String,
      department: fields[2] as String,
      level: fields[3] as String,
      password: fields[4] as String,
      verified: fields[5] as bool,
      schoolId: fields[6] as String,
      activated: fields[7] as bool,
      semester: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserEntity obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.fullName)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.department)
      ..writeByte(3)
      ..write(obj.level)
      ..writeByte(4)
      ..write(obj.password)
      ..writeByte(5)
      ..write(obj.verified)
      ..writeByte(6)
      ..write(obj.schoolId)
      ..writeByte(7)
      ..write(obj.activated)
      ..writeByte(8)
      ..write(obj.semester);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
