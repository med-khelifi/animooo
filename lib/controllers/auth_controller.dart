import 'dart:async';

import 'package:animooo/core/resources/app_strings.dart';
import 'package:flutter/widgets.dart';

enum PasswordRules { minLength, uppercase, lowercase, digit, specialChar }

class AuthController {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late TextEditingController firstNameController;
  late TextEditingController lastNamaController;
  late TextEditingController phoneController;
  late StreamController<Map<PasswordRules, (String rule, bool isValid)>>
  passwordRulesStreamController;
  late Stream<Map<PasswordRules, (String rule, bool isValid)>>
  passwordRulesStream;
  late Sink<Map<PasswordRules, (String rule, bool isValid)>> passwordRulesSink;
  void _initControllers() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    firstNameController = TextEditingController();
    lastNamaController = TextEditingController();
    phoneController = TextEditingController();
  }

  Map<PasswordRules, (String rule, bool isValid)> passwordRulesStatus = {
    PasswordRules.minLength: (AppStrings.minimumCharacter12, false),
    PasswordRules.uppercase: (AppStrings.oneUppercaseCharacter, false),
    PasswordRules.lowercase: (AppStrings.oneLowercaseCharacter, false),
    PasswordRules.digit: (AppStrings.oneNumber, false),
    PasswordRules.specialChar: (AppStrings.oneSpecialCharacter, false),
  };

  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  AuthController() {
    _initControllers();
    passwordRulesStreamController = StreamController();
    passwordRulesSink = passwordRulesStreamController.sink;
    passwordRulesStream = passwordRulesStreamController.stream;
  }

  String? validateFistName(String? value) {
    if (value == null || value.isEmpty) {
      return 'First name is required';
    }
    if (value.length < 3) {
      return 'First name is must be at least 3 characters';
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Last name is required';
    }
    if (value.length < 3) {
      return 'Last name is must be at least 3 characters';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!value.contains(RegExp(r'[0-9]')) ||
        value.contains(RegExp(r'[a-zA-Z]')) ||
        value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Phone number must contain only digits';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 12) {
      return 'Password must be at least 12 characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain an uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain a lowercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain a number';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain a special character';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void onPasswordChange(String value) {
    passwordRulesStatus.updateAll((key, ruleStatus) {
      switch (key) {
        case PasswordRules.minLength:
          return (ruleStatus.$1, value.length >= 12);
        case PasswordRules.uppercase:
          return (ruleStatus.$1, value.contains(RegExp(r'[A-Z]')));
        case PasswordRules.lowercase:
          return (ruleStatus.$1, value.contains(RegExp(r'[a-z]')));
        case PasswordRules.digit:
          return (ruleStatus.$1, value.contains(RegExp(r'[0-9]')));
        case PasswordRules.specialChar:
          return (
            ruleStatus.$1,
            value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
          );
      }
    });
    passwordRulesSink.add(passwordRulesStatus);
  }

  void signup() {
    if (signupFormKey.currentState!.validate()) {
      // Proceed with signup
    }
  }

  void login() {
if (loginFormKey.currentState!.validate()) {
      // Proceed with signup
    }
  }
}
