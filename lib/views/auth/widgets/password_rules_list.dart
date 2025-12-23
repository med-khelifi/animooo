import 'package:animooo/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/resources/app_strings.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:animooo/views/auth/widgets/custom_pointed_text.dart';
import 'package:gap/gap.dart';

class PasswordRulesList extends StatelessWidget {
  const PasswordRulesList({super.key, required this.passwordRules});
  final Map<PasswordRules, (String rule, bool isValid)> passwordRules;
  @override
  Widget build(BuildContext context) {
    bool allValid = passwordRules.values.every((rule) => rule.$2);
    return Align(
      alignment: AlignmentGeometry.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!allValid)
            CustomText(
              text: AppStrings.pleaseAddAllNecessaryCharacters,
              fontFamily: AppFonts.poppins,
              fontSize: AppFontSize.f10,
              fontWeight: FontWeight.w700,
              color: AppColors.red,
            ),
          Gap(allValid ? AppHeight.h0 : AppHeight.h10),
          for (var rule in passwordRules.values)
            CustomPointedText(text: rule.$1, isValid: rule.$2),
        ],
      ),
    );
  }
}
