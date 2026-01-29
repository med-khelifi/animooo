import 'package:dio/dio.dart';

class UpdateAnimalRequest {
  int id;
  String name;
  String description;
  String? image;
  double price;
  int categoryId;

  UpdateAnimalRequest({
    required this.id,
    required this.name,
    required this.description,
    this.image,
    required this.price,
    required this.categoryId,
  });

  Future<FormData> toFormData() async {
    final map = <String, dynamic>{
      "id": id,
      "name": name,
      "description": description,
      "price": price,
      "categoryId": categoryId,
    };

    // Only add image if it was changed
    if (image != null) {
      map["image"] = await MultipartFile.fromFile(
        image!,
        filename: image!.split('/').last,
      );
    }

    return FormData.fromMap(map);
  }
}
