import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

errorToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color(0xffaa4433),
      textColor: const Color(0xFFFFFFFF),
      fontSize: 16.0);
}
