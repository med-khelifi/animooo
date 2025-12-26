class ApiError {
  final int? statusCode;
  final List<String>? errors;
  final String? message;

  ApiError({this.statusCode, this.errors,this.message});
}