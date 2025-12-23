import 'package:animooo/views/auth/create_new_password_view.dart';
import 'package:animooo/views/auth/forget_password_view.dart';
import 'package:animooo/views/auth/login_view.dart';
import 'package:animooo/views/auth/otp_verification_view.dart';
import 'package:animooo/views/auth/signup_view.dart';
import 'package:animooo/views/connection/no_internet_connection_view.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      RoutesNames.login: (context) => const LoginView(),
      RoutesNames.signup: (context) => const SignupView(),
      RoutesNames.forgetPassword: (context) => const ForgetPasswordView(),
      RoutesNames.createNewPassword: (context) => const CreateNewPasswordView(),
      RoutesNames.otpVerification: (context) => const OtpVerificationView(),
      RoutesNames.noInternetConnection: (context) => const NoInternetConnectionView(),
    };
  }
}

class RoutesNames {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgetPassword = '/forgetPassword';
  static const String createNewPassword = '/createNewPassword';
  static const String otpVerification = '/otpVerification';
  static const String noInternetConnection = '/noInternetConnection';
}
