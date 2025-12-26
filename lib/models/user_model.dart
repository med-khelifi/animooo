import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';
@JsonSerializable() 
class UserModel {
  int id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String imagePath;
  String isValid;
  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.imagePath,
    required this.isValid,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
