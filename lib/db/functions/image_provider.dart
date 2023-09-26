import 'dart:io';
import 'package:flutter/material.dart';

class ImageProviders extends ChangeNotifier {
  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  void setSelectedImage(File? image) {
    _selectedImage = image;
    notifyListeners();
  }
}
