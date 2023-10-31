import 'package:flutter/material.dart';

import '../../../common/utils/hh_mm_time_util.dart';
import '../../../domain/chat_model.dart';
import '../chat_page.dart';

Widget messageItem({required double size, required MessageModel message}) {
  bool isMe = message.isMe;
  String time = message.time;
  String text = message.message;
  if (text == '') {
    return Container();
  }

  if (isMe) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: size,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          decoration: BoxDecoration(
            color: const Color(0x88224433),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(top: 6),
                  child: Text(hhMM(time), style: const TextStyle(color: Colors.black, fontSize: 12)),
                ),
              ),
            ],
          ),
        )
      ],
    );
  } else {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: size,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          decoration: BoxDecoration(
            color: const Color(0xffffbb00),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text, style: const TextStyle(color: Colors.black, fontSize: 16)),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(top: 6),
                  child: Text(hhMM(time), style: const TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
