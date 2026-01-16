// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_with_tokens_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserWithTokensModel _$UserWithTokensModelFromJson(Map<String, dynamic> json) =>
    UserWithTokensModel(
      json['access_token'] as String,
      json['refresh_token'] as String,
      UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserWithTokensModelToJson(
  UserWithTokensModel instance,
) => <String, dynamic>{
  'access_token': instance.accessToken,
  'refresh_token': instance.refreshToken,
  'user': instance.user.toJson(),
};
