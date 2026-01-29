import 'package:dio/dio.dart';

class CreateNewAnimalRequest {
  String name;
  String description;
  String image;
  double price;
  int categoryId;

  CreateNewAnimalRequest({
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.categoryId,
  });

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      "name": name,
      "description": description,
      "price": price,
      "categoryId": categoryId,
      "image": await MultipartFile.fromFile(
        image,
        filename: image.split('/').last,
      ),
    });
  }
}
