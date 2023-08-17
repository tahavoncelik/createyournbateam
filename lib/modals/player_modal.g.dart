// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerAdapter extends TypeAdapter<Player> {
  @override
  final int typeId = 1;

  @override
  Player read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Player(
      fields[0] as int?,
      fields[1] as String?,
      fields[2] as String?,
      fields[3] as String?,
      fields[4] as int?,
      fields[5] as int?,
      fields[6] as int?,
      fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Player obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.first_name)
      ..writeByte(2)
      ..write(obj.last_name)
      ..writeByte(3)
      ..write(obj.position)
      ..writeByte(4)
      ..write(obj.height_feet)
      ..writeByte(5)
      ..write(obj.height_inches)
      ..writeByte(6)
      ..write(obj.weight_pounds)
      ..writeByte(7)
      ..write(obj.abbreviation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
