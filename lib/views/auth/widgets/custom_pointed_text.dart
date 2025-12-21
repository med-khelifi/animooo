// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/widgets/custom_text.dart';

class CustomPointedText extends StatelessWidget {
  const CustomPointedText({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.circle, size: AppFontSize.f8, color: AppColors.green),
        Gap(AppWidth.w5),
        CustomText(
          text: text,
          fontSize: AppFontSize.f10,
          fontFamily: AppFonts.poppins,
          color: AppColors.red,
        ),
      ],
    );
  }
}
