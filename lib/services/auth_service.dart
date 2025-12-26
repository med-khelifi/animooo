import 'package:animooo/core/network/api_service.dart';
import 'package:animooo/models/signup_request_model.dart';
import 'package:animooo/models/user_model.dart';

class AuthService {
  ApiService service = ApiService();

  Future<UserModel> signup(SignupRequestModel userData) {
    try {
      final response = service.post(
      endpoint: '/auth/signup',
      data: userData.toFormData(),
    );
    } catch (e) {
      rethrow;
    }
  }
}
