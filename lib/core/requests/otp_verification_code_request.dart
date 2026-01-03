class OtpVerificationCodeRequest {
  final String  email;
  final String code;

  OtpVerificationCodeRequest({required this.email,required this.code});
  Map<String, dynamic> toJson(){
    return{
      "email" : email,
      "code" : code
    };
  }
}