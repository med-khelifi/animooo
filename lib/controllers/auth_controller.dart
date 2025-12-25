import 'dart:async';
import 'dart:io';
import 'package:animooo/core/enums/image_picker_state.dart';
import 'package:animooo/core/enums/password_rules.dart';
import 'package:animooo/core/resources/app_strings.dart';
import 'package:animooo/core/utils/utils.dart';
import 'package:animooo/core/widgets/bottom_sheets.dart';
import 'package:flutter/widgets.dart';

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

  late StreamController<(ImagePickerState state, File? imageFile)>
  imageStreamController;
  late Stream<(ImagePickerState state, File? imageFile)> imageStream;
  late Sink<(ImagePickerState state, File? imageFile)> imageSink;
  void _initControllers() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    firstNameController = TextEditingController();
    lastNamaController = TextEditingController();
    phoneController = TextEditingController();
  }

  void _initStreams() {
    passwordRulesStreamController = StreamController();
    passwordRulesSink = passwordRulesStreamController.sink;
    passwordRulesStream = passwordRulesStreamController.stream
        .asBroadcastStream();

    imageStreamController = StreamController();
    imageSink = imageStreamController.sink;
    imageStream = imageStreamController.stream.asBroadcastStream();
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

  late ImagePickerState _userImageState;
  File? _userImageFile;

  AuthController() {
    _initControllers();
    _initStreams();
    _userImageState = ImagePickerState.none;
  }

  String? validateFistName(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.firstNameIsRequired;
    }
    if (value.length < 3) {
      return AppStrings.firstNameIsMustBeAtLeast3Char;
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.lastNameIsRequired;
    }
    if (value.length < 3) {
      return AppStrings.lastNameIsMustBeAtLeast3Char;
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.phoneIsRequired;
    }
    if (!value.contains(RegExp(r'[0-9]')) ||
        value.contains(RegExp(r'[a-zA-Z]')) ||
        value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return AppStrings.phoneMustContainsOnlyDigits;
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emailIsRequired;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return AppStrings.enterAValidEmailAddress;
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordIsRequired;
    }
    if (value.length < 12) {
      return AppStrings.passwordMustBeAtLeast12Characters;
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return AppStrings.passwordMustContainAnUppercaseLetter;
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return AppStrings.passwordMustContainALowercaseLetter;
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return AppStrings.passwordMustContainANumber;
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return AppStrings.passwordMustContainASpecialCharacter;
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.confirmPasswordIsRequired;
    }
    if (value != passwordController.text) {
      return AppStrings.passwordsDoNotMatch;
    }
    return null;
  }

  void onPasswordChange(String value) {
    value = value.trim();
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
    if (_userImageState == ImagePickerState.none) {
      _userImageState = ImagePickerState.error;
    }
    if (_userImageState == ImagePickerState.error) {
      imageSink.add((ImagePickerState.error, null));
      return;
    }
    if (signupFormKey.currentState!.validate()) {
      // Proceed with signup
    }
  }

  void login() {
    if (loginFormKey.currentState!.validate()) {
      // Proceed with signup
    }
  }

  void onTakeImagePressed(BuildContext context) async {
    BottomSheets.showTakeImageBottomSheet(
      context,
      onTakeFromCameraPressed: () async {
        _userImageFile = await Utils.takeImageCamera();
        if (_userImageFile != null) {
          _userImageState = ImagePickerState.picked;
          imageSink.add((_userImageState, _userImageFile));
        }
      },
      onTakeFromGalleryPressed: () async {
        _userImageFile = await Utils.takeImageGallery();
        if (_userImageFile != null) {
          _userImageState = ImagePickerState.picked;
          imageSink.add((_userImageState, _userImageFile));
        }
      },
    );
  }
}
