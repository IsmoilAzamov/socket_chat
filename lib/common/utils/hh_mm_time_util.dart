
String hhMM(String time) {
  DateTime dateTime = DateTime.parse(time);
  String hour = dateTime.hour.toString();
  String minute = dateTime.minute.toString();
  if (hour.length == 1) {
    hour = '0$hour';
  }
  if (minute.length == 1) {
    minute = '0$minute';
  }
  return '$hour:$minute';
}
