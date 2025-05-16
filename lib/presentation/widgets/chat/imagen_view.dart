import 'package:flutter/material.dart';
import 'dart:io';

class ImageViewScreen extends StatelessWidget {
  final String imagePath;

  ImageViewScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vista de Imagen'),
      ),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}
