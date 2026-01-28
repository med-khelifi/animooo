// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnimalModel _$AnimalModelFromJson(Map<String, dynamic> json) => AnimalModel(
  animalId: (json['animal_id'] as num).toInt(),
  animalName: json['animal_name'] as String,
  animalDescription: json['animal_description'] as String,
  animalImage: json['animal_image'] as String,
  animalPrice: (json['animal_price'] as num).toDouble(),
  categoryId: (json['category_id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  animalCreatedAt: DateTime.parse(json['animal_created_at'] as String),
  animalUpdatedAt: DateTime.parse(json['animal_update_at'] as String),
);

Map<String, dynamic> _$AnimalModelToJson(AnimalModel instance) =>
    <String, dynamic>{
      'animal_id': instance.animalId,
      'animal_name': instance.animalName,
      'animal_description': instance.animalDescription,
      'animal_image': instance.animalImage,
      'animal_price': instance.animalPrice,
      'category_id': instance.categoryId,
      'user_id': instance.userId,
      'animal_created_at': instance.animalCreatedAt.toIso8601String(),
      'animal_update_at': instance.animalUpdatedAt.toIso8601String(),
    };
