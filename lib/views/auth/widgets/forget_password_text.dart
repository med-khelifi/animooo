
import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/resources/app_strings.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class ForgetPasswordText extends StatelessWidget {
  const ForgetPasswordText({super.key, this.onTap});
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: AppPadding.pw18, top: AppPadding.ph8),
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: onTap,
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
    );
  }
}
