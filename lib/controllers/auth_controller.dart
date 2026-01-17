import 'dart:async';
import 'dart:io';
import 'package:animooo/core/di/injection.dart';
import 'package:animooo/core/enums/buttons_loading_keys.dart';
import 'package:animooo/core/enums/image_picker_state.dart';
import 'package:animooo/core/enums/otp_flow.dart';
import 'package:animooo/core/enums/password_rules.dart';
import 'package:animooo/core/requests/create_new_password_request.dart';
import 'package:animooo/core/requests/login_request.dart';
import 'package:animooo/core/requests/otp_verification_code_request.dart';
import 'package:animooo/core/requests/signup_request_model.dart';
import 'package:animooo/core/resources/app_routes.dart';
import 'package:animooo/core/resources/app_strings.dart';
import 'package:animooo/core/utils/image_picker_utils.dart';
import 'package:animooo/core/widgets/app_snackbar.dart';
import 'package:animooo/core/widgets/bottom_sheets.dart';
import 'package:animooo/services/auth_service.dart';
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

  late StreamController<int> otpCounterStreamController;
  late Stream<int> otpCounterStream;
  late Sink<int> otpCounterSink;
  late StreamController<Map<ButtonsLoadingKeys, bool>>
  loadingMapStreamController;
  late Stream<Map<ButtonsLoadingKeys, bool>> loadingMapStream;
  late Sink<Map<ButtonsLoadingKeys, bool>> loadingMapSink;
  final Map<ButtonsLoadingKeys, bool> _loadingButtonsStatus = {
    ButtonsLoadingKeys.login: false,
    ButtonsLoadingKeys.signup: false,
    ButtonsLoadingKeys.sendCode: false,
    ButtonsLoadingKeys.confirmCode: false,
    ButtonsLoadingKeys.createNewPassword: false,
    ButtonsLoadingKeys.resendCode: false,
  };

  void _setLoading(ButtonsLoadingKeys key, bool status) {
    _loadingButtonsStatus[key] = status;
    loadingMapSink.add(_loadingButtonsStatus);
  }


  late String _otpCode;

  void _initControllers() {
    emailController = TextEditingController(text: "khelifim440@gmail.com");
    passwordController = TextEditingController(text: "Password@1234");
    confirmPasswordController = TextEditingController(text: "Password@1234");
    firstNameController = TextEditingController(text: "Khelifi");
    lastNamaController = TextEditingController(text: "Mohamed");
    phoneController = TextEditingController(text: "01234567890");
  }

  void _initStreams() {
    loadingMapStreamController = StreamController();
    loadingMapStream = loadingMapStreamController.stream.asBroadcastStream();
    loadingMapSink = loadingMapStreamController.sink;
    passwordRulesStreamController = StreamController();
    passwordRulesSink = passwordRulesStreamController.sink;
    passwordRulesStream = passwordRulesStreamController.stream
        .asBroadcastStream();

    imageStreamController = StreamController();
    imageSink = imageStreamController.sink;
    imageStream = imageStreamController.stream.asBroadcastStream();
    otpCounterStreamController = StreamController.broadcast();
    otpCounterStream = otpCounterStreamController.stream;
    otpCounterSink = otpCounterStreamController.sink;
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
  GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> createNewPasswordFormKey = GlobalKey<FormState>();

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

  void signup({required BuildContext context}) async {
    if (_loadingButtonsStatus[ButtonsLoadingKeys.signup] == true) {
      return;
    }
    if (_userImageState == ImagePickerState.none) {
      _userImageState = ImagePickerState.error;
    }
    if (_userImageState == ImagePickerState.error) {
      imageSink.add((ImagePickerState.error, null));
      return;
    }
    if (signupFormKey.currentState!.validate() &&
        passwordRulesStatus.values.every((element) => element.$2)) {
      final authService = services<AuthService>();
      _setLoading(ButtonsLoadingKeys.signup, true);
      final res = await authService.register(
        signupRequest: SignupRequestModel(
          firstName: firstNameController.text.trim(),
          lastName: lastNamaController.text.trim(),
          email: emailController.text.trim(),
          phone: phoneController.text.trim(),
          image: _userImageFile!.path,
          password: passwordController.text.trim(),
        ),
      );
      _setLoading(ButtonsLoadingKeys.signup, false);
      if (res.isSuccess) {
        AppSnackBar.showSuccess(
          context,
          message:
              res.alert ??
              "signup successfully, please check your email for verification",
        );
        Navigator.pushNamed(
          context,
          RoutesNames.otpVerification,
          arguments: {
            "email": emailController.text.trim(),
            "otpFlow": OtpFlow.emailVerification,
          },
        );
      } else {
        String? message = res.error?.errors?.join('\n') ?? res.error?.message;
        AppSnackBar.showError(context, message: message ?? "error");
      }
    }
  }

  void login(BuildContext context) async {
    if (_loadingButtonsStatus[ButtonsLoadingKeys.login] == true) {
      return;
    }
    if (loginFormKey.currentState!.validate()) {
      final authService = services<AuthService>();
      _setLoading(ButtonsLoadingKeys.login, true);
      final res = await authService.login(
        loginRequest: LoginRequest(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        ),
      );
      if (res.isSuccess) {
        AppSnackBar.showSuccess(context, message: "go to main");
      } else {
        String message =
            res.error?.errors?.join('\n') ?? res.error?.message ?? "error";
        if (message.contains("Account not verified")) {
          final res = await authService.resendNewOtpCode(
            email: emailController.text.trim(),
          );
          if (res.isSuccess) {
            AppSnackBar.showSuccess(
              context,
              message:
                  res.alert ??
                  "Account not verified, verification code send to your email",
            );
            Navigator.pushNamed(
              context,
              RoutesNames.otpVerification,
              arguments: {
                "email": emailController.text.trim(),
                "otpFlow": OtpFlow.emailVerification,
              },
            );
          } else {
            String? message =
                res.error?.errors?.join('\n') ?? res.error?.message;
            AppSnackBar.showError(context, message: message ?? "error");
          }
        } else {
          AppSnackBar.showError(context, message: message);
        }
      }
      _setLoading(ButtonsLoadingKeys.login, false);
    }
  }

  void onTakeImagePressed(BuildContext context) async {
    BottomSheets.showTakeImageBottomSheet(
      context,
      onTakeFromCameraPressed: () async {
        _userImageFile = await ImagePickerUtils.takeImageCamera();
        if (_userImageFile != null) {
          _userImageState = ImagePickerState.picked;
          imageSink.add((_userImageState, _userImageFile));
        }
      },
      onTakeFromGalleryPressed: () async {
        _userImageFile = await ImagePickerUtils.takeImageGallery();
        if (_userImageFile != null) {
          _userImageState = ImagePickerState.picked;
          imageSink.add((_userImageState, _userImageFile));
        }
      },
    );
  }

  void dispose() {
    emailController?.dispose();
    passwordController?.dispose();
    confirmPasswordController?.dispose();
    firstNameController?.dispose();
    lastNamaController?.dispose();
    phoneController?.dispose();
    passwordRulesStreamController?.close();
    imageStreamController?.close();
    passwordRulesStreamController?.close();
    otpCounterStreamController?.close();
    loadingMapStreamController?.close();
  }

  String? validateOtpCode(String? value) {
    if (value == null) {
      return "please enter otp code";
    } else if (!value.contains(RegExp(r'^[0-9]+$'))) {
      return "only numbers allowed";
    }

    return null;
  }

  void startResendCodeTimer() {
    int counter = 30;
      Timer.periodic(Duration(seconds: 1), (timer) {
      otpCounterSink.add(counter);
      counter--;
      if (counter < 0) {
        timer.cancel();
      }
    });
  }

  Future<void> verifyOtpCode(
    BuildContext context,
    String email,
    OtpFlow otpFlow,
  ) async {
    if (_loadingButtonsStatus[ButtonsLoadingKeys.confirmCode] == true) {
      return;
    }
    final authService = services<AuthService>();
    _setLoading(ButtonsLoadingKeys.confirmCode, true);
    final res = await authService.otpVerification(
      otpRequest: OtpVerificationCodeRequest(email: email, code: _otpCode),
    );
    _setLoading(ButtonsLoadingKeys.confirmCode, false);
    if (res.isSuccess) {
      AppSnackBar.showSuccess(
        context,
        message: res.alert ?? "verification succeeded",
      );
      if (otpFlow == OtpFlow.emailVerification) {
        Navigator.pushNamed(context, RoutesNames.login);
      } else {
        Navigator.pushNamed(
          context,
          RoutesNames.createNewPassword,
          arguments: {"email": email},
        );
      }
    } else {
      String? message = res.error?.errors?.join('\n') ?? res.error?.message;
      AppSnackBar.showError(context, message: message ?? "error");
    }
  }

  Future<void> resendOtpCode(
    BuildContext context,
    String email, {
    bool restartTimer = false,
  }) async {
    if (_loadingButtonsStatus[ButtonsLoadingKeys.resendCode] == true) {
      return;
    }
    final authService = services<AuthService>();
    _setLoading(ButtonsLoadingKeys.resendCode, true);
    final res = await authService.resendNewOtpCode(email: email);
    _setLoading(ButtonsLoadingKeys.resendCode, false);
    if (res.isSuccess) {
      AppSnackBar.showSuccess(
        context,
        message: res.alert ?? "verification code send",
      );
      if (restartTimer) {
        startResendCodeTimer();
      }
    } else {
      String? message = res.error?.errors?.join('\n') ?? res.error?.message;
      AppSnackBar.showError(context, message: message ?? "error");
    }
  }

  void onOtpCodeSubmitted(String value) {
    _otpCode = value;
  }

  void forgetPassword({required BuildContext context}) async {
    if (_loadingButtonsStatus[ButtonsLoadingKeys.sendCode] == true) {
      return;
    }
    if (forgetPasswordFormKey.currentState?.validate() == true) {
      final authService = services<AuthService>();
      _setLoading(ButtonsLoadingKeys.sendCode, true);
      final res = await authService.forgetPassword(
        email: emailController.text.trim(),
      );
      _setLoading(ButtonsLoadingKeys.sendCode, false);
      if (res.isSuccess) {
        Navigator.pushNamed(
          context,
          RoutesNames.otpVerification,
          arguments: {
            "email": emailController.text.trim(),
            "otpFlow": OtpFlow.forgetPassword,
          },
        );
      } else {
        String? message = res.error?.errors?.join('\n') ?? res.error?.message;
        AppSnackBar.showError(context, message: message ?? "error");
      }
    }
  }

  void createNewPassword({
    required BuildContext context,
    required String email,
  }) async {
    if (_loadingButtonsStatus[ButtonsLoadingKeys.createNewPassword] == true) {
      return;
    }
    if (createNewPasswordFormKey.currentState?.validate() == true   &&
        passwordRulesStatus.values.every((element) => element.$2)) {
      final authService = services<AuthService>();
      _setLoading(ButtonsLoadingKeys.createNewPassword, true);
      final res = await authService.createNewPassword(
        createNewPasswordRequest: CreateNewPasswordRequest(
          email: email,
          password: passwordController.text.trim(),
          confirmPassword: confirmPasswordController.text.trim(),
        ),
      );
      _setLoading(ButtonsLoadingKeys.createNewPassword, false);
      if (res.isSuccess) {
        AppSnackBar.showSuccess(
          context,
          message: res.alert ?? "password updated",
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesNames.login,
          (route) => false,
        );
      } else {
        String? message = res.error?.errors?.join('\n') ?? res.error?.message;
        AppSnackBar.showError(context, message: message ?? "error");
      }
    }
  }
}
