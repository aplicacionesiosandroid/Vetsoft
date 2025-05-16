import 'package:flutter/material.dart';

class ImageModel extends ChangeNotifier {
  List<String> _images = [];

  List<String> get images => _images;

  void addImage(String imagePath) {
    _images.add(imagePath);
    notifyListeners();
  }
}
