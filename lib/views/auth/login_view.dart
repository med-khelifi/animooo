import 'package:animooo/core/resources/app_assets.dart';
import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/resources/app_strings.dart';
import 'package:animooo/core/widgets/custom_button.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:animooo/views/auth/widgets/bottom_section.dart';
import 'package:animooo/views/auth/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.p10),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppAssets.logoSVG,
                  height: AppHeight.h70,
                  width: AppWidth.w72,
                ),
                CustomText(
                  text: AppStrings.appName,
                  fontSize: AppFontSize.f12,
                  color: AppColors.primary,
                ),
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
                  hint: AppStrings.enter_your_email_address,
                ),
                Gap(AppHeight.h16),
                CustomTextFormField(
                  label: AppStrings.password,
                  hint: AppStrings.enter_your_password,
                  isPassword: true,
                ),
                Padding(
                  padding: EdgeInsets.only(right: AppPadding.p18),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: CustomText(
                        text: AppStrings.forgot_password,
                        fontSize: AppFontSize.f12,
                        color: AppColors.primary,
                        fontFamily: AppFonts.poppins,
                        underLined: true,
                      ),
                    ),
                  ),
                ),
                Gap(AppHeight.h30),
                CustomButton(text: AppStrings.login, onPressed: () {}),
                Spacer(),
                BottomSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
