import 'package:dio/dio.dart';

class UpdateCategoryRequest {
  final int id;
  final String name;
  final String description;
  final String? image;
  UpdateCategoryRequest({
    required this.id,
    required this.name,
    required this.description,
    this.image,
  });

  Future<FormData> toFormData() async {
    print("UpdateCategoryRequest: $this");
    FormData formData = FormData.fromMap({
      "id": id,
      "name": name,
      "description": description,
    });
    if (image != null) {
      formData.files.add(
        MapEntry("image", await MultipartFile.fromFile(image!)),
      );
    }
    return formData;
  }
}
