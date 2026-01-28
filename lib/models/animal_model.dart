import 'package:json_annotation/json_annotation.dart';

part 'animal_model.g.dart';

@JsonSerializable()
class AnimalModel {
  @JsonKey(name: "animal_id")
  final int animalId;
  @JsonKey(name: "animal_name")
  final String animalName;
  @JsonKey(name: "animal_description")
  final String animalDescription;
  @JsonKey(name: "animal_image")
  final String animalImage;
  @JsonKey(name: "animal_price")
  final double animalPrice;
  @JsonKey(name: "category_id")
  final int categoryId;
  @JsonKey(name: "user_id")
  final int userId;
  @JsonKey(name: "animal_created_at")
  final DateTime animalCreatedAt;
  @JsonKey(name: "animal_update_at")
  final DateTime animalUpdatedAt;

  AnimalModel({
    required this.animalId,
    required this.animalName,
    required this.animalDescription,
    required this.animalImage,
    required this.animalPrice,
    required this.categoryId,
    required this.userId,
    required this.animalCreatedAt,
    required this.animalUpdatedAt,
  });

  factory AnimalModel.fromJson(Map<String, dynamic> json) =>
      _$AnimalModelFromJson(json);
  Map<String, dynamic> toJson() => _$AnimalModelToJson(this);
}
