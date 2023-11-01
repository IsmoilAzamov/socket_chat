import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void successToast(String s) {
  Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color(0xff00aa00),
      textColor: const Color(0xFFFFFFFF),
      fontSize: 16.0);
}

