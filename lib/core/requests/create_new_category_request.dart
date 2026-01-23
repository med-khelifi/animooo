import 'package:dio/dio.dart';

class CreateNewCategoryRequest {
  String name;
  String description;
  String image;
  CreateNewCategoryRequest({
    required this.name,
    required this.description,
    required this.image,
  });

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      "name": name,
      "description": description,
      "image": await MultipartFile.fromFile(
        image,
        filename: image.split('/').last,
      ),
    });
  }
}
