import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomClickableText extends StatelessWidget {
  const CustomClickableText({
    super.key,
    required this.text,
    required this.clickableText,
    required this.onTap,
    this.textAlign = TextAlign.center,
  });
  final String text;
  final String clickableText;
  final void Function() onTap;
  final TextAlign textAlign;
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        children: [
          WidgetSpan(
            child: CustomText(
              text: text,
              fontSize: AppFontSize.f14,
              fontFamily: AppFonts.poppins,
              color: AppColors.secondary,
              fontWeight: FontWeight.w400,
            ),
          ),
          WidgetSpan(
            child: GestureDetector(
              onTap: onTap,
              child: CustomText(
                text: clickableText,
                fontSize: AppFontSize.f14,
                fontFamily: AppFonts.poppins,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                underLined: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
