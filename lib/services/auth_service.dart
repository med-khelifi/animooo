import 'package:animooo/core/network/api_error.dart';
import 'package:animooo/core/network/api_service.dart';
import 'package:animooo/core/requests/login_request.dart';
import 'package:animooo/core/requests/otp_verification_code_request.dart';
import 'package:animooo/core/response/response.dart';
import 'package:animooo/core/requests/signup_request_model.dart';
import 'package:animooo/models/user_model.dart';

class AuthService {
  final ApiService _apiService;
  AuthService({required ApiService apiService}) : _apiService = apiService;

  Future<Response<UserModel>> register({
    required SignupRequestModel signupRequest,
  }) async {
    try {
      var result = await _apiService.post(
        endpoint: '/signup',
        data: await signupRequest.toFormData(),
      );
      if (result is ApiError) {
        return Response.failure(
          result
        );
      }
      // data section from response
      final data = result.data;

      if (data == null || data is! Map) {
        return Response.failure(ApiError(message: 'Invalid backend response'));
      }
      int code = int.tryParse(data["statusCode"].toString()) ?? 500;
      if (code < 200 || code > 299) {
        return Response.failure(
          ApiError(message: "Unknown backend error"),
        );
      }
      final alert = data["alert"].toString();
      // extract user data
      final userData = data["user"];

      if (userData == null || userData is! Map) {
        return Response.failure(ApiError(message: "Invalid user object"));
      }

      final user = UserModel.fromJson(userData as Map<String, dynamic>);

      return Response.success(user,alert: alert);
    } catch (e) {
      return Response.failure(ApiError(message: e.toString()));
    }
  }

  Future<Response<UserModel>> login({
    required LoginRequest loginRequest,
  }) async {
    try {
      var result = await _apiService.get(
        endpoint: '/login',
        queryParams: loginRequest.toJson(),
      );
      if (result is ApiError) {
        return Response.failure(
          result
        );
      }
      // data section from response
      final data = result.data;

      if (data == null || data is! Map) {
        return Response.failure(ApiError(message: 'Invalid backend response'));
      }
      int code = int.tryParse(data["statusCode"].toString()) ?? 500;
      if (code < 200 || code > 299) {
        return Response.failure(
          ApiError(message: data["message"] ?? "Unknown backend error"),
        );
      }
      final alert = data["alert"].toString();
      // extract user data
      final userData = data["user"];

      if (userData == null || userData is! Map) {
        return Response.failure(ApiError(message: "Invalid user object"));
      }

      final user = UserModel.fromJson(userData as Map<String, dynamic>);

      return Response.success(user,alert: alert);
    } catch (e) {
      return Response.failure(ApiError(message: e.toString()));
    }
  }Future<Response<UserModel>> otpVerification({
    required OtpVerificationCodeRequest otpRequest,
  }) async {
    try {
      var result = await _apiService.post(
        endpoint: '/verfication_code',
        data: otpRequest.toJson(),
      );
      if (result is ApiError) {
        return Response.failure(
          result
        );
      }
      // data section from response
      final data = result.data;

      if (data == null || data is! Map) {
        return Response.failure(ApiError(message: 'Invalid backend response'));
      }
      int code = int.tryParse(data["statusCode"].toString()) ?? 500;
      if (code < 200 || code > 299) {
        return Response.failure(
          ApiError(message:"Unknown backend error"),
        );
      }
      final message = data["message"].toString();
      // extract user data
      final userData = data["user"];

      if (userData == null || userData is! Map) {
        return Response.failure(ApiError(message: "Invalid user object"));
      }

      final user = UserModel.fromJson(userData as Map<String, dynamic>);

      return Response.success(user,alert: message);
    } catch (e) {
      return Response.failure(ApiError(message: e.toString()));
    }
  }
}
