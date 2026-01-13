import 'package:animooo/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_with_tokens_model.g.dart';

@JsonSerializable()
class UserWithTokensModel {
  @JsonKey(name: "access_token")
  late String accessToken;
  @JsonKey(name: "refresh_token")
  late String refreshToken;
  @JsonKey(name: "user")
  late UserModel user;
  UserWithTokensModel(this.accessToken, this.refreshToken, this.user);
  factory UserWithTokensModel.fromJson(Map<String, dynamic> json) =>
      _$UserWithTokensModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserWithTokensModelToJson(this);
}
