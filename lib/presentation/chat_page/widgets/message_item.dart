import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../common/utils/hh_mm_time_util.dart';
import '../../../domain/chat_model.dart';
import '../image_display_page/image_display_page.dart';

Widget messageItem({required BuildContext context, required double size, required MessageModel message}) {
  bool isMe = message.isMe;
  String time = message.time;
  String text = message.message;
  if (text == '') {
    return Container();
  }
  if (message.isPhoto) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ImageDisplayScreen(
                  imageFile: Uint8List.fromList(base64Decode(text)),
                )));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: size, minWidth: size * 0.3),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
            decoration: BoxDecoration(
              color: const Color(0x88224433),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.memory(
                  Uint8List.fromList(base64Decode(text)),
                  width: size,
                  fit: BoxFit.cover,
                ),
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
      ),
    );
  } else if (isMe) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IntrinsicWidth(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: size,
              minWidth: size * 0.3,
            ),
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xbb1199aa),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(top: 4),
                    child: Text(hhMM(time), style: const TextStyle(color: Colors.black45, fontWeight: FontWeight.w500, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  } else {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicWidth(

          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: size,
              minWidth: size * 0.3,
            ),
            child: Container(

              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xffffbb00),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(text,maxLines: 100, style: const TextStyle(color: Colors.black, fontSize: 16)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: Text(hhMM(time), style: const TextStyle(color: Colors.white70,  fontSize: 12, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
