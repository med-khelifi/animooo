import 'package:animooo/views/auth/login_view.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      RoutesNames.login: (context) => const LoginView(),
      RoutesNames.signup: (context) => const Scaffold(),
    };
  }
}

class RoutesNames {
  static const String login = '/login';
  static const String signup = '/signup';
}
