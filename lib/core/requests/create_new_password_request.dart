class CreateNewPasswordRequest {
  String email;
  String password;
  String confirmPassword;

  CreateNewPasswordRequest({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "confirmPassword": confirmPassword,
  };
  factory CreateNewPasswordRequest.fromJson(Map<String, dynamic> json) =>
      CreateNewPasswordRequest(
        email: json["email"],
        password: json["password"],
        confirmPassword: json["confirmPassword"],
      );
}
