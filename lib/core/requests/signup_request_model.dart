import 'package:dio/dio.dart';

class SignupRequestModel {
  String firstName;
  String lastName;
  String email;
  String phone;
  String image;
  String password;
  SignupRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.image,
    required this.password,
  });

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phone": phone,
      "password": password,
      "image": await MultipartFile.fromFile(
        image,
        filename: image.split('/').last,
      ),
    });
  }
}
