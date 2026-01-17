import 'package:animooo/controllers/auth_controller.dart';
import 'package:animooo/core/enums/buttons_loading_keys.dart';
import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/resources/app_strings.dart';
import 'package:animooo/core/widgets/custom_button.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:animooo/core/widgets/custom_text_form_field.dart';
import 'package:animooo/views/auth/widgets/create_new_password_app_bar.dart';
import 'package:animooo/views/auth/widgets/password_rules_list.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CreateNewPasswordView extends StatefulWidget {
  const CreateNewPasswordView({super.key});

  @override
  State<CreateNewPasswordView> createState() => _CreateNewPasswordViewState();
}

class _CreateNewPasswordViewState extends State<CreateNewPasswordView> {
  late AuthController _authController;
  late String _email;
  @override
  void initState() {
    super.initState();
    _authController = AuthController();
  }

  @override
  void dispose() {
    _authController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _email = args?["email"] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CreateNewPasswordAppBar(),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.pw10),
            child: Form(
              key: _authController.createNewPasswordFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: AppStrings.createNewPassword,
                    fontFamily: AppFonts.otamaEp,
                    fontWeight: FontWeight.bold,
                    fontSize: AppFontSize.f20,
                    color: AppColors.primary,
                  ),
                  Gap(AppHeight.h10),
                  CustomTextFormField(
                    label: AppStrings.newPassword,
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
                  Gap(AppHeight.h82),
                  StreamBuilder(
                    stream: _authController.loadingMapStream,
                    builder: (context, asyncSnapshot) {
                      return Align(
                        alignment: AlignmentGeometry.center,
                        child: CustomButton(
                          text: AppStrings.submit,
                          onPressed: () => _authController.createNewPassword(
                            context: context,
                            email: _email,
                          ),
                          isLoading: asyncSnapshot
                              .data?[ButtonsLoadingKeys.createNewPassword],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
