import 'package:animooo/views/auth/create_new_password_view.dart';
import 'package:animooo/views/auth/forget_password_view.dart';
import 'package:animooo/views/auth/login_view.dart';
import 'package:animooo/views/auth/otp_verification_view.dart';
import 'package:animooo/views/auth/signup_view.dart';
import 'package:animooo/views/connection/no_internet_connection_view.dart';
import 'package:animooo/views/main/main.dart';
import 'package:animooo/views/splash_view.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case RoutesNames.login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case RoutesNames.signup:
        return MaterialPageRoute(builder: (_) => const SignupView());

      case RoutesNames.forgetPassword:
        return MaterialPageRoute(builder: (_) => const ForgetPasswordView());

      case RoutesNames.createNewPassword:
        return MaterialPageRoute(builder: (_) => const CreateNewPasswordView());

      case RoutesNames.otpVerification:
        return MaterialPageRoute(builder: (_) => const OtpVerificationView());

      case RoutesNames.noInternetConnection:
        return MaterialPageRoute(
          builder: (_) => const NoInternetConnectionView(),
        );

      case RoutesNames.main:
        return MaterialPageRoute(builder: (_) => const Main());

      default:
        return _undefinedRoute();
    }
  }

  static Route<dynamic> _undefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(
          child: Text('Route not found', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}

class RoutesNames {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgetPassword = '/forgetPassword';
  static const String createNewPassword = '/createNewPassword';
  static const String otpVerification = '/otpVerification';
  static const String noInternetConnection = '/noInternetConnection';
  static const String main = '/main';
}
