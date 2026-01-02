
import 'package:animooo/core/network/api_error.dart';

class Response<T> {
  final T? data;
  final ApiError? error;
  final String? alert;

  Response._({this.data, this.error,this.alert});

  factory Response.success(T data,{String? alert}) => Response._(data: data,alert: alert);
  factory Response.failure(ApiError error) => Response._(error: error);

  bool get isSuccess => data != null;
  bool get isFailure => error != null;
}