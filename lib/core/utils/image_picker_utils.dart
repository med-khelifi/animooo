import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerUtils {
  static Future<File?> _takeImage(ImageSource source) async {
    XFile? imageFile = await ImagePicker().pickImage(source: source);
    if (imageFile == null) {
      return null;
    }
    return File(imageFile.path);
  }

  static Future<File?> takeImageCamera() async =>
      await _takeImage(ImageSource.camera);
  static Future<File?> takeImageGallery() async =>
      await _takeImage(ImageSource.gallery);
}
