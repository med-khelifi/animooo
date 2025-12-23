import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/resources/app_strings.dart';
import 'package:animooo/core/widgets/custom_button.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:animooo/views/auth/widgets/create_new_password_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:gap/gap.dart';

class OtpVerificationView extends StatelessWidget {
  const OtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CreateNewPasswordAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.pw10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: AppStrings.otpVerification,
                fontFamily: AppFonts.otamaEp,
                fontWeight: FontWeight.bold,
                fontSize: AppFontSize.f20,
                color: AppColors.primary,
              ),
              Gap(AppHeight.h8),
              CustomText(
                text: AppStrings.otpVerificationDes,
                fontFamily: AppFonts.poppins,
                fontSize: AppFontSize.f14,
                color: AppColors.secondary,
                fontWeight: FontWeight.w400,
              ),
              Gap(AppHeight.h54),
              OtpTextField(
                numberOfFields: 5,
                margin: EdgeInsetsGeometry.symmetric(
                  horizontal: AppPadding.pw8,
                ),
                showFieldAsBox: true,
                fieldWidth: AppWidth.w52,
                fieldHeight: AppHeight.h54,
                borderColor: AppColors.secondary,
                borderRadius: BorderRadius.circular(AppRadius.r10),
                focusedBorderColor: AppColors.primary,
                onSubmit: (value) {},
              ),
              Gap(AppHeight.h40),
              CustomButton(text: AppStrings.confirm, onPressed: () {}),
              Align(
                alignment: Alignment.center,
                child: CustomText(
                  text: AppStrings.resendCode,
                  fontFamily: AppFonts.poppins,
                  fontSize: AppFontSize.f12,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
