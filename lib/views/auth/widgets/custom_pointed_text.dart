// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/widgets/custom_text.dart';

class CustomPointedText extends StatelessWidget {
  const CustomPointedText({super.key, required this.text, this.isValid});
  final String text;
  final bool? isValid;
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Icon(
              Icons.circle,
              size: AppFontSize.f8,
              color: isValid ?? false ? AppColors.green : AppColors.red,
            ),
          ),
          WidgetSpan(child: SizedBox(width: AppWidth.w5)),
          WidgetSpan(
            child: CustomText(
              text: text,
              fontSize: AppFontSize.f10,
              fontFamily: AppFonts.poppins,
              color: isValid ?? false ? AppColors.green : AppColors.red,
              decoration: isValid ?? false ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );
  }
}
