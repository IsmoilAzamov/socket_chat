// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageModelAdapter extends TypeAdapter<MessageModel> {
  @override
  final int typeId = 0;

  @override
  MessageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageModel(
      message: fields[0] as String,
      time: fields[1] as String,
      isMe: fields[2] as bool,
      isRead: fields[3] as bool,
      isPhoto: fields[4] as bool,
      isSelected: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MessageModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.message)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.isMe)
      ..writeByte(3)
      ..write(obj.isRead)
      ..writeByte(4)
      ..write(obj.isPhoto)
      ..writeByte(5)
      ..write(obj.isSelected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
