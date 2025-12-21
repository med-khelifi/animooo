import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/resources/app_strings.dart';
import 'package:animooo/core/widgets/custom_button.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:animooo/core/widgets/named_app_logo.dart';
import 'package:animooo/views/auth/widgets/custom_clickable_text.dart';
import 'package:animooo/views/auth/widgets/custom_text_form_field.dart';
import 'package:animooo/views/auth/widgets/password_rules_list.dart';
import 'package:animooo/views/auth/widgets/select_image_box.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.pw10),
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
                ),
                Gap(AppHeight.h16),
                CustomTextFormField(
                  label: AppStrings.lastName,
                  hint: AppStrings.enterYourLastName,
                ),
                Gap(AppHeight.h16),
                CustomTextFormField(
                  label: AppStrings.email,
                  hint: AppStrings.enterYourEmailAddress,
                ),
                Gap(AppHeight.h16),
                CustomTextFormField(
                  label: AppStrings.phone,
                  hint: AppStrings.enterYourPhone,
                ),
                Gap(AppHeight.h16),
                CustomTextFormField(
                  label: AppStrings.password,
                  hint: AppStrings.enterYourPassword,
                  isPassword: true,
                ),
                Gap(AppHeight.h8),
                PasswordRulesList(),
                Gap(AppHeight.h16),
                CustomTextFormField(
                  label: AppStrings.confirmPassword,
                  hint: AppStrings.confirmYourPassword,
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
                SelectImageBox(),
                Gap(AppHeight.h28),
                CustomButton(text: AppStrings.signup, onPressed: () {}),
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
    );
  }
}
