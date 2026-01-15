import 'package:animooo/controllers/auth_controller.dart';
import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/resources/app_strings.dart';
import 'package:animooo/core/widgets/custom_button.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:animooo/core/widgets/custom_text_form_field.dart';
import 'package:animooo/views/auth/widgets/forget_password_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  late AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = AuthController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ForgetPasswordAppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.pw10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: AppStrings.forgetYourPassword,
                  fontFamily: AppFonts.otamaEp,
                  fontWeight: FontWeight.bold,
                  fontSize: AppFontSize.f20,
                  color: AppColors.primary,
                ),
                Gap(AppHeight.h8),
                CustomText(
                  text: AppStrings.forgetPasswordDes,
                  fontFamily: AppFonts.poppins,
                  fontSize: AppFontSize.f14,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w400,
                ),
                Gap(AppHeight.h58),
                Form(
                  key: _authController.forgetPasswordFormKey,
                  child: CustomTextFormField(
                    label: AppStrings.email,
                    hint: AppStrings.enterYourEmailAddress,
                    validator: _authController.validateEmail,
                    controller: _authController.emailController,
                  ),
                ),
                Gap(AppHeight.h150),
                CustomButton(
                  text: AppStrings.sendCode,
                  onPressed: () =>
                      _authController.forgetPassword(context: context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
