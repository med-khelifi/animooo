import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/resources/app_strings.dart';
import 'package:animooo/core/widgets/custom_button.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:animooo/core/widgets/named_app_logo.dart';
import 'package:animooo/views/auth/widgets/custom_clickable_text.dart';
import 'package:animooo/views/auth/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        bottomNavigationBar: CustomClickableText(
          text: AppStrings.doNotHaveAccount,
          clickableText: AppStrings.signupNow,
          onTap: () {},
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.pw18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                NamedAppLogo(),
                Gap(AppHeight.h30),
                CustomText(
                  text: AppStrings.login,
                  fontSize: AppFontSize.f38,
                  fontFamily: AppFonts.otamaEp,
                  color: AppColors.blackColor,
                ),
                Gap(AppHeight.h10),
                CustomTextFormField(
                  label: AppStrings.email,
                  hint: AppStrings.enterYourEmailAddress,
                ),
                Gap(AppHeight.h16),
                CustomTextFormField(
                  label: AppStrings.password,
                  hint: AppStrings.enterYourPassword,
                  isPassword: true,
                ),
                Padding(
                  padding: EdgeInsets.only(right: AppPadding.pw18),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: CustomText(
                        text: AppStrings.forgotPassword,
                        fontSize: AppFontSize.f12,
                        color: AppColors.primary,
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.w600,
                        underLined: true,
                      ),
                    ),
                  ),
                ),
                Gap(AppHeight.h30),
                CustomButton(text: AppStrings.login, onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
