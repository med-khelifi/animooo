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
    if (settings.name == RoutesNames.splash.route) {
      return MaterialPageRoute(builder: (_) => const SplashView());
    } else if (settings.name == RoutesNames.login.route) {
      return MaterialPageRoute(builder: (_) => const LoginView());
    } else if (settings.name == RoutesNames.signup.route) {
      return MaterialPageRoute(builder: (_) => const SignupView());
    } else if (settings.name == RoutesNames.forgetPassword.route) {
      return MaterialPageRoute(builder: (_) => const ForgetPasswordView());
    } else if (settings.name == RoutesNames.createNewPassword.route) {
      return MaterialPageRoute(builder: (_) => const CreateNewPasswordView());
    } else if (settings.name == RoutesNames.otpVerification.route) {
      return MaterialPageRoute(builder: (_) => const OtpVerificationView());
    } else if (settings.name == RoutesNames.noInternetConnection.route) {
      return MaterialPageRoute(
        builder: (_) => const NoInternetConnectionView(),
      );
    } else if (settings.name == RoutesNames.main.route) {
      return MaterialPageRoute(builder: (_) => const Main());
    } else {
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
