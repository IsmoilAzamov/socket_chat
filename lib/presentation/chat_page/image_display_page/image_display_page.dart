import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageDisplayScreen extends StatelessWidget {
  final Uint8List imageFile;

  const ImageDisplayScreen({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffffbb00),
        title: const Text('Image Display'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Center(
        child: Image.memory(imageFile),
      ),
    );
  }
}
