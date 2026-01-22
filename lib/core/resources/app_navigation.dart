import 'package:animooo/core/resources/app_routes.dart';
import 'package:flutter/material.dart';

class AppNavigation {
  // Global navigator key
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // Push
  static Future<dynamic>? push(RoutesNames route, {Object? arguments}) {
    return navigatorKey.currentState?.pushNamed(
      route.route,
      arguments: arguments,
    );
  }

  // Replace current
  static Future<dynamic>? pushReplacement(
    RoutesNames route, {
    Object? arguments,
  }) {
    return navigatorKey.currentState?.pushReplacementNamed(
      route.route,
      arguments: arguments,
    );
  }

  // Remove all previous routes
  static Future<dynamic>? pushAndRemoveUntil(RoutesNames route) {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
      route.route,
      (route) => false,
    );
  }

  // Go back
  static void pop([Object? result]) {
    navigatorKey.currentState?.pop(result);
  }

  // Can pop?
  static bool canPop() {
    return navigatorKey.currentState?.canPop() ?? false;
  }
}
