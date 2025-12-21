import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/resources/app_strings.dart';
import 'package:animooo/core/widgets/custom_button.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:animooo/views/auth/widgets/create_new_password_app_bar.dart';
import 'package:animooo/views/auth/widgets/custom_text_form_field.dart';
import 'package:animooo/views/auth/widgets/password_rules_list.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CreateNewPasswordView extends StatelessWidget {
  const CreateNewPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CreateNewPasswordAppBar(),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.pw10),
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
                Gap(AppHeight.h82),
                CustomButton(text: AppStrings.submit, onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
