import 'package:animooo/controllers/auth_controller.dart';
import 'package:animooo/core/enums/image_picker_state.dart';
import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/resources/app_strings.dart';
import 'package:animooo/core/widgets/custom_button.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:animooo/core/widgets/named_app_logo.dart';
import 'package:animooo/views/auth/widgets/custom_clickable_text.dart';
import 'package:animooo/core/widgets/custom_text_form_field.dart';
import 'package:animooo/views/auth/widgets/handel_image_ui.dart';
import 'package:animooo/views/auth/widgets/password_rules_list.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  late AuthController _authController;
  @override
  void initState() {
    super.initState();
    _authController = AuthController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.pw10),
            child: Form(
              key: _authController.signupFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  NamedAppLogo(),
                  Gap(AppHeight.h30),
                  CustomText(
                    text: AppStrings.signup,
                    fontSize: AppFontSize.f38,
                    fontFamily: AppFonts.otamaEp,
                    color: AppColors.blackColor,
                  ),
                  Gap(AppHeight.h10),
                  CustomTextFormField(
                    label: AppStrings.firstName,
                    hint: AppStrings.enterYourFirstName,
                    controller: _authController.firstNameController,
                    validator: _authController.validateFistName,
                  ),
                  Gap(AppHeight.h16),
                  CustomTextFormField(
                    label: AppStrings.lastName,
                    hint: AppStrings.enterYourLastName,
                    controller: _authController.lastNamaController,
                    validator: _authController.validateLastName,
                  ),
                  Gap(AppHeight.h16),
                  CustomTextFormField(
                    label: AppStrings.email,
                    hint: AppStrings.enterYourEmailAddress,
                    controller: _authController.emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: _authController.validateEmail,
                  ),
                  Gap(AppHeight.h16),
                  CustomTextFormField(
                    label: AppStrings.phone,
                    hint: AppStrings.enterYourPhone,
                    controller: _authController.phoneController,
                    keyboardType: TextInputType.phone,
                    validator: _authController.validatePhone,
                  ),
                  Gap(AppHeight.h16),
                  CustomTextFormField(
                    label: AppStrings.password,
                    hint: AppStrings.enterYourPassword,
                    controller: _authController.passwordController,
                    onChange: _authController.onPasswordChange,
                    isPassword: true,
                  ),
                  Gap(AppHeight.h8),
                  StreamBuilder(
                    stream: _authController.passwordRulesStream,
                    builder: (context, asyncSnapshot) {
                      return PasswordRulesList(
                        passwordRules:
                            asyncSnapshot.data ??
                            _authController.passwordRulesStatus,
                      );
                    },
                  ),
                  Gap(AppHeight.h16),
                  CustomTextFormField(
                    label: AppStrings.confirmPassword,
                    hint: AppStrings.confirmYourPassword,
                    controller: _authController.confirmPasswordController,
                    validator: _authController.validateConfirmPassword,
                    isPassword: true,
                  ),
                  Gap(AppHeight.h16),
                  Align(
                    alignment: AlignmentGeometry.centerLeft,
                    child: CustomText(
                      text: AppStrings.uploadImageForYourProfile,
                      fontFamily: AppFonts.poppins,
                      fontSize: AppFontSize.f16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                    ),
                  ),
                  Gap(AppHeight.h8),
                  StreamBuilder(
                    stream: _authController.imageStream,
                    builder: (context, asyncSnapshot) {
                      return HandelImageUi(
                        onTap: () =>
                            _authController.onTakeImagePressed(context),
                        imageState:
                            asyncSnapshot.data?.$1 ?? ImagePickerState.none,
                        file: asyncSnapshot.data?.$2,
                      );
                    },
                  ),
                  Gap(AppHeight.h28),
                  CustomButton(
                    text: AppStrings.signup,
                    onPressed:() => _authController.signup(context: context)
                  ),
                  Gap(AppHeight.h8),
                  CustomClickableText(
                    text: AppStrings.haveAnAccountAlready,
                    clickableText: AppStrings.login,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Gap(AppHeight.h20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
