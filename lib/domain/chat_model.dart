class MessageModel {
  final String message;
  final String time;
  bool isMe;
  bool isRead;

   MessageModel({required this.message, required this.time, required this.isMe, required this.isRead});
}
