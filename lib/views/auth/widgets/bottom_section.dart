import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/resources/app_strings.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class BottomSection extends StatelessWidget {
  const BottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          text: AppStrings.do_not_have_account,
          fontSize: AppFontSize.f14,
          color: AppColors.secondary,
          fontFamily: AppFonts.poppins,
        ),
        TextButton(
          onPressed: () {},
          child: CustomText(
            text: AppStrings.signup,
            fontSize: AppFontSize.f14,
            color: AppColors.primary,
            fontFamily: AppFonts.poppins,
            underLined: true,
          ),
        ),
      ],
    );
  }
}
