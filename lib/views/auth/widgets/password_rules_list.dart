import 'package:flutter/material.dart';
import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/resources/app_strings.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:animooo/views/auth/widgets/custom_pointed_text.dart';
import 'package:gap/gap.dart';

class PasswordRulesList extends StatelessWidget {
  const PasswordRulesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: CustomText(
            text: AppStrings.pleaseAddAllNecessaryCharacters,
            fontFamily: AppFonts.poppins,
            fontSize: AppFontSize.f10,
            fontWeight: FontWeight.w700,
            color: AppColors.red,
          ),
        ),
        Gap(AppHeight.h10),
        CustomPointedText(text: AppStrings.minimumCharacter12),
        CustomPointedText(text: AppStrings.oneUppercaseCharacter),
        CustomPointedText(text: AppStrings.oneLowercaseCharacter),
        CustomPointedText(text: AppStrings.oneSpecialCharacter),
        CustomPointedText(text: AppStrings.oneNumber),
      ],
    );
  }
}
