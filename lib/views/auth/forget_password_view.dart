import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_routes.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/resources/app_strings.dart';
import 'package:animooo/core/widgets/custom_button.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:animooo/core/widgets/custom_text_form_field.dart';
import 'package:animooo/views/auth/widgets/forget_password_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

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
                CustomTextFormField(
                  label: AppStrings.email,
                  hint: AppStrings.enterYourEmailAddress,
                ),
                Gap(AppHeight.h150),
                CustomButton(
                  text: AppStrings.sendCode,
                  onPressed: () {
                    Navigator.pushNamed(context, RoutesNames.otpVerification);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
