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
      case '/':
        return _build(settings, const SplashView());

      case '/login':
        return _build(settings, const LoginView());

      case '/signup':
        return _build(settings, const SignupView());

      case '/forgetPassword':
        return _build(settings, const ForgetPasswordView());

      case '/createNewPassword':
        return _build(settings, const CreateNewPasswordView());

      case '/otpVerification':
        return _build(settings, const OtpVerificationView());

      case '/noInternetConnection':
        return _build(settings, const NoInternetConnectionView());

      case '/main':
        return _build(settings, const Main());

      default:
        return _undefinedRoute();
    }
  }

  static MaterialPageRoute _build(RouteSettings settings, Widget page) {
    return MaterialPageRoute(settings: settings, builder: (_) => page);
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

enum RoutesNames {
  splash('/'),
  login('/login'),
  signup('/signup'),
  forgetPassword('/forgetPassword'),
  createNewPassword('/createNewPassword'),
  otpVerification('/otpVerification'),
  noInternetConnection('/noInternetConnection'),
  main('/main'),
  mainHomeAllCategories('/main/home/allCategories');

  final String route;
  const RoutesNames(this.route);
}
