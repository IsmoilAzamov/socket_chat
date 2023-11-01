import 'package:hive/hive.dart';
part 'chat_model.g.dart';

@HiveType(typeId: 0)
class MessageModel extends HiveObject{
  @HiveField(0)
  final String message;
  @HiveField(1)
  final String time;
  @HiveField(2)
  bool isMe;
  @HiveField(3)
  bool isRead;
  @HiveField(4)
  bool isPhoto;
  @HiveField(5)
  bool isSelected;


   MessageModel({required this.message, required this.time, required this.isMe, required this.isRead, required this.isPhoto, required this.isSelected});
}
