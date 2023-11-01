import 'package:flutter/material.dart';


class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  void close(BuildContext context) {
    Navigator.of(context).pop();
  }

  void show(BuildContext context) {
    showDialog(
      barrierColor: Colors.black.withOpacity(0.2),
      context: context,
      barrierDismissible: false,
      builder: (context) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xffffffff),
      shadowColor: Colors.black.withOpacity(0.6),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.only(bottom: 400, left: 30, right: 30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
                color: Colors.lightBlue,
                strokeWidth: 3,
              ),
            ),
            SizedBox(width: 24),
            Text(
              "Loading...",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
